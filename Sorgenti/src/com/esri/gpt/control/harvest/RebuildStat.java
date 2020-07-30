/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.esri.gpt.control.harvest;


import com.esri.gpt.control.publication.supportForMetadata;
import com.esri.gpt.catalog.arcims.ImsMetadataProxyDao;
import com.esri.gpt.catalog.arcims.ImsServiceException;
import com.esri.gpt.framework.context.BaseServlet;
import com.esri.gpt.framework.context.RequestContext;
import com.esri.gpt.framework.sql.BaseDao;
import static com.esri.gpt.framework.sql.BaseDao.closeStatement;
import com.esri.gpt.framework.sql.ManagedConnection;
import com.esri.gpt.framework.util.LogUtil;
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
public class RebuildStat extends BaseServlet {
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

        String[] uriParts = request.getRequestURI().split("/");
        
        /* 
        * deleteAllStat
        * Cancella tutti i dati delle statistiche
        * Parametri: nessuno
        * Autenticazione: non richiesta
        */

        if (uriParts[uriParts.length-1].equalsIgnoreCase("deleteAllStat")){
            ManagedConnection mc;
            ResultSet rs = null;
            PreparedStatement st = null;
            JSONObject objJ = new JSONObject();
            JSONArray jarr = new JSONArray();
            try {
                mc = context.getConnectionBroker().returnConnection("");
                Connection con = mc.getJdbcConnection();

                /* Tabella di tipo dato */
                 String sSql = "DELETE FROM gpt_resource_stat ";
                 logExpression(sSql);
                 st = con.prepareStatement(sSql);
                 Logger.getLogger(RebuildStat.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);
                 int numero = st.executeUpdate();
                 objJ.put("tabella", "gpt_resource_stat");
                 objJ.put("numero", numero);
                 jarr.put(objJ);
                 objJ = new JSONObject();
                closeStatement(st);
                
                 /* Tabella di topic category */
                 sSql = "DELETE FROM gpt_resource_stat_topic ";
                 logExpression(sSql);
                 st = con.prepareStatement(sSql);
                 Logger.getLogger(RebuildStat.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);
                 numero = st.executeUpdate();
                 objJ.put("tabella", "gpt_resource_stat_topic");
                 objJ.put("numero", numero);
                 jarr.put(objJ);
                 objJ = new JSONObject();
                 closeStatement(st);

                 /* Tabella di tipo servizio */
                 sSql = "DELETE FROM gpt_resource_stat_service_type";
                 logExpression(sSql);
                 st = con.prepareStatement(sSql);
                 Logger.getLogger(RebuildStat.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);
                 numero = st.executeUpdate();
                 objJ.put("tabella", "gpt_resource_stat_service_type");
                 objJ.put("numero", numero);
                 jarr.put(objJ);
                 objJ = new JSONObject();
                 closeStatement(st);
                 
                 /* Tabella di tema INSPIRE */
                 sSql = "DELETE FROM gpt_resource_stat_inspire_theme ";
                 logExpression(sSql);
                 st = con.prepareStatement(sSql);
                 Logger.getLogger(RebuildStat.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);
                 numero = st.executeUpdate();
                 objJ.put("tabella", "gpt_resource_stat_inspire_theme");
                 objJ.put("numero", numero);
                 jarr.put(objJ);
                 objJ = new JSONObject();
                 closeStatement(st);
                 
                 /* Tabella di Tipo servizio INSPIRE */
                 sSql = "DELETE FROM gpt_resource_stat_inspire_service ";
                 logExpression(sSql);
                 st = con.prepareStatement(sSql);
                 Logger.getLogger(RebuildStat.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);
                 numero = st.executeUpdate();
                 objJ.put("tabella", "gpt_resource_stat_inspire_service");
                 objJ.put("numero", numero);
                 jarr.put(objJ);
                 
            } catch (SQLException ex) {
                Logger.getLogger(RebuildStat.class.getName()).log(Level.SEVERE, null, ex);
            } catch (JSONException ex) {
                Logger.getLogger(RebuildStat.class.getName()).log(Level.SEVERE, null, ex);
            } finally {
                BaseDao.closeResultSet(rs);
                BaseDao.closeStatement(st);
                String jsonPrettyPrintString;
                try {
                    jsonPrettyPrintString = jarr.toString(4);
                    response.getWriter().write(jsonPrettyPrintString);
                } catch (JSONException ex) {
                    Logger.getLogger(RebuildStat.class.getName()).log(Level.SEVERE, null, ex);
                }
                
            }
        } 
        /* 
        * RebuildAllStat
        * Ricostruisce le statistiche dei metadati presenti senza svuotare le tabelle.
        * Parametri: nessuno
        * Autenticazione: non richiesta
        */
        else if (uriParts[uriParts.length-1].equalsIgnoreCase("RebuildAllStat")){
            ImsMetadataProxyDao proxy = new ImsMetadataProxyDao(context,null);
            ManagedConnection mc;
            ResultSet rs = null;
            PreparedStatement st = null;
            JSONArray jarr = new JSONArray();
            try {
                mc = context.getConnectionBroker().returnConnection("");
                Connection con = mc.getJdbcConnection();

                /* Seleziona tutti i metadati non cataloghi */
                 String sSql = "SELECT d.DOCUUID,d.xml from gpt_resource r inner join gpt_resource_data d on r.DOCUUID = d.DOCUUID where r.PROTOCOL_TYPE is null";
                 logExpression(sSql);
                 st = con.prepareStatement(sSql);
                 rs= st.executeQuery();
                 Logger.getLogger(RebuildStat.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);
                 while (rs.next()){
                     proxy.insertStat(rs.getString(1), true, rs.getString(2),"");
                 }
                 rs.close();
            } catch (SQLException ex) {
                Logger.getLogger(RebuildStat.class.getName()).log(Level.SEVERE, null, ex);
            } catch (ImsServiceException ex) {
                Logger.getLogger(RebuildStat.class.getName()).log(Level.SEVERE, null, ex);
            } finally {
                BaseDao.closeResultSet(rs);
                BaseDao.closeStatement(st);
                String jsonPrettyPrintString;
                try {
                    jsonPrettyPrintString = jarr.toString(4);
                    response.getWriter().write(jsonPrettyPrintString);
                } catch (JSONException ex) {
                    Logger.getLogger(RebuildStat.class.getName()).log(Level.SEVERE, null, ex);
                }
                
            }
        } 
        /* 
        * DoAllStat
        * Cancella e ricostruisce tutti i dati delle statistiche sulla base dei metadati presenti 
        * Parametri: nessuno
        * Autenticazione: non richiesta
        */
        else if (uriParts[uriParts.length-1].equalsIgnoreCase("DoAllStat")){
            ManagedConnection mc;
            ResultSet rs = null;
            PreparedStatement st = null;
            JSONObject objJ = new JSONObject();
            JSONArray jarr = new JSONArray();
            try {
                mc = context.getConnectionBroker().returnConnection("");
                Connection con = mc.getJdbcConnection();

                /* Tabelle di Statistiche ESRI*/
                 String sSql = "DELETE FROM gpt_resource_stat ";
                 logExpression(sSql);
                 st = con.prepareStatement(sSql);
                 int numero = st.executeUpdate();
                 objJ.put("tabella", "gpt_resource_stat");
                 objJ.put("numero", numero);
                 jarr.put(objJ);
                 objJ = new JSONObject();
                 
                 closeStatement(st);
                 sSql = "DELETE FROM gpt_resource_stat_topic ";
                 logExpression(sSql);
                 st = con.prepareStatement(sSql);
                 Logger.getLogger(RebuildStat.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);
                 numero = st.executeUpdate();
                 objJ.put("tabella", "gpt_resource_stat_topic");
                 objJ.put("numero", numero);
                 jarr.put(objJ);
                 objJ = new JSONObject();
                 
                 closeStatement(st);
                 sSql = "DELETE FROM gpt_resource_stat_service_type";
                 logExpression(sSql);
                 st = con.prepareStatement(sSql);
                 Logger.getLogger(RebuildStat.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);
                 numero = st.executeUpdate();
                 objJ.put("tabella", "gpt_resource_stat_service_type");
                 objJ.put("numero", numero);
                 jarr.put(objJ);
                 objJ = new JSONObject();

                 closeStatement(st);
                 sSql = "DELETE FROM gpt_resource_stat_inspire_theme ";
                 logExpression(sSql);
                 st = con.prepareStatement(sSql);
                 Logger.getLogger(RebuildStat.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);
                 numero = st.executeUpdate();
                 objJ.put("tabella", "gpt_resource_stat_inspire_theme");
                 objJ.put("numero", numero);
                 jarr.put(objJ);
                 objJ = new JSONObject();
                 
                 closeStatement(st);
                 sSql = "DELETE FROM gpt_resource_stat_inspire_service ";
                 logExpression(sSql);
                 st = con.prepareStatement(sSql);
                 Logger.getLogger(RebuildStat.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);
                 numero = st.executeUpdate();
                 objJ.put("tabella", "gpt_resource_stat_inspire_service");
                 objJ.put("numero", numero);
                 jarr.put(objJ);
                 objJ = new JSONObject();
            
                 ImsMetadataProxyDao proxy = new ImsMetadataProxyDao(context,null);
                 sSql = "SELECT d.DOCUUID,d.xml from gpt_resource r inner join gpt_resource_data d on r.DOCUUID = d.DOCUUID where r.PROTOCOL_TYPE is null";
                 logExpression(sSql);
                 st = con.prepareStatement(sSql);
                 Logger.getLogger(RebuildStat.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);
                 rs= st.executeQuery();
                 while (rs.next()){
                     proxy.insertStat(rs.getString(1), true, rs.getString(2),"");
                 }
                 rs.close();
             /* Tabelle di Statistiche ESRI*/
            } catch (SQLException ex) {
                Logger.getLogger(RebuildStat.class.getName()).log(Level.SEVERE, null, ex);
            } catch (JSONException ex) {
                Logger.getLogger(RebuildStat.class.getName()).log(Level.SEVERE, null, ex);
            } catch (ImsServiceException ex) {
                Logger.getLogger(RebuildStat.class.getName()).log(Level.SEVERE, null, ex);
            } finally {
                BaseDao.closeResultSet(rs);
                BaseDao.closeStatement(st);
                String jsonPrettyPrintString;
                try {
                    jsonPrettyPrintString = jarr.toString(4);
                    response.getWriter().write(jsonPrettyPrintString);
                } catch (JSONException ex) {
                    Logger.getLogger(RebuildStat.class.getName()).log(Level.SEVERE, null, ex);
                }
                
            }        
        }
        /* 
        * DoOnlyOneStat
        * Cancella e ricostruisce tutti i dati delle statistiche sulla base dei metadati presenti 
        * Parametri: tipo_stat può valere stat, topic, service, inspire, inspireservice
        * Autenticazione: non richiesta
        */
        else if (uriParts[uriParts.length-1].equalsIgnoreCase("DoOnlyOneStat")){
            String quale= request.getParameter("tipo_stat");
            ManagedConnection mc;
            ResultSet rs = null;
            PreparedStatement st = null;
            JSONObject objJ = new JSONObject();
            JSONArray jarr = new JSONArray();
            try {
                mc = context.getConnectionBroker().returnConnection("");
                Connection con = mc.getJdbcConnection();
                String sSql ="";
                int numero=0;
                /* Tabelle di Statistiche ESRI*/
                if (quale.equalsIgnoreCase("stat")){
                    sSql = "DELETE FROM gpt_resource_stat ";
                    logExpression(sSql);
                    st = con.prepareStatement(sSql);
                    Logger.getLogger(RebuildStat.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);
                    numero = st.executeUpdate();
                    objJ.put("tabella", "gpt_resource_stat");
                    objJ.put("numero", numero);
                    jarr.put(objJ);
                    objJ = new JSONObject();
                    closeStatement(st);
                } else if (quale.equalsIgnoreCase("topic")){
                    sSql = "DELETE FROM gpt_resource_stat_topic ";
                    logExpression(sSql);
                    st = con.prepareStatement(sSql);
                    Logger.getLogger(RebuildStat.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);
                    numero = st.executeUpdate();
                    objJ.put("tabella", "gpt_resource_stat_topic");
                    objJ.put("numero", numero);
                    jarr.put(objJ);
                    objJ = new JSONObject();

                    closeStatement(st);
                } else if (quale.equalsIgnoreCase("service")){
                    sSql = "DELETE FROM gpt_resource_stat_service_type";
                    logExpression(sSql);
                    st = con.prepareStatement(sSql);
                    Logger.getLogger(RebuildStat.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);
                    numero = st.executeUpdate();
                    objJ.put("tabella", "gpt_resource_stat_service_type");
                    objJ.put("numero", numero);
                    jarr.put(objJ);
                    objJ = new JSONObject();

                    closeStatement(st);
                 } else if (quale.equalsIgnoreCase("inspire")){
                    sSql = "DELETE FROM  gpt_resource_stat_inspire_theme ";
                    logExpression(sSql);
                    st = con.prepareStatement(sSql);
                    Logger.getLogger(RebuildStat.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);
                    numero = st.executeUpdate();
                    objJ.put("tabella", "gpt_resource_stat_inspire_theme");
                    objJ.put("numero", numero);
                    jarr.put(objJ);
                 } else if (quale.equalsIgnoreCase("inspireservice")){
                    sSql = "DELETE FROM  gpt_resource_stat_inspire_service ";
                    logExpression(sSql);
                    st = con.prepareStatement(sSql);
                    Logger.getLogger(RebuildStat.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);
                    numero = st.executeUpdate();
                    objJ.put("tabella", "gpt_resource_stat_inspire_service");
                    objJ.put("numero", numero);
                    jarr.put(objJ);
                 }
                 else {
                    Logger.getLogger(RebuildStat.class.getName()).log(Level.SEVERE, "Statistica richiesta non valida:" + quale, (Throwable)null);
                    return;
                 }
                 objJ = new JSONObject();
            
                 ImsMetadataProxyDao proxy = new ImsMetadataProxyDao(context,null);
                 sSql = "SELECT d.DOCUUID,d.xml from gpt_resource r inner join gpt_resource_data d on r.DOCUUID = d.DOCUUID where r.PROTOCOL_TYPE is null";
                 logExpression(sSql);
                 st = con.prepareStatement(sSql);
                 Logger.getLogger(RebuildStat.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);
                 rs= st.executeQuery();
                 while (rs.next()){
                     proxy.insertStat(rs.getString(1), true, rs.getString(2),quale);
                 }
                 rs.close();
             /* Tabelle di Statistiche ESRI*/
            } catch (SQLException ex) {
                Logger.getLogger(RebuildStat.class.getName()).log(Level.SEVERE, null, ex);
            } catch (JSONException ex) {
                Logger.getLogger(RebuildStat.class.getName()).log(Level.SEVERE, null, ex);
            } catch (ImsServiceException ex) {
                Logger.getLogger(RebuildStat.class.getName()).log(Level.SEVERE, null, ex);
            } finally {
                BaseDao.closeResultSet(rs);
                BaseDao.closeStatement(st);
                String jsonPrettyPrintString;
                try {
                    jsonPrettyPrintString = jarr.toString(4);
                    response.getWriter().write(jsonPrettyPrintString);
                } catch (JSONException ex) {
                    Logger.getLogger(RebuildStat.class.getName()).log(Level.SEVERE, null, ex);
                }
                
            }        
        }
    }
/**
 * Logs a SQL expression.
 * @param expression the expression to log
 */
protected void logExpression(String expression) {
  if (expression != null) {
    LogUtil.getLogger().finer(expression);
  }
}
}