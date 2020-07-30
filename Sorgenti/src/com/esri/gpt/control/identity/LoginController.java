/* See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * Esri Inc. licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.esri.gpt.control.identity;

import com.esri.gpt.control.ResourceKeys;
import com.esri.gpt.framework.collection.StringAttributeMap;
import com.esri.gpt.framework.context.RequestContext;
import com.esri.gpt.framework.jsf.BaseActionListener;
import com.esri.gpt.framework.security.credentials.CredentialsDeniedException;
import com.esri.gpt.framework.security.credentials.UsernamePasswordCredentials;
import com.esri.gpt.framework.security.identity.IdentityAdapter;
import com.esri.gpt.framework.security.principal.User;
import com.esri.gpt.framework.sql.BaseDao;
import com.esri.gpt.framework.sql.ManagedConnection;
import com.esri.gpt.framework.util.Val;
import com.esri.gpt.sdisuite.IntegrationContext;
import com.esri.gpt.sdisuite.IntegrationContextFactory;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.faces.context.ExternalContext;
import javax.faces.event.AbortProcessingException;
import javax.faces.event.ActionEvent;
import javax.servlet.http.HttpSession;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Handles login and logout actions.
 */
public class LoginController extends BaseActionListener {

// class variables =============================================================
// instance variables ==========================================================
    private UsernamePasswordCredentials _credentials;

// constructors ================================================================
    /**
     * Default constructor.
     */
    public LoginController() {
        setCredentials(new UsernamePasswordCredentials());
    }

// properties ==================================================================
    /**
     * Gets the credentials.
     *
     * @return the credentials
     */
    public UsernamePasswordCredentials getCredentials() {
        return _credentials;
    }

    /**
     * Sets the credentials.
     *
     * @param credentials the credentials
     */
    private void setCredentials(UsernamePasswordCredentials credentials) {
        _credentials = credentials;
    }

// methods =====================================================================
    /**
     * Invalidates the active user and session.
     *
     * @param context the context associated with the active request
     */
    private void invalidateSession(RequestContext context) {
        context.getUser().reset();
        HttpSession session = getContextBroker().extractHttpSession();
        if (session != null) {
            session.invalidate();
        }
    }

    /**
     * Fired when the getPrepareView() property is accessed.
     * <br/>This event is triggered from the page during the render response
     * phase of the JSF cycle.
     *
     * @param context the context associated with the active request
     * @throws Exception if an exception occurs
     */
    @Override
    protected void onPrepareView(RequestContext context) throws Exception {
        if (context.getUser().getAuthenticationStatus().getWasAuthenticated()) {
            ExternalContext ec = getContextBroker().getExternalContext();
            if (ec != null) {
                ec.redirect(Val.chkStr(ec.getRequestContextPath() + "/catalog/main/home.page"));
            }
        }
    }

    /**
     * Handles a logout action.
     *
     * @param event the associated JSF action event
     * @throws AbortProcessingException if processing should be aborted
     */
    public void processLogout(ActionEvent event)
            throws AbortProcessingException {
        try {
            RequestContext context = onExecutionPhaseStarted();
            invalidateSession(context);
        } catch (AbortProcessingException e) {
            throw (e);
        } catch (Throwable t) {
            handleException(t);
        } finally {
            onExecutionPhaseCompleted();
        }
    }

    /**
     * Handles a login action.
     * <br/>This is the default entry point for a sub-class of
     * BaseActionListener.
     * <br/>This BaseActionListener handles the JSF processAction method and
     * invokes the processSubAction method of the sub-class.
     *
     * @param event the associated JSF action event
     * @param context the context associated with the active request
     * @throws AbortProcessingException if processing should be aborted
     * @throws Exception if an exception occurs
     */
    @Override
    protected void processSubAction(ActionEvent event, RequestContext context)
            throws AbortProcessingException, Exception {
        /*ESRI ITALIA 07/04/2017*/
        Boolean isStandard = true;
        String functionOutput = "";
        LoginFromRest.userLogin usr = new LoginFromRest.userLogin();
        StringAttributeMap params = context.getCatalogConfiguration().getParameters();
        if (params.containsKey("catalog.outputLogin")) {
            functionOutput = params.getValue("catalog.outputLogin").toString();
        }
        if (!functionOutput.equals("")) {
            isStandard = false;
        }
        /*ESRI ITALIA 07/04/2017*/
        try {
            // set the user credentials
            User user = context.getUser();
            user.reset();
            UsernamePasswordCredentials creds = new UsernamePasswordCredentials();
            creds.setUsername(getCredentials().getUsername());
            creds.setPassword(getCredentials().getPassword());
            user.setCredentials(creds);

            // authenticate the user
            IdentityAdapter idAdapter = context.newIdentityAdapter();
            idAdapter.authenticate(user);

            // inform if sdi.suite integration is enabled
            IntegrationContextFactory icf = new IntegrationContextFactory();
            if (icf.isIntegrationEnabled()) {
                IntegrationContext ic = icf.newIntegrationContext();
                if (ic != null) {
                    ic.ensureToken(user);
                    ic.initializeUser(user);
                }
            }
            /*ESRI ITALIA 07/04/2017*/
            if (!context.getUser().getAuthenticationStatus().getWasAuthenticated()) {
                usr.isAuthenticated = false;
            } else {
                int id = insertLoginData(context);
                context.getUser().setIDSession(id);
                usr.isAuthenticated = true;
                usr.userName = user.getName();
            }

            JSONObject jsonObj = new JSONObject();
            jsonObj.put("isAuthenticated", usr.isAuthenticated);
            jsonObj.put("userName", usr.userName);

            String jsonPrettyPrintString = jsonObj.toString();
            if (isStandard) {
                /*ESRI ITALIA 07/04/2017*/
                setNavigationOutcome(ResourceKeys.NAVIGATIONOUTCOME_HOME_DIRECT);
                String[] args = new String[1];
                args[0] = user.getName();
                extractMessageBroker().addSuccessMessage("identity.login.success", args);
            } else {
                setNavigationOutcome("catalog.harvest.manage.history.redirect");
                context.getServletRequest().setAttribute("location", functionOutput + "('" + jsonPrettyPrintString + "','*');");
            }
            // set the outcome
        } catch (CredentialsDeniedException e) {
            if (isStandard) {
                extractMessageBroker().addErrorMessage("identity.login.err.denied");
            } else {
                JSONObject jsonObj = new JSONObject();
                jsonObj.put("isAuthenticated", false);
                jsonObj.put("userName", "");
                setNavigationOutcome("catalog.harvest.manage.history.redirect");
                context.getServletRequest().setAttribute("location", functionOutput + "('" + jsonObj.toString() + "','*');");
            }
        }
    }

    public int insertLoginData(RequestContext context) {
        ManagedConnection mc;
        int ritorno = 0;
        ResultSet rs = null;
        PreparedStatement st = null;

        try {
            mc = context.getConnectionBroker().returnConnection("");
            Connection con = mc.getJdbcConnection();
                // initialize
            //st = con.prepareStatement("INSERT INTO `geoportal`.`gpt_user` (`DN`, `USERNAME`, `FK_IDPA`) VALUES ('" + ldapDN + "', '" + nomeUtente +"', '" + idPA + "')");
            DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            Date date = new Date();

            st = con.prepareStatement("INSERT INTO `geoportal`.`gpt_user_login` (`ID`, `USERID`, `DATA_IN`) select max(`ID`)+1 ,  '" + context.getUser().getLocalID() + "', '" + dateFormat.format(date).toString() + "' from `geoportal`.`gpt_user_login`");
            int ret = st.executeUpdate();
            if (ret > 0) {
                st = con.prepareStatement("SELECT MAX(ID) FROM `geoportal`.`gpt_user_login`");
                rs = st.executeQuery();

                while (rs.next()) {
                    ritorno = rs.getInt(1);
                }
            }

        } catch (SQLException ex) {
        } finally {
            BaseDao.closeResultSet(rs);
            BaseDao.closeStatement(st);
            return ritorno;
        }

    }
}
