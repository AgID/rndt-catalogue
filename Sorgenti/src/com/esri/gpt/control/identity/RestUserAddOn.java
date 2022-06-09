/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.esri.gpt.control.identity;

import com.esri.gpt.control.publication.supportForMetadata;
import com.esri.gpt.framework.context.BaseServlet;
import com.esri.gpt.framework.context.RequestContext;
import com.esri.gpt.framework.sql.BaseDao;
import com.esri.gpt.framework.sql.ManagedConnection;
import com.esri.gpt.framework.context.ApplicationContext;
import static com.esri.gpt.framework.util.DateProxy.DEFAULT_TIME_FORMAT;																		
import com.esri.gpt.framework.util.Val;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.lang3.StringUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author Administrator
 */
public class RestUserAddOn extends BaseServlet {
// properties ==================================================================

    // methods =====================================================================
    /**
     * Initializes servlet.
     * @param config servlet configuration
     * @throws ServletException if error initializing servlet
     */
    @Override
    public void init(ServletConfig config) throws ServletException {
      super.init(config);  
    }
    
    @SuppressWarnings("unused")
    @Override
    protected void execute(HttpServletRequest request,
                         HttpServletResponse response,
                         RequestContext context)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String[] uriParts = request.getRequestURI().toString().split("/");
        // User used to bypas auyhentication. If null set to "noAuth" 
        String userNoAuth = context.getCatalogConfiguration().getSearchConfig().getUserNoAuth();
      
        if (userNoAuth == null ||  userNoAuth.equalsIgnoreCase(""))
            userNoAuth= "noAuth";

        /**
         * GetAllPA
         * ritorna la lista di tutte le PA ordinate per nome
         * Parametri:
         * nome: Opzionale. Stringa parziale del nome (utilizzatoa con like %nome%
         * Output:
         * id: ID della PA (id del record)
         * nomePA: nome della PA
         * cnPA: Codice IPA della PA
         * Autenticazione:
         * Non richiesta
         */
        if (uriParts[uriParts.length-1].equalsIgnoreCase("getAllPA")){
            Logger.getLogger(RestUserAddOn.class.getName()).log(Level.FINEST, "Method getAllPA entered", (Throwable)null);
            ManagedConnection mc;
            ResultSet rs = null;
            PreparedStatement st = null;
            JSONArray arr = new JSONArray();
            try {
                mc = context.getConnectionBroker().returnConnection("");
                Connection con = mc.getJdbcConnection();

                // initialize
                String strSQL ="SELECT ID, NOME, cod_ipa FROM gpt_pa";
                if (request.getParameterMap().containsKey("nome")){
                    String whereC = request.getParameter("nome");
                    if (!whereC.isEmpty()){
                        strSQL += " WHERE NOME like '%" + whereC + "%'";
                    }
                }
                strSQL += " ORDER BY NOME";
                st = con.prepareStatement(strSQL);
                Logger.getLogger(RestUserAddOn.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);
                rs = st.executeQuery();
                
                while (rs.next()) {
                    JSONObject jsonObj = new JSONObject();
                    jsonObj.put("id", rs.getInt("ID"));
                    jsonObj.put("nomePA", rs.getString("NOME"));
                    jsonObj.put("cnPA", rs.getString("cod_ipa"));
                    arr.put(jsonObj);
                }

            } catch (SQLException ex) {
                Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex);
            } catch (JSONException ex) {
                Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex);
            } finally {
                BaseDao.closeResultSet(rs);
                BaseDao.closeStatement(st);
                String jsonPrettyPrintString;
                try {
                    jsonPrettyPrintString = arr.toString(4);
                    response.getWriter().write(jsonPrettyPrintString);
                } catch (JSONException ex) {
                    Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex);
                }
                
            }
        }		
	/**
         * getCSVResults
         * ritorna tutti gli utenti di una PA ordinati per USERNAME
         * Parametri:
         * Title: Stringa parziale del nome utente (utilizzatoa con like %nome%)
         * FileIdetifier:
         * CatalogueID:
         * MetadataID:
         * DocOwner:
         * PublicMethod:
         * ProtocolType:
         * UpdateDataStart:
         * UpdateDataFine:
         */
        else if (uriParts[uriParts.length-1].equalsIgnoreCase("getCSVResults")){
            //TITOLO;PROPRIETARIO;STATO;METODO
            Logger.getLogger(RestUserAddOn.class.getName()).log(Level.FINEST, "Method getCSVResults entered", (Throwable)null);
            ManagedConnection mc;
            ResultSet rs = null;
            PreparedStatement st = null;
            JSONArray arr = new JSONArray();
            try {
                mc = context.getConnectionBroker().returnConnection("");
                Connection con = mc.getJdbcConnection();
                // initialize
                String Title ="";
                String FileIdetifier="";
                String CatalogueID="";
                String MetadataID="";
                String Ente="";
                String DocOwner="";
                String PublicMethod="";
                String ProtocolType="";
                String UpdateDataStart="";
                String UpdateDataFine="";

                if (request.getParameterMap().containsKey("Title")) Title = request.getParameter("Title").toString();
                if (request.getParameterMap().containsKey("FileIdetifier")) FileIdetifier = request.getParameter("FileIdetifier").toString();
                if (request.getParameterMap().containsKey("CatalogueID")) CatalogueID = request.getParameter("CatalogueID").toString();
                if (request.getParameterMap().containsKey("MetadataID")) MetadataID = request.getParameter("MetadataID").toString();
                if (request.getParameterMap().containsKey("Ente")) Ente = request.getParameter("Ente").toString();
                if (request.getParameterMap().containsKey("DocOwner")) DocOwner = request.getParameter("DocOwner").toString();
                if (request.getParameterMap().containsKey("PublicMethod")) PublicMethod = request.getParameter("PublicMethod").toString();
                if (request.getParameterMap().containsKey("ProtocolType")) ProtocolType = request.getParameter("ProtocolType").toString();
                if (request.getParameterMap().containsKey("UpdateDataStart")) UpdateDataStart = request.getParameter("UpdateDataStart").toString();
                if (request.getParameterMap().containsKey("UpdateDataFine")) UpdateDataFine = request.getParameter("UpdateDataFine").toString();

                String sql = "SELECT a.TITLE, b.USERNAME, a.APPROVALSTATUS,a.PUBMETHOD,a.UPDATEDATE FROM gpt_resource a, gpt_user b WHERE a.OWNER = b.USERID ";

                Integer i = 1;
                if (!Title.isEmpty()) {
                    if(i++!=0){ sql+=" AND ";}
                    sql += " a.TITLE LIKE '%"+Title+"%'";
                }
                if (!FileIdetifier.isEmpty()) {
                    if(i++!=0){ sql+=" AND ";}
                    sql += " a.FILEIDENTIFIER='"+FileIdetifier+"'";
                }
                if (!CatalogueID.isEmpty()) {
                    if(i++!=0){ sql+=" AND ";}
                    sql += " a.SITEUUID='"+CatalogueID+"'";
                }
                if (!MetadataID.isEmpty()) {
                    if(i++!=0){ sql+=" AND ";}
                    sql += " a.DOCUUID='"+MetadataID+"'";
                }
                if (!DocOwner.isEmpty()) {
                    if(i++!=0){ sql+=" AND ";}
                    sql += " b.DN='"+DocOwner+"'";
                }
                if (!Ente.isEmpty()) {
                    if(i++!=0){ sql+=" AND ";}

                    String subPA = "SELECT ID FROM gpt_pa WHERE nome = '"+Ente+"'";
                    sql += " a.OWNER IN (SELECT USERID FROM gpt_user WHERE FK_IDPA in ("+subPA+"))";
                }
                if (!PublicMethod.isEmpty()) {
                    if(i++!=0){ sql+=" AND ";}
                    sql += " a.PUBMETHOD='"+PublicMethod+"'";
                }
                if (!ProtocolType.isEmpty()) {
                    if(i++!=0){ sql+=" AND ";}
                    sql += " a.APPROVALSTATUS='"+ProtocolType+"'";
                }
                if (!UpdateDataStart.isEmpty()) {
                    if(i++!=0){ sql+=" AND ";}
                    SimpleDateFormat format = new SimpleDateFormat(DEFAULT_TIME_FORMAT);
                    sql += " a.UPDATE > '"+format.format(UpdateDataStart)+"'";
                }
                if (!UpdateDataFine.isEmpty()) {
                    if(i++!=0){ sql+=" AND ";}
                    SimpleDateFormat format = new SimpleDateFormat(DEFAULT_TIME_FORMAT);
                    sql += " a.UPDATE < '"+format.format(UpdateDataFine)+"'";
                }

                Logger.getLogger(RestUserAddOn.class.getName()).log(Level.FINEST, "QUERY: "+sql, (Throwable)null);

                st = con.prepareStatement(sql);
                //Logger.getLogger(RestUserAddOn.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);
                rs = st.executeQuery();

                while (rs.next()) {
                    JSONObject jsonObj = new JSONObject();
                    jsonObj.put("TITLE", rs.getString("TITLE"));
                    jsonObj.put("USERNAME", rs.getString("USERNAME"));
                    jsonObj.put("APPROVALSTATUS", rs.getString("APPROVALSTATUS"));
                    jsonObj.put("PUBMETHOD", rs.getString("PUBMETHOD"));
                    jsonObj.put("UPDATEDATE", rs.getString("UPDATEDATE"));
                    arr.put(jsonObj);
                }

            } catch (SQLException ex) {
                Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex);
            } catch (JSONException ex) {
                Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex);
            } finally {
                BaseDao.closeResultSet(rs);
                BaseDao.closeStatement(st);
                String jsonPrettyPrintString;
                try {
                    jsonPrettyPrintString = arr.toString(4);
                    response.getWriter().write(jsonPrettyPrintString);
                } catch (JSONException ex) {
                    Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }			

         /**
         * getPAFromUser
         * ritorna la PA di un utente
         * Parametri:
         * User: Obbligatorio. Stringa parziale del nome utente (utilizzata con like %nome%)
         * Output:
         * id: ID della PA (id del record)
         * nomePA: nome della PA
         * Autenticazione:
         * Non richiesta
         */
        else if (uriParts[uriParts.length-1].equalsIgnoreCase("getPAFromUser")){
            Logger.getLogger(RestUserAddOn.class.getName()).log(Level.FINEST, "Method getPAFromUser entered", (Throwable)null);
            ManagedConnection mc;
            ResultSet rs = null;
            PreparedStatement st = null;
            JSONArray arr = new JSONArray();
            // Verifica parametri
            String nomeUt = "";
            if (request.getParameterMap().containsKey("User"))
                nomeUt = request.getParameter("User");
            if (nomeUt.isEmpty()){
                Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, "Errore parametri getPAFromUser: User mancante", (Throwable)null);
                try {
                    JSONObject jsonObj = new JSONObject();
                    jsonObj.put("id", -1);
                    jsonObj.put("nomePA", "");
                    jsonObj.put("err", "Parametro User mancante");
                    arr.put(jsonObj);
                    response.getWriter().write(arr.toString(4));
                } catch (JSONException ex) {
                    Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex);
                }
                return;
            }     
            try {
                mc = context.getConnectionBroker().returnConnection("");
                Connection con = mc.getJdbcConnection();
                 
                // initialize
                st = con.prepareStatement("SELECT  p.ID, p.NOME FROM gpt_user u inner join gpt_pa p on p.ID = u.FK_IDPA where username like '%"  + nomeUt + "%' ");
                Logger.getLogger(RestUserAddOn.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);
                rs = st.executeQuery();
                
                while (rs.next()) {
                    JSONObject jsonObj = new JSONObject();
                    jsonObj.put("id", rs.getInt("ID"));
                    jsonObj.put("nomePA", rs.getString("NOME"));
                    arr.put(jsonObj);
                }

            } catch (SQLException ex) {
                Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex);
            } catch (JSONException ex) {
                Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex);
            } finally {
                BaseDao.closeResultSet(rs);
                BaseDao.closeStatement(st);
                String jsonPrettyPrintString;
                try {
                    jsonPrettyPrintString = arr.toString(4);
                    response.getWriter().write(jsonPrettyPrintString);
                } catch (JSONException ex) {
                    Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex);
                }
                
            }    
        }
         /**
         * getUserFromPA
         * ritorna tutti gli utenti di una PA ordinati per USERNAME
         * Parametri:
         * PA_ID: Opzionale. identificativo della PA di appartenenza
         * User: Opzionale. Stringa parziale del nome utente (utilizzatoa con like %nome%)
         * Output:
         * id: ID dell'utente (id del record)
         * nomeUtente: nome dell'utente
         * Autenticazione:
         * Non richiesta
         */
        else if (uriParts[uriParts.length-1].equalsIgnoreCase("getUserFromPA")){
            Logger.getLogger(RestUserAddOn.class.getName()).log(Level.FINEST, "Method getUserFromPA entered", (Throwable)null);            
            ManagedConnection mc;
            ResultSet rs = null;
            PreparedStatement st = null;
            JSONArray arr = new JSONArray();
            try {
                mc = context.getConnectionBroker().returnConnection("");
                Connection con = mc.getJdbcConnection();
                // initialize
                String idPA ="";
                String nomeUT="";
                if (request.getParameterMap().containsKey("PA_ID")) idPA = request.getParameter("PA_ID").toString();
                if (request.getParameterMap().containsKey("User")) nomeUT = request.getParameter("User").toString();

                String sql = "SELECT u.USERID, u.USERNAME FROM gpt_user u ";
                if (!idPA.isEmpty()) {
                    sql = sql+ " where u.FK_IDPA=" + idPA;
                }
                if (!nomeUT.isEmpty()) {
                    if (sql.contains("where")){
                        sql = sql + " AND ";
                    } else {
                        sql=sql + " where ";
                    }
                    sql = sql+ " username like '%"  + nomeUT + "%' ";
                }
                sql += " ORDER BY u.USERNAME";
                st = con.prepareStatement(sql);
                Logger.getLogger(RestUserAddOn.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);
                rs = st.executeQuery();
                
                while (rs.next()) {
                    JSONObject jsonObj = new JSONObject();
                    jsonObj.put("id", rs.getInt("USERID"));
                    jsonObj.put("nomeUtente", rs.getString("USERNAME"));
                    arr.put(jsonObj);
                }

            } catch (SQLException ex) {
                Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex);
            } catch (JSONException ex) {
                Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex);
            } finally {
                BaseDao.closeResultSet(rs);
                BaseDao.closeStatement(st);
                String jsonPrettyPrintString;
                try {
                    jsonPrettyPrintString = arr.toString(4);
                    response.getWriter().write(jsonPrettyPrintString);
                } catch (JSONException ex) {
                    Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        } 
         /**
         * getUsersFromString
         * ritorna tutti gli utenti contenenti sottostringa ordinati per USERNAME
         * Parametri:
         * User: Obbligatorio. Stringa parziale del nome utente (utilizzata con like %nome%)
         * Output:
         * id: ID dell'utente (id del record)
         * nomeUtente: nome dell'utente
         * Autenticazione:
         * Non richiesta
         */
        else if (uriParts[uriParts.length-1].equalsIgnoreCase("getUsersFromString")){
            Logger.getLogger(RestUserAddOn.class.getName()).log(Level.FINEST, "Method getUsersFromString entered", (Throwable)null);  
            ManagedConnection mc;
            ResultSet rs = null;
            PreparedStatement st = null;
            JSONArray arr = new JSONArray();
            // Verifica parametri
            String nomeUT ="";
            if (request.getParameterMap().containsKey("User")) 
                nomeUT = request.getParameter("User");
            if (nomeUT.isEmpty()){
                Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, "Errore parametri getUsersFromString: User mancante", (Throwable)null);
                try {
                    JSONObject jsonObj = new JSONObject();
                    jsonObj.put("id", -1);
                    jsonObj.put("nomeUtente", "");
                    jsonObj.put("err", "Parametro User mancante");
                    arr.put(jsonObj);
                    response.getWriter().write(arr.toString(4));
                } catch (JSONException ex) {
                    Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex);
                }
                return;
            }  
            try {
                mc = context.getConnectionBroker().returnConnection("");
                Connection con = mc.getJdbcConnection();
                
                // initialize
                st = con.prepareStatement("SELECT u.USERID, u.USERNAME FROM gpt_user u where username like '%"  + nomeUT + "%' ORDER BY u.USERNAME" );
                Logger.getLogger(RestUserAddOn.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);
                rs = st.executeQuery();

                while (rs.next()) {
                    JSONObject jsonObj = new JSONObject();
                    jsonObj.put("id", rs.getInt("USERID"));
                    jsonObj.put("nomeUtente", rs.getString("USERNAME"));
                    arr.put(jsonObj);
                }

            } catch (SQLException ex) {
                Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex);
            } catch (JSONException ex) {
                Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex);
            } finally {
                BaseDao.closeResultSet(rs);
                BaseDao.closeStatement(st);
                String jsonPrettyPrintString;
                try {
                    jsonPrettyPrintString = arr.toString(4);
                    response.getWriter().write(jsonPrettyPrintString);
                } catch (JSONException ex) {
                    Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
         /**
         * getAllType
         * ritorna tutti i tipi ente ordinati per nome tipo
         * Parametri:
         * nessuno
         * Output:
         * id: ID del tipo ente (id del record)
         * nome: nome dell'ente
         * codice: codice dell'ente
         * Autenticazione:
         * Non richiesta
         */
        else if (uriParts[uriParts.length-1].equalsIgnoreCase("getAllType")){
            Logger.getLogger(RestUserAddOn.class.getName()).log(Level.FINEST, "Method getAllType entered", (Throwable)null); 
            ManagedConnection mc;
            ResultSet rs = null;
            PreparedStatement st = null;
            JSONArray arr = new JSONArray();
            try {
                mc = context.getConnectionBroker().returnConnection("");
                Connection con = mc.getJdbcConnection();

                // initialize
                st = con.prepareStatement("SELECT codiceTipo,nomeTipo FROM gpt_tipoente ORDER BY nomeTipo");
                Logger.getLogger(RestUserAddOn.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);
                rs = st.executeQuery();
                
                while (rs.next()) {
                    JSONObject jsonObj = new JSONObject();
                    jsonObj.put("id", rs.getString("nomeTipo"));
                    jsonObj.put("nome", rs.getString("nomeTipo"));
                    jsonObj.put("codice", rs.getString("codiceTipo"));
                    arr.put(jsonObj);
                }

            } catch (SQLException ex) {
                Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex);
            } catch (JSONException ex) {
                Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex);
            } finally {
                BaseDao.closeResultSet(rs);
                BaseDao.closeStatement(st);
                String jsonPrettyPrintString;
                try {
                    jsonPrettyPrintString = arr.toString(4);
                    response.getWriter().write(jsonPrettyPrintString);
                } catch (JSONException ex) {
                    Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex);
                }
                
            }    
        }
         /**
         * getNextId
         * ritorna il prossimo identificativo di FileIdentifier (campo ultimoID1) di una PA.
         * Parametri:
         * nessuno
         * Output:
         * Nuovo identificativo nella forma: PACode:lastid+1 (0 padded on 6 digits):YYYYMMDD:HHMMSS
         * Autenticazione:
         * Richiesta
         */
        else if (uriParts[uriParts.length-1].equalsIgnoreCase("getNextId")){
            Logger.getLogger(RestUserAddOn.class.getName()).log(Level.FINEST, "Method getNextId entered", (Throwable)null); 
            JSONArray arr = new JSONArray();
            JSONObject jsonObj = new JSONObject();
            String jsonPrettyPrintString;
            // Siamo connessi ? 
            if (context.getUser().getName().isEmpty()){
                Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, "Errore autenticazione getNextId: non autenticato", (Throwable)null);
                try {
   
                    jsonObj.put("id", -1);
                    jsonObj.put("err", "Autenticazione richiesta");
                    arr.put(jsonObj);
                    response.getWriter().write(arr.toString(4));
                } catch (JSONException ex) {
                    Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex);
                }
                return;
            }   
            try {
                jsonObj.put("id", supportForMetadata.getNextIdentifier(context));
                jsonPrettyPrintString = jsonObj.toString(4);
                response.getWriter().write(jsonPrettyPrintString);
            } catch (JSONException ex) {
                Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
         /**
         * getNextId2
         * ritorna il prossimo identificativo di DataIdentifier (campo ultimoID2) di una PA.
         * Parametri:
         * nessuno
         * Output:
         * Nuovo identificativo nella forma: PACode:lastid+1 (0 padded on 6 digits)
         * Autenticazione:
         * Richiesta
         */
        else if (uriParts[uriParts.length-1].equalsIgnoreCase("getNextId2")){
            Logger.getLogger(RestUserAddOn.class.getName()).log(Level.FINEST, "Method getNextId2 entered", (Throwable)null); 
            String jsonPrettyPrintString;
            JSONObject jsonObj = new JSONObject();
            JSONArray arr = new JSONArray();
            // Siamo connessi ? 
            if (context.getUser().getName().isEmpty()){
                Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, "Errore autenticazione getNextId2: non autenticato", (Throwable)null);
                try {
                    jsonObj.put("id", -1);
                    jsonObj.put("err", "Autenticazione richiesta");
                    arr.put(jsonObj);
                    response.getWriter().write(arr.toString(4));
                } catch (JSONException ex) {
                    Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex);
                }
                return;
            } 
            try {
                jsonObj.put("id", supportForMetadata.getNextIdentifier2(context));
                jsonPrettyPrintString = jsonObj.toString(4);
                response.getWriter().write(jsonPrettyPrintString);
            } catch (JSONException ex) {
                Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
         /**
         * getCurrentCodIPA
         * ritorna il codice IPA della PA dell'utente collegato
         * Parametri:
         * nessuno
         * Output:
         * codcie IPA
         * Autenticazione:
         * Richiesta
         */
        else if ((uriParts[uriParts.length-1].equalsIgnoreCase("getCurrentCodIPA"))){
            Logger.getLogger(RestUserAddOn.class.getName()).log(Level.FINEST, "Method getCurrentCodIPA entered", (Throwable)null); 
            String jsonPrettyPrintString;
            JSONObject jsonObj = new JSONObject();
            JSONArray arr = new JSONArray();
            // Siamo connessi ? 
            if (context.getUser().getName().isEmpty()){
                Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, "Errore autenticazione getCurrentCodIPA: non autenticato", (Throwable)null);
                try {
                    jsonObj.put("id", -1);
                    jsonObj.put("err", "Autenticazione richiesta");
                    arr.put(jsonObj);
                    response.getWriter().write(arr.toString(4));
                } catch (JSONException ex) {
                    Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex);
                }
                return;
            } 
            try {
                jsonObj.put("id", supportForMetadata.getCurrentCodIPA(context) + ":");
                jsonPrettyPrintString = jsonObj.toString(4);
                response.getWriter().write(jsonPrettyPrintString);
            } catch (JSONException ex) {
                Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        /**
         * insertUser
         * Inserisce un utente
         * Parametri:
         * user: Obbligatorio. Nome utente
         * dn: Obbligatorio. DN (LDAP) dell'utente 
         * cnPa: Obbligatorio. Codice IPA della PA di appartenenza
         * auth: Opzionale: se viene passato user=userNoAuth allora è valido come autenticazione.
         * Output:
         * OK, no OK
         * Autenticazione:
         * Richiesta. Se viene passato auth=userNoAuth, il controllo è ok
         */
        else if ((uriParts[uriParts.length-1].equalsIgnoreCase("insertUser"))){
            String nomeUtente="";
            String ldapDN="";
            String codiceIPA="";
            String auth=""; 
            
            ManagedConnection mc;
            ResultSet rs = null;
            PreparedStatement st = null;
            JSONArray arr = new JSONArray();
            JSONObject jsonObj = new JSONObject();
            // Controllo parametri
            if (request.getParameterMap().containsKey("user")){
                nomeUtente = request.getParameter("user");
            }
            if (request.getParameterMap().containsKey("dn")){
                ldapDN = request.getParameter("dn");
            }  
            if (request.getParameterMap().containsKey("cnPa")){
                codiceIPA = request.getParameter("cnPa");
            }
            if (request.getParameterMap().containsKey("auth")){
                auth = request.getParameter("auth");
            }
            // Parametri mancanti
            if (nomeUtente.isEmpty() || ldapDN.isEmpty() || codiceIPA.isEmpty()){
                Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, "Errore parametri insertUser: User o dn o cnPa mancante: User:["+nomeUtente+"] dn:[" + ldapDN + "] cnPa:["+codiceIPA+"]", (Throwable)null);
                try {
                    jsonObj.put("insert", "no OK");
                    jsonObj.put("err", "Parametro mancante");
                    arr.put(jsonObj);
                    response.getWriter().write(arr.toString(4));
                } catch (JSONException ex) {
                    Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex);
                }
                return;                    
            }
            // Siamo connessi ? L'autenticazione è richiesta ? (auth=noAuth vuol dire niente controllo) 
            //if (context.getUser().getName().isEmpty() && (!auth.equals("noAuth"))){
                
            if (context.getUser().getName().isEmpty() && (!auth.equals(userNoAuth))){
             
                Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, "Errore autenticazione insertUser: non autenticato", (Throwable)null);
                try {
                    jsonObj.put("insert", "no OK");
                    jsonObj.put("err", "Autenticazione richiesta");
                    arr.put(jsonObj);
                    response.getWriter().write(arr.toString(4));
                } catch (JSONException ex) {
                    Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex);
                }
                return;
            } 
            try {
                mc = context.getConnectionBroker().returnConnection("");
                Connection con = mc.getJdbcConnection();

                // initialize
                //st = con.prepareStatement("INSERT INTO `geoportal`.`gpt_user` (`DN`, `USERNAME`, `FK_IDPA`) VALUES ('" + ldapDN + "', '" + nomeUtente +"', '" + idPA + "')");
                st=con.prepareStatement("INSERT INTO `gpt_user` (`DN`, `USERNAME`, `FK_IDPA`) SELECT '" + ldapDN + "', '" + nomeUtente + "',  ID FROM gpt_pa where cod_ipa='" + codiceIPA + "'");
                Logger.getLogger(RestUserAddOn.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);

                int ret = st.executeUpdate();

                try {
                    jsonObj.put("insert", (ret>0) ? "Ok":"no OK");
                } catch (JSONException ex) {
                    Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex);
                }

            } catch (SQLException ex) {
                try {
                    jsonObj.put("insert", "error: " + ex.getMessage());
                } catch (JSONException ex1) {
                    Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex1);
                }
            } finally {
                BaseDao.closeResultSet(rs);
                BaseDao.closeStatement(st);                
            }            
            response.getWriter().write(jsonObj.toString());
        }
         /**
         * insertPA
         * Inserisce un ente
         * Parametri:
         * nome: Obbligatorio. Nome PA
         * codiceipa: Obbligatorio. Codice IPA dell'ente 
         * codiceTipo: Obbligatorio. Codice tipo dell'ente
         * auth: Opzionale: se viene passato user=userNoAuth allora è valido come autenticazione.
         * Output:
         * OK, no OK
         * Autenticazione:
         * Richiesta. Se viene passato auth=userNoAuth, il controllo è ok
         * Nota: non viene verificata l'esistenza del codice tipo 
         */
        else if ((uriParts[uriParts.length-1].equalsIgnoreCase("insertPA"))){
            Logger.getLogger(RestUserAddOn.class.getName()).log(Level.FINEST, "Method insertPA entered", (Throwable)null); 
            String nome="";
            String codIPA="";
/*
Non si usa più il tipo per evitare discordanze con il codiceTipo. Ci pensa la update
            String typeE=request.getParameter("tipo").toString();
            **/
            String tipoPA="";
            String auth=""; 
            
            ManagedConnection mc;
            ResultSet rs = null;
            PreparedStatement st = null;
            JSONObject jsonObj = new JSONObject();
            JSONArray arr = new JSONArray();
            // Controllo parametri
            if (request.getParameterMap().containsKey("nome")){
                nome = request.getParameter("nome");
            }
            if (request.getParameterMap().containsKey("codiceipa")){
                codIPA = request.getParameter("codiceipa");
            }  
            if (request.getParameterMap().containsKey("codiceTipo")){
                tipoPA = request.getParameter("codiceTipo");
            }
            if (request.getParameterMap().containsKey("auth")){
                auth = request.getParameter("auth");
            }
            // Parametri mancanti
            if (nome.isEmpty() || codIPA.isEmpty() || tipoPA.isEmpty()){
                Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, "Errore parametri insertPA: nome o codiceipa o codiceTipo mancante: nome:["+nome+"] codiceipa:[" + codIPA + "] codiceTipo:["+tipoPA+"]", (Throwable)null);
                try {
                    jsonObj.put("insert", "no OK");
                    jsonObj.put("err", "Parametro mancante");
                    arr.put(jsonObj);
                    response.getWriter().write(arr.toString(4));
                } catch (JSONException ex) {
                    Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex);
                }
                return;                    
            }
            // Siamo connessi ? L'autenticazione è richiesta ? (auth=noAuth vuol dire niente controllo) 
            //if (context.getUser().getName().isEmpty() && (!auth.equals("noAuth"))){
            
             // Siamo connessi ? L'autenticazione è richiesta ? (auth=userNoAuth vuol dire niente controllo) 
             if (context.getUser().getName().isEmpty() && (!auth.equals(userNoAuth))){
                Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, "Errore autenticazione insertPA: non autenticato", (Throwable)null);
                try {
                    jsonObj.put("insert", "no OK");
                    jsonObj.put("err", "Autenticazione richiesta");
                    arr.put(jsonObj);
                    response.getWriter().write(arr.toString(4));
                } catch (JSONException ex) {
                    Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex);
                }
                return;
            } 
            try {
                mc = context.getConnectionBroker().returnConnection("");
                Connection con = mc.getJdbcConnection();
                // initialize
                String stInsert = "INSERT INTO `gpt_pa` (`ID`, `cod_ipa`, `nome`, `ultimoID1`, `ultimoID2`, `tipoPA`,`codiceTipoPA`) ";
                String stSubQueryPerTipo =  "(SELECT `nomeTipo` from `gpt_tipoente` where `codiceTipo`='" +  tipoPA + "')";
                String stValues = "SELECT MAX(ID) + 1,'"+codIPA+"', '"+nome.replaceAll("'", "''")+"', 1, 1," + stSubQueryPerTipo + ", '"+tipoPA+"' FROM `gpt_pa`";

                st = con.prepareStatement(stInsert + stValues);

                Logger.getLogger(RestUserAddOn.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);

                int ret = st.executeUpdate();

                try {
                    jsonObj.put("insert", (ret>0) ? "Ok":"no OK");
                } catch (JSONException ex) {
                    Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex);
                }

            } catch (SQLException ex) {
                try {
                    jsonObj.put("insert", "error: " + ex.getMessage());
                } catch (JSONException ex1) {
                    Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex1);
                }
            } finally {
                BaseDao.closeResultSet(rs);
                BaseDao.closeStatement(st);                
            }            
            response.getWriter().write(jsonObj.toString());
        }
         /**
         * updatePA
         * Modifica un ente
         * Parametri:
         * idPA: Obbligatorio. Id del record da aggiornare
         * nome: Opzionale. Nome PA
         * codiceipa: Opzionale. Codice IPA dell'ente 
         * codiceTipo: Opzionale. Codice tipo dell'ente
         * auth: Opzionale: se viene passato user=userNoAuth allora è valido come autenticazione.
         * Output:
         * OK, no OK
         * Autenticazione:
         * Richiesta. Se viene passato auth=userNoAuth, il controllo è ok
         * Nota: non viene verificata l'esistenza del codice tipo 
         */
        else if ((uriParts[uriParts.length-1].equalsIgnoreCase("updatePA"))){

            Logger.getLogger(RestUserAddOn.class.getName()).log(Level.FINE, "Method updatePA entered", (Throwable)null); 
            String nome="";
            String codIPA="";
            String idPA="";
            String codiceTipo="";
            String auth=""; 
            
            ManagedConnection mc;
            PreparedStatement st = null;
            JSONObject jsonObj = new JSONObject();
            JSONArray arr = new JSONArray();            

/*
Non si usa più il tipo per evitare discordanze con il codiceTipo. Ci pensa la update
            if (request.getParameterMap().containsKey("tipo")) tipo=request.getParameter("tipo").toString();
*/
            Logger.getLogger(RestUserAddOn.class.getName()).log(Level.FINE, "Parameters: nome=[" + nome +"] codiceipa=[" + codIPA + "] idPA=[" + idPA + "] codiceTipo=[" + codiceTipo + "]", (Throwable)null); 

            // Controllo parametri
            if (request.getParameterMap().containsKey("idPA")){
                idPA = request.getParameter("idPA");
            } 
            if (request.getParameterMap().containsKey("nome")){
                nome = request.getParameter("nome");
            }
            if (request.getParameterMap().containsKey("codiceipa")){
                codIPA = request.getParameter("codiceipa");
            }  
            if (request.getParameterMap().containsKey("codiceTipo")){
                codiceTipo = request.getParameter("codiceTipo");
            }
            if (request.getParameterMap().containsKey("auth")){
                auth = request.getParameter("auth");
            }
            // Parametri mancanti
            if (idPA.isEmpty() || (nome.isEmpty() && codIPA.isEmpty() && codiceTipo.isEmpty())){
                Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, "Errore parametri updatePA: idPA mancante o tutti gli altri parametri sono null", (Throwable)null);
                try {
                    jsonObj.put("update", "no OK");
                    jsonObj.put("err", "Parametro mancante");
                    arr.put(jsonObj);
                    response.getWriter().write(arr.toString(4));
                } catch (JSONException ex) {
                    Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex);
                }
                return;                    
            }
            // Siamo connessi ? L'autenticazione è richiesta ? (auth=noAuth vuol dire niente controllo) 
            //if (context.getUser().getName().isEmpty() && (!auth.equals("noAuth"))){
                
            // Siamo connessi ? L'autenticazione è richiesta ? (auth=userNoAuth vuol dire niente controllo) 
            if (context.getUser().getName().isEmpty() && (!auth.equals(userNoAuth))){   
                
                Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, "Errore autenticazione updatePA: non autenticato", (Throwable)null);
                try {
                    jsonObj.put("update", "no OK");
                    jsonObj.put("err", "Autenticazione richiesta");
                    arr.put(jsonObj);
                    response.getWriter().write(arr.toString(4));
                } catch (JSONException ex) {
                    Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex);
                }
                return;
            } 
            try {

                mc = context.getConnectionBroker().returnConnection("");
                Connection con = mc.getJdbcConnection();
                // initialize
                String strUpdate="";
                if (! nome.equals("")) strUpdate = strUpdate + " `nome`= '" + nome + "'";
                if (! codIPA.equals("")) strUpdate = strUpdate + (strUpdate.equals("") ? "": ",")  + " `cod_ipa`= '" + codIPA + "'";
                if (! codiceTipo.equals("")) strUpdate = strUpdate + (strUpdate.equals("") ? "": ",") + "`codiceTipoPA` = '" + codiceTipo + "',`tipoPA` = (select `nomeTipo` from `gpt_tipoente` where `codiceTipo`='" + codiceTipo + "')";                     
                if (! strUpdate.equals("")){
                    st = con.prepareStatement("UPDATE `gpt_pa` set " + strUpdate + " where `ID` = " + idPA);
                    Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, "Query:" + st, (Throwable)null);
                    int ret = st.executeUpdate();
                    Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, "Update executed", (Throwable)null); 
                    jsonObj.put("update", (ret>0) ? "Ok":"no OK");
                } else {
                    jsonObj.put("update", "no OK");
                }

            } catch (SQLException ex) {
                try {
                    jsonObj.put("update", "error: " + ex.getMessage());
                } catch (JSONException ex1) {
                    Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex1);
                }
            } catch (JSONException ex) {
                        Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex);
            } finally {
                BaseDao.closeStatement(st);                
            }            
            response.getWriter().write(jsonObj.toString());        
        }
                /**
         * updateUser
         * Modifica un utente. Per ora si può modificare solo l’ente di appartenenza
         * Parametri:
         * user: Obbligatorio. Nome utente
         * cnPa: Obbligatorio. Codice IPA della PA di appartenenza
         * Output:
         * OK, no OK
         * Autenticazione:
         * Richiesta. Se viene passato auth=userNoAuth, il controllo è ok
         */
        else if ((uriParts[uriParts.length-1].equalsIgnoreCase("updateUser"))){
            String dn="";
            String codiceIPA="";
            String auth=""; 
            
            ManagedConnection mc;
            ResultSet rs = null;
            PreparedStatement st = null;
            JSONArray arr = new JSONArray();
            JSONObject jsonObj = new JSONObject();
            // Controllo parametri
            if (request.getParameterMap().containsKey("dn")){
                dn = request.getParameter("dn");
            }
            if (request.getParameterMap().containsKey("cnPa")){
                codiceIPA = request.getParameter("cnPa");
            }
            if (request.getParameterMap().containsKey("auth")){
                auth = request.getParameter("auth");
            }
            // Parametri mancanti
            if (dn.isEmpty() || codiceIPA.isEmpty()){
                Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, "Errore parametri updateUser: User DN o cnPa mancante: dn:["+dn+"] cnPa:["+codiceIPA+"]", (Throwable)null);
                try {
                    jsonObj.put("update", "no OK");


                    jsonObj.put("err", "Parametro mancante");
                    arr.put(jsonObj);
                    response.getWriter().write(arr.toString(4));
                } catch (JSONException ex) {
                    Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex);
                }
                return;                    
            }
            // Siamo connessi ? L'autenticazione è richiesta ? 
            //if (context.getUser().getName().isEmpty()  && (!auth.equals("noAuth"))){
            if (context.getUser().getName().isEmpty()  && (!auth.equals(userNoAuth))){    
                
                Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, "Errore autenticazione upadteUser: non autenticato", (Throwable)null);
                try {
                    jsonObj.put("update", "no OK");
                    jsonObj.put("err", "Autenticazione richiesta");
                    arr.put(jsonObj);
                    response.getWriter().write(arr.toString(4));
                } catch (JSONException ex) {
                    Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex);
                }
                return;
            } 
            try {
                mc = context.getConnectionBroker().returnConnection("");
                Connection con = mc.getJdbcConnection();

                // initialize
                st=con.prepareStatement("UPDATE `gpt_user` A, (SELECT ID FROM gpt_pa where cod_ipa='" + codiceIPA + "') B SET A.FK_IDPA = B.ID WHERE A.DN =" + "'" + dn + "'");
                Logger.getLogger(RestUserAddOn.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);

                int ret = st.executeUpdate();

                try {
                    jsonObj.put("update", (ret>0) ? "Ok":"no OK");
                } catch (JSONException ex) {
                    Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex);
                }

            } catch (SQLException ex) {
                try {
                    jsonObj.put("update", "error: " + ex.getMessage());
                } catch (JSONException ex1) {
                    Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex1);
                }
            } finally {
                BaseDao.closeResultSet(rs);
                BaseDao.closeStatement(st);                
            }            
            response.getWriter().write(jsonObj.toString());
        }
        
        // Nessuna chiamata riconosciuta
        else {
            JSONObject jsonObj = new JSONObject();
            Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, "REST API sconosciuta:", (Throwable)null);
            try {
                jsonObj.put("err", "Chiamata REST sconosciuta");
                response.getWriter().write(jsonObj.toString(4));
            } catch (JSONException ex) {
                        Logger.getLogger(RestUserAddOn.class.getName()).log(Level.SEVERE, null, ex);
        }
            
    }
    }
}