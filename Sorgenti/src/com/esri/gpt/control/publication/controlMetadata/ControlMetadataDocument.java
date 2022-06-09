package com.esri.gpt.control.publication.controlMetadata;

import com.esri.gpt.framework.context.RequestContext;
import com.esri.gpt.framework.sql.ManagedConnection;
import java.io.*;
import java.net.URL;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import javax.faces.model.SelectItem;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;
import org.json.*;
import org.xml.sax.InputSource;


public class ControlMetadataDocument {

    private String cnpaName = "";
    private RequestContext context;
    private String name = "";
    private Document xmlDocument;

    // Fields to be verified
    private final String[] expressions = {
        "/MD_Metadata/fileIdentifier/CharacterString/text()",
        "/MD_Metadata/parentIdentifier/CharacterString/text()",
        "/MD_Metadata/identificationInfo//citation/CI_Citation/identifier//code/CharacterString/text()",
        "/MD_Metadata/identificationInfo//citation/CI_Citation/series/CI_Series/issueIdentification/CharacterString/text()"
    };

    
    // Relative errors to be printed
    private final String[] expressionsError = {
        "catalog.publication.codIPA.FileID",
        "catalog.publication.codIPA.ParentID",
        "catalog.publication.codIPA.DataID",
        "catalog.publication.codIPA.IssueID"
    };

    private final ArrayList<String> errorMessage = new ArrayList<String>();
    
    private final String paNameExpression = "/MD_Metadata/identificationInfo//citation/CI_Citation/citedResponsibleParty/CI_ResponsibleParty[role/CI_RoleCode/@codeListValue=\"owner\"]/organisationName/CharacterString/text()";

    public ControlMetadataDocument(RequestContext context, String xmlString ) throws IOException, JSONException, ParserConfigurationException, SAXException {
        
        this.context = context;
       
        this.xmlDocument = ControlMetadataDocument.convertStringToDocument(xmlString);
        
    }
    
    private static Document convertStringToDocument(String xmlStr) {
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();  
        DocumentBuilder builder;  
        try  
        {  
            builder = factory.newDocumentBuilder();  
            Document doc = builder.parse( new InputSource( new StringReader( xmlStr ) ) ); 
            return doc;
        } catch (IOException | ParserConfigurationException | SAXException e) {  
            return null; 
        } 
        
    }

    // Funzione richiamata dagli altri moduli per la verifica dei nomi
    // Per ogni espressione richiama la funzione di validazione
    public boolean getStatus(){
        // Prendo il nome dell'ente responsabile dall'XML
        boolean nomeInXMLTrovato = this.getName();
                
        try{
            // Prendo il codice IPA dal DB usando il nome ente. Se non lo trovo allora vuol dire che l'ente non è presente
            this.setCnpaName();
            // Se il nome c'è e non è nullo allora vado avanti altrimenti ritorno subito errore senza verificare niente altro
            if(nomeInXMLTrovato && !"".equals(this.cnpaName)){
                // Verifico le altre condizioni
                for (int i=0; i<this.expressions.length; i++) {
                    String expression = this.expressions[i];
                    String expressionsError = this.expressionsError[i];
                    
                    if(!this.xpathValidation(expression, false)){
                        nomeInXMLTrovato = false; 
                        this.setErrorMessage(expressionsError);
                    }
                }
            } else return false;
        }catch (IOException | ParserConfigurationException | XPathExpressionException | SAXException e){
            nomeInXMLTrovato = false;
        }
        
        return nomeInXMLTrovato;
    }
    
    public ArrayList<String> getErrorMessage(){
        return this.errorMessage;
    }
    
    private void setErrorMessage(String error){
        this.errorMessage.add(error);
    }

    // Funzione usata per controllare sia gli xpath in expression che paNameExpression
    // expression: XPath
    // controlName: true se va verificato il nome ente, false altrimenti
    // NOTA: se il campo non viene trovato non è errore perché alcuni campi sono opzionali 
    // e comunque vengono verificati dallo schematron
    // Esri Italia Modifica 22/02: i codici sono case insensitive; inoltre se il valore del nodo è un URI allora basta che il codic IPA ci sia
    public boolean xpathValidation(String expression,boolean controlName) throws IOException, ParserConfigurationException, SAXException, XPathExpressionException{
        if(this.xmlDocument == null){
            return false;
        }
        
        XPath xPath = XPathFactory.newInstance().newXPath();

        NodeList nodeList = (NodeList) xPath.compile(expression).evaluate(xmlDocument, XPathConstants.NODESET);
        // If not found it might be optional, ISO+schematron will take care of this
        if(nodeList.item(0) == null){
                return true;
        }else {
            String nodeValue = nodeList.item(0).getNodeValue();
            // Se richiesto controlla che ci sia il nome dell'ente resposnabile. 
            if(controlName){
                this.name = nodeValue;
                return true;
            }
            String valore = nodeValue.toLowerCase();
            boolean status;
            // Se il valore inizia con http o http allora è un URI allora verifica solo che il codice sia contenuto
            // altrimenti verifica che inizi con il codice seguito da ":"
            if (valore.startsWith("http")){
                status = valore.contains(this.cnpaName.toLowerCase());
            }
            else{
                status = valore.startsWith(this.cnpaName.concat(":").toLowerCase());
            }
            return status;
        }
    }

    // Controlla il nome dell'ente responsabile
    private boolean getName() {
        boolean status = false;
        try{
            status = this.xpathValidation(this.paNameExpression,true);
        }catch (IOException | ParserConfigurationException | XPathExpressionException | SAXException e){
            status = false;
        }
        
        if(!status) this.setErrorMessage("catalog.publication.NomeEnte.Responsabile");

        return status;
    }

    // Prende il codice IPA cercando il nome presente nell'XML. 
    // Se la query fallisce vuol dire che l'ente responsabile non è nel sistema
    private void setCnpaName(){
        
        try{
            ManagedConnection mc = this.context.getConnectionBroker().returnConnection("");
            Connection con = mc.getJdbcConnection();

            ResultSet rs = null;
            PreparedStatement st = null;

            // initializ
//   Sostituita per evitare SQLInjection         String strSQL ="SELECT COD_IPA FROM gpt_pa WHERE NOME='"+this.name+"' LIMIT 1";
            
            st = con.prepareStatement("SELECT COD_IPA FROM gpt_pa WHERE NOME = ? LIMIT 1");
            st.setString(1, this.name);
            rs = st.executeQuery();

            while (rs.next()) {
                this.cnpaName = rs.getString("COD_IPA").toLowerCase();    
            }
            
            if("".equals(this.cnpaName)){
                this.setErrorMessage("catalog.publication.NomeEnte.Responsabile");
            }
        }catch(Exception e){
            this.setErrorMessage("catalog.publication.NomeEnte.Responsabile");
        }
        
    }


}
