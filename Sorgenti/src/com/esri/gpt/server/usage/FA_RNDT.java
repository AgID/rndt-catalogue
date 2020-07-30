/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.esri.gpt.server.usage;

import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.json.Json;
import javax.json.JsonReader;
import org.codehaus.jackson.map.ObjectMapper;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.XML;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.Marshaller;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;

@JsonPropertyOrder({ "NumeroAccessiTotalePA", "ElencoAmministrazioniAccessi", "ElencoSessioniAccesso", "NumeroDocumentiCaricati", "ElencoDocumentiPerOperazione" })
@XmlType (propOrder={ "NumeroAccessiTotalePA", "ElencoAmministrazioniAccessi", "ElencoSessioniAccesso", "NumeroDocumentiCaricati", "ElencoDocumentiPerOperazione" })
@XmlRootElement
public class FA_RNDT {
    public String NumeroAccessiTotalePA="";
    public clsElencoAmministrazioniAccessi ElencoAmministrazioniAccessi = new clsElencoAmministrazioniAccessi();
    public clsElencoSessioniAccesso ElencoSessioniAccesso = new clsElencoSessioniAccesso();
    public int NumeroDocumentiCaricati=0;
    public clsElencoDocumentiPerOperazione ElencoDocumentiPerOperazione = new clsElencoDocumentiPerOperazione();
    public clsElencoDocumentiPerAmministrazione ElencoDocumentiPerAmministrazione =  new clsElencoDocumentiPerAmministrazione();
    public clsElencoDocumentiPerMetodoAccesso ElencoDocumentiPerMetodoAccesso= new clsElencoDocumentiPerMetodoAccesso();
    public int NumeroMetadati=0;
    public clsElencoMetadatiPerTipologia ElencoMetadatiPerTipologia= new clsElencoMetadatiPerTipologia();
    public clsElencoMetadatiPerAmministrazioni ElencoMetadatiPerAmministrazioni = new clsElencoMetadatiPerAmministrazioni();
    public clsElencoMetadatiPerCategorieTematiche ElencoMetadatiPerCategorieTematiche=new clsElencoMetadatiPerCategorieTematiche();
    public clsElencoMetadatiPerTemiINSPIRE ElencoMetadatiPerTemiINSPIRE=new clsElencoMetadatiPerTemiINSPIRE();
    public clsElencoMetadatiPerTassonomiaISO19119 ElencoMetadatiPerTassonomiaISO19119=new clsElencoMetadatiPerTassonomiaISO19119();
    public clsElencoMetadatiPerTipologiaServizio ElencoMetadatiPerTipologiaServizio= new clsElencoMetadatiPerTipologiaServizio();
    
    
    public class clsElencoAmministrazioniAccessi{
        public List<clsItemAmministrazioniAccessi> item = new ArrayList<clsItemAmministrazioniAccessi>();
    }

    public class clsItemAmministrazioniAccessi{
        public String Amministrazione="";
        public int NumeroAccessiAmministrazione=0;
    }
    public clsItemAmministrazioniAccessi createclsItemAmministrazioniAccessi(){
        return new clsItemAmministrazioniAccessi();
    }
    public class clsElencoSessioniAccesso{
        public List<clsItemElencoSessioniAccesso> item = new ArrayList<clsItemElencoSessioniAccesso>();
    }

    @JsonPropertyOrder({ "Amministrazione", "DurataSessione" })
    public class clsItemElencoSessioniAccesso{
        public String Amministrazione="";
        public int DurataSessione=0;
    }
    public clsItemElencoSessioniAccesso createclsItemElencoSessioniAccesso(){
        return new clsItemElencoSessioniAccesso();
    }    
    public class clsElencoDocumentiPerOperazione{
        public List<clsItemElencoDocumentiPerOperazione> item = new ArrayList<clsItemElencoDocumentiPerOperazione>();
    }
    public class clsItemElencoDocumentiPerOperazione{
        public String Operazione="";
        public int NumeroDocumenti=0;
    }
    public clsItemElencoDocumentiPerOperazione createclsItemElencoDocumentiPerOperazione(){
        return new clsItemElencoDocumentiPerOperazione();
    }
    public class clsElencoDocumentiPerAmministrazione{
        public List<clsItemElencoDocumentiPerAmministrazione> item = new ArrayList<clsItemElencoDocumentiPerAmministrazione>();
    }
    public class clsItemElencoDocumentiPerAmministrazione{
        public String Amministrazione="";
        public int NumeroDocumenti=0;
    }
    public clsItemElencoDocumentiPerAmministrazione createclsItemElencoDocumentiPerAmministrazione(){
        return new clsItemElencoDocumentiPerAmministrazione();
    }
    
    public class clsElencoDocumentiPerMetodoAccesso{
        public List<clsItemElencoDocumentiPerMetodoAccesso> item = new ArrayList<clsItemElencoDocumentiPerMetodoAccesso>();
    }
    public class clsItemElencoDocumentiPerMetodoAccesso{
        public String MetodoAccesso="";
        public int NumeroDocumenti=0;
    }
    public clsItemElencoDocumentiPerMetodoAccesso createclsItemElencoDocumentiPerMetodoAccesso(){
        return new clsItemElencoDocumentiPerMetodoAccesso();
    }
    

    public class clsElencoMetadatiPerTipologia{
        public List<clsItemElencoMetadatiPerTipologia> item = new ArrayList<clsItemElencoMetadatiPerTipologia>();
    }
    public class clsItemElencoMetadatiPerTipologia{
        public String Tipologia="";
        public int NumeroPerTipologia=0;
    }
    public clsItemElencoMetadatiPerTipologia createclsItemElencoMetadatiPerTipologia(){
        return new clsItemElencoMetadatiPerTipologia();
    }

    public class clsElencoMetadatiPerAmministrazioni{
        public List<clsItemElencoMetadatiPerAmministrazioni> item = new ArrayList<clsItemElencoMetadatiPerAmministrazioni>();
    }
    public class clsItemElencoMetadatiPerAmministrazioni{
        public String Amministrazione="";
        public int NumeroPerAmministrazione=0;
    }
    public clsItemElencoMetadatiPerAmministrazioni createclsItemElencoMetadatiPerAmministrazioni(){
        return new clsItemElencoMetadatiPerAmministrazioni();
    }
    
    public class clsElencoMetadatiPerCategorieTematiche{
        public List<clsItemElencoMetadatiPerCategorieTematiche> item = new ArrayList<clsItemElencoMetadatiPerCategorieTematiche>();
    }
    public class clsItemElencoMetadatiPerCategorieTematiche{
        public String Categoria="";
        public int NumeroPerCategoria=0;
    }
    public clsItemElencoMetadatiPerCategorieTematiche createclsItemElencoMetadatiPerCategorieTematiche(){
        return new clsItemElencoMetadatiPerCategorieTematiche();
    }
    
    public class clsElencoMetadatiPerTemiINSPIRE{
        public List<clsItemElencoMetadatiPerTemiINSPIRE> item = new ArrayList<clsItemElencoMetadatiPerTemiINSPIRE>();
    }
    public class clsItemElencoMetadatiPerTemiINSPIRE{
        public String TemaINSPIRE="";
        public int NumeroPerTemaINSPIRE=0;
    }
    public clsItemElencoMetadatiPerTemiINSPIRE createclsItemElencoMetadatiPerTemiINSPIRE(){
        return new clsItemElencoMetadatiPerTemiINSPIRE();
    }
    public clsItemElencoMetadatiPerTassonomiaISO19119 createclsItemElencoMetadatiPerTassonomiaISO19119(){
        return new clsItemElencoMetadatiPerTassonomiaISO19119();
    }
    
    public class clsElencoMetadatiPerTassonomiaISO19119{
        public List<clsItemElencoMetadatiPerTassonomiaISO19119> item = new ArrayList<clsItemElencoMetadatiPerTassonomiaISO19119>();
    }
    public class clsItemElencoMetadatiPerTassonomiaISO19119{
        public String TassonomiaISO19119="";
        public int NumeroPerTassonomiaISO19119=0;
    }
    
    public class clsElencoMetadatiPerTipologiaServizio{
        public List<clsItemElencoMetadatiPerTipologiaServizio> item = new ArrayList<clsItemElencoMetadatiPerTipologiaServizio>();
    }
    public class clsItemElencoMetadatiPerTipologiaServizio{
        public String TipologiaServizio="";
        public int NumeroPerTipologiaServizio=0;
    }    
    public clsItemElencoMetadatiPerTipologiaServizio createclsItemElencoMetadatiPerTipologiaServizio(){
        return new clsItemElencoMetadatiPerTipologiaServizio();
    }
    
    public String generateString(){
        String ret="";
        StringBuilder  sb = new StringBuilder();
        ObjectMapper mapper = new ObjectMapper();
        
        try {
            ret= mapper.writeValueAsString(this);
        } catch (IOException ex) {
            Logger.getLogger(FA_RNDT.class.getName()).log(Level.SEVERE, null, ex);
        }
        return ret;
    }
    public String generateXmlString(){
        String ret="";
        try {
            JSONObject js = new JSONObject(this.generateString());
            ret = XML.toString(js);
            ret="<?xml version=\"1.0\" encoding=\"utf-8\" ?><FA_RNDT xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">" + ret + "</FA_RNDT>";
        } catch (JSONException ex) {
            Logger.getLogger(FA_RNDT.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return ret;
    }
}

