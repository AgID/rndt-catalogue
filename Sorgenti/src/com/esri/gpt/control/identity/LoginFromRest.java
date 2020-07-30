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
import com.esri.gpt.sdisuite.IntegrationContext;
import com.esri.gpt.sdisuite.IntegrationContextFactory;

import org.json.JSONObject;

/**
 * Geoportal Usage servlet.
 * Provides Geoportal usage information. 
 */
public class LoginFromRest extends BaseServlet {

	
/** Serialization key */
private static final long serialVersionUID = 1L;

public static class userLogin{
    public String userName="";
    public boolean isAuthenticated=false;
}

// constructors ================================================================

/**
 * Creates instance of the servlet.
 */
public LoginFromRest() {}

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

    
    userLogin usr = new userLogin();
    User user = context.getUser();

    user.reset();
    UsernamePasswordCredentials creds = new UsernamePasswordCredentials();
    creds.setUsername(request.getParameter("UID").toString());
    creds.setPassword(request.getParameter("PWD").toString());
    user.setCredentials(creds);
    
    // authenticate the user
    IdentityAdapter idAdapter = context.newIdentityAdapter();
    idAdapter.authenticate(user);
    
    // inform if sdi.suite integration is enabled
    IntegrationContextFactory icf = new IntegrationContextFactory();
    IntegrationContext ic;
    if (icf.isIntegrationEnabled()) {
      
        try {
            ic = icf.newIntegrationContext();
            if (ic != null) {
              ic.ensureToken(user);
              ic.initializeUser(user);
            }
        } catch (ClassNotFoundException ex) {
        } catch (InstantiationException ex) {
        } catch (IllegalAccessException ex) {
        }
    }
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
}
