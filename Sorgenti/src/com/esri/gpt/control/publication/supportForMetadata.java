/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.esri.gpt.control.publication;


import com.esri.gpt.framework.context.RequestContext;
import com.esri.gpt.framework.sql.BaseDao;
import com.esri.gpt.framework.sql.ManagedConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.commons.lang3.StringUtils;


/**
 *
 * @author Administrator
 */
public class supportForMetadata {
    /** getNextIdentifier
     * Generates a new fileIdentifier for metadata (field ultimoID1) for the PA of the connected user in the forma
     * PACode:lastid+1 (0 padded on 6 digits):YYYYMMDD:HHMMSS
     * WARNING: concurrency is not considered
     * @param context
     * @return 
     */
    public static String getNextIdentifier(RequestContext context) {
        
        String valRet="";
        ManagedConnection mc;
        ResultSet rs = null;
        PreparedStatement st = null;
        try {
            mc = context.getConnectionBroker().returnConnection("");
            Connection con = mc.getJdbcConnection();
            String nomeUt = context.getUser().getName();
            // initialize
            st = con.prepareStatement("SELECT  p.ID, p.cod_ipa, p.ultimoID1 +1 FROM gpt_user u inner join gpt_pa p on p.ID = u.FK_IDPA where username like '%"  + nomeUt + "%' ");
            rs = st.executeQuery();

            while (rs.next()) {
                st = con.prepareStatement("UPDATE gpt_pa p SET p.ultimoID1 =p.ultimoID1 +1 WHERE P.ID = " + rs.getString(1));
                st.executeUpdate();
                DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd:HHmmss");
                Date date = new Date();
                valRet = rs.getString(2) + ":" + StringUtils.leftPad(rs.getString(3), 6, "0") + ":" + dateFormat.format(date);
            }

        } catch (SQLException ex) {

        } finally {
            BaseDao.closeResultSet(rs);
            BaseDao.closeStatement(st);                
        }            
        return valRet;
    }
    /** getCurrentIdentifier2
     * Returns the current dataIdentifier (field ultimoID2) for the PA of the connected user in the form
     * PACode:lastid+1 (0 padded on 6 digits):
     * @param context
     * @return 
     */
    public static String getCurrentIdentifier2(RequestContext context) {
        String valRet="";
        ManagedConnection mc;
        ResultSet rs = null;
        PreparedStatement st = null;
        try {
            mc = context.getConnectionBroker().returnConnection("");
            Connection con = mc.getJdbcConnection();
            String nomeUt = context.getUser().getName();
            // initialize
            st = con.prepareStatement("SELECT  p.ID, p.cod_ipa, p.ultimoID2 FROM gpt_user u inner join gpt_pa p on p.ID = u.FK_IDPA where username like '%"  + nomeUt + "%' ");
            rs = st.executeQuery();

            while (rs.next()) {
                /** Data identifier non ha la forma con data e ora 
                DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd:HHmmss");
                Date date = new Date();
                valRet = rs.getString(2) + ":" + StringUtils.leftPad(rs.getString(3), 6, "0") + ":" + dateFormat.format(date);
                * **/
                valRet = rs.getString(2) + ":" + StringUtils.leftPad(rs.getString(3), 6, "0");
            }

        } catch (SQLException ex) {

        } finally {
            BaseDao.closeResultSet(rs);
            BaseDao.closeStatement(st);                
        }            
        return valRet;
    }
    /** getNextIdentifier2
     * Fetches the current identifier for metadata (fileIdentifier) for the PA of the connected user
     * Is the user is not connected it raises an error. It returns the new identifier in the form: 
     *  PACode:lastid+1 (0 padded on 6 digits)
     * WARNING: concurrency is not considered
     * @param context
     * @return 
     */
    public static String getNextIdentifier2(RequestContext context) {
        
        String valRet="";
        ManagedConnection mc;
        ResultSet rs = null;
        PreparedStatement st = null;
        try {
            mc = context.getConnectionBroker().returnConnection("");
            Connection con = mc.getJdbcConnection();
            String nomeUt = context.getUser().getName();
            // initialize
            st = con.prepareStatement("SELECT  p.ID, p.cod_ipa, p.ultimoID2 +1 FROM gpt_user u inner join gpt_pa p on p.ID = u.FK_IDPA where username like '%"  + nomeUt + "%' ");
            rs = st.executeQuery();

            while (rs.next()) {
                st = con.prepareStatement("UPDATE gpt_pa p SET p.ultimoID2 =p.ultimoID2 +1 WHERE P.ID = " + rs.getString(1));
                st.executeUpdate();
                /** Data identifier non ha la forma con data e ora 
                DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd:HHmmss");
                Date date = new Date();
                valRet = rs.getString(2) + ":" + StringUtils.leftPad(rs.getString(3), 6, "0") + ":" + dateFormat.format(date);
                ***/
                valRet = rs.getString(2) + ":" + StringUtils.leftPad(rs.getString(3), 6, "0");
            }

        } catch (SQLException ex) {

        } finally {
            BaseDao.closeResultSet(rs);
            BaseDao.closeStatement(st);                
        }            
        return valRet;
    }
     /** getCurrentCodIPA
     * Returns the IPA code of the PA of the connected user 
     * @param context
     * @return 
     */
    public static String getCurrentCodIPA(RequestContext context) {
        
        String valRet="";
        ManagedConnection mc;
        ResultSet rs = null;
        PreparedStatement st = null;
        try {
            mc = context.getConnectionBroker().returnConnection("");
            Connection con = mc.getJdbcConnection();
            String nomeUt = context.getUser().getName();
            // initialize
            st = con.prepareStatement("SELECT  p.cod_ipa FROM gpt_user u inner join gpt_pa p on p.ID = u.FK_IDPA where username like '%"  + nomeUt + "%' ");
            rs = st.executeQuery();

            while (rs.next()) {
                valRet = rs.getString(1);
            }

        } catch (SQLException ex) {

        } finally {
            BaseDao.closeResultSet(rs);
            BaseDao.closeStatement(st);                
        }            
        return valRet;
    }
     /** getCurrentIdentifier
     * Returns the current fileIdentifier (field ultimoID1) for the PA of the connected user in the form
     * PACode:lastid+1 (0 padded on 6 digits):YYYYMMDD:HHMMSS
     * @param context
     * @return 
     */
    public static String getCurrentIdentifier(RequestContext context) {
        String valRet="";
        ManagedConnection mc;
        ResultSet rs = null;
        PreparedStatement st = null;
        try {
            mc = context.getConnectionBroker().returnConnection("");
            Connection con = mc.getJdbcConnection();
            String nomeUt = context.getUser().getName();
            // initialize
            st = con.prepareStatement("SELECT  p.ID, p.cod_ipa, p.ultimoID1 FROM gpt_user u inner join gpt_pa p on p.ID = u.FK_IDPA where username like '%"  + nomeUt + "%' ");
            rs = st.executeQuery();

            while (rs.next()) {
                DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd:HHmmss");
                Date date = new Date();
                valRet = rs.getString(2) + ":" + StringUtils.leftPad(rs.getString(3), 6, "0") + ":" + dateFormat.format(date);
            }

        } catch (SQLException ex) {

        } finally {
            BaseDao.closeResultSet(rs);
            BaseDao.closeStatement(st);                
        }            
        return valRet;
    }}
