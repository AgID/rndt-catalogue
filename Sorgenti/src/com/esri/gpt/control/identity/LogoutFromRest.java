/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.esri.gpt.control.identity;


import com.esri.gpt.control.rest.writer.ResponseWriter;
import java.io.IOException;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.esri.gpt.framework.context.BaseServlet;
import com.esri.gpt.framework.context.RequestContext;
import com.esri.gpt.framework.security.credentials.UsernamePasswordCredentials;
import com.esri.gpt.framework.security.identity.IdentityAdapter;
import com.esri.gpt.framework.security.principal.User;
import com.esri.gpt.framework.sql.BaseDao;
import com.esri.gpt.framework.sql.ManagedConnection;
import com.esri.gpt.sdisuite.IntegrationContext;
import com.esri.gpt.sdisuite.IntegrationContextFactory;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;

/**
 * Geoportal Usage servlet.
 * Provides Geoportal usage information. 
 */
public class LogoutFromRest extends BaseServlet {

	
/** Serialization key */
private static final long serialVersionUID = 1L;

private class userLogin{
    public String userName="";
    public boolean isAuthenticated=false;
}

// constructors ================================================================

/**
 * Creates instance of the servlet.
 */
public LogoutFromRest() {}

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

/**
 * Process the HTTP request.
 * @param request HTTP request.
 * @param response HTTP response.
 * @param context request context
 * @throws ServletException if error invoking command.
 * @throws IOException if error writing to the buffer.
 */
@SuppressWarnings("unused")
@Override
protected void execute(HttpServletRequest request,
                     HttpServletResponse response,
                     RequestContext context)
  throws Exception {
    try {
        insertLoginData(context);
        context.getUser().reset();
        User user = context.getUser();
        userLogin usr = new userLogin();
        if (!context.getUser().getAuthenticationStatus().getWasAuthenticated()) {
          usr.isAuthenticated=false;
        } else {
          usr.isAuthenticated=true;
          usr.userName=user.getName();
        }
        JSONObject jsonObj = new JSONObject();
        jsonObj.put("isAuthenticated", usr.isAuthenticated);
        jsonObj.put("userName", usr.userName);
        String jsonPrettyPrintString = jsonObj.toString(4);
        response.getWriter().write(jsonPrettyPrintString);
    } catch (Exception e){
        response.getWriter().write(e.getMessage());

    }
 }
public void insertLoginData(RequestContext context){
        ManagedConnection mc;
        ResultSet rs = null;
        PreparedStatement st = null;

        try {
            mc = context.getConnectionBroker().returnConnection("");
            Connection con = mc.getJdbcConnection();
            // initialize
            //st = con.prepareStatement("INSERT INTO `geoportal`.`gpt_user` (`DN`, `USERNAME`, `FK_IDPA`) VALUES ('" + ldapDN + "', '" + nomeUtente +"', '" + idPA + "')");
            DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            Date date = new Date();

            st=con.prepareStatement("UPDATE `geoportal`.`gpt_user_login` set DATA_OUT = '" + dateFormat.format(date).toString() +"' WHERE ID = " + context.getUser().getIDSession());
            int ret = st.executeUpdate();

         } catch (SQLException ex) {
        } finally {
            BaseDao.closeResultSet(rs);
            BaseDao.closeStatement(st);                
        }            

    }

}
