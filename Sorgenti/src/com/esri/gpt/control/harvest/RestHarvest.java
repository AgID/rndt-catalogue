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
public class RestHarvest extends BaseServlet {
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
        /* TODO output your page here. You may use following sample code. */
        if (uriParts[uriParts.length-1].equalsIgnoreCase("harvesting")){
            ManagedConnection mc;
            ResultSet rs = null;
            PreparedStatement st = null;
            JSONObject objJ = new JSONObject();
            try {
                mc = context.getConnectionBroker().returnConnection("");
                Connection con = mc.getJdbcConnection();

                /* Tabelle di Statistiche ESRI*/
                 String sSql = "select count(*) from gpt_harvesting_jobs_pending ";
                 logExpression(sSql);
                 st = con.prepareStatement(sSql);
                 rs = st.executeQuery();
                
                if (rs.next()) {
                    objJ.put("harvesting", (rs.getInt(1)>0));

                }
                closeStatement(st);
                
                 
             /* Tabelle di Statistiche ESRI*/
            } catch (SQLException ex) {
                Logger.getLogger(RestHarvest.class.getName()).log(Level.SEVERE, null, ex);
            } catch (JSONException ex) {
                Logger.getLogger(RestHarvest.class.getName()).log(Level.SEVERE, null, ex);
            } finally {
                BaseDao.closeResultSet(rs);
                BaseDao.closeStatement(st);
                String jsonPrettyPrintString;
                try {
                    jsonPrettyPrintString = objJ.toString(4);
                    response.getWriter().write(jsonPrettyPrintString);
                } catch (JSONException ex) {
                    Logger.getLogger(RestHarvest.class.getName()).log(Level.SEVERE, null, ex);
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