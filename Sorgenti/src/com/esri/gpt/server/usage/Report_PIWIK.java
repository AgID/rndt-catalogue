/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.esri.gpt.server.usage;
import com.esri.gpt.control.identity.RestUserAddOn;
import com.esri.gpt.framework.context.RequestContext;
import com.esri.gpt.framework.sql.BaseDao;
import com.esri.gpt.framework.sql.ManagedConnection;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Iterator;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.Marshaller;
import org.json.JSONException;

/**
 *
 * @author Administrator
 */
public class Report_PIWIK extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private static final Logger LOGGER = Logger.getLogger(Report_PIWIK.class.getCanonicalName());
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        ServletOutputStream out = response.getOutputStream();
        out.write("ERRORE: questa funzione è disabilitata!".getBytes("UTF-8"));
        out.flush();
        out.close();

       
//        try  {
//            RequestContext ff;
//            boolean isJson=true;
//            /* TODO output your page here. You may use following sample code. */
//            Vector<String> vector = new Vector<String>();
//            Iterator<String> iter = request.getParameterMap().keySet().iterator();
//            while(iter.hasNext()) {
//                vector.add(iter.next());
//            }
//            
//            String startDate = "";
//            if (vector.contains("start-date")){
//                startDate= request.getParameter("start-date").toString();
//            }
//            String endDate = "";
//	    if (vector.contains("end-date")){
//                endDate= request.getParameter("end-date").toString();
//            }	
//            if (vector.contains("f")){
//                isJson=false;
//                if (request.getParameter("f").toString().equals("json")) isJson=true;
//            }
//            FA_RNDT clsFa = new FA_RNDT();
//            
//            StringBuilder  sbSelectWhere = new StringBuilder();
//            sbSelectWhere.append(" WHERE ");
//            if (startDate.length() > 0) {
//                sbSelectWhere.append(" AND "); 
//                sbSelectWhere.append(" UPDATEDATE >= ? ");
//            }
//            if (endDate.length() > 0) {
//                sbSelectWhere.append(" AND "); 
//                sbSelectWhere.append(" UPDATEDATE <= ? ");
//            }
//            StringBuilder  sbSelectSql = new StringBuilder();
//            sbSelectSql.append("select pa.nome, count(*) as conteggio, sum(coalesce(TIME_TO_SEC(TIMEDIFF(gl.DATA_OUT,gl.DATA_IN)),60)) as durata from gpt_user_login gl ");
//            sbSelectSql.append("inner join gpt_user u on u.USERID=gl.USERID inner join gpt_pa pa on pa.ID = u.FK_IDPA ");
//            sbSelectSql.append("where gl.DATA_IN >? ");
//            sbSelectSql.append("AND coalesce(gl.DATA_OUT,date_add(gl.DATA_IN,INTERVAL 30 MINUTE)) <?");
//            sbSelectSql.append("group by pa.nome");
//            ResultSet rs = fetchsql(request, sbSelectSql.toString(),startDate,endDate);
//
//            while (rs.next()){
//                FA_RNDT.clsItemElencoSessioniAccesso obj = clsFa.createclsItemElencoSessioniAccesso();
//                obj.Amministrazione = rs.getString(1);
//                obj.DurataSessione = rs.getInt(3);
//                clsFa.ElencoSessioniAccesso.item.add(obj);
//                
//                FA_RNDT.clsItemAmministrazioniAccessi obj2 = clsFa.createclsItemAmministrazioniAccessi();
//                obj2.Amministrazione= rs.getString(1);
//                obj2.NumeroAccessiAmministrazione=rs.getInt(2);
//                clsFa.ElencoAmministrazioniAccessi.item.add(obj2);
//                clsFa.NumeroAccessiTotalePA += rs.getInt(2);
//            }
//            rs.close();
//            
//            sbSelectSql = new StringBuilder();
//            sbSelectSql.append("select pa.nome, count(*) as conteggio from  gpt_user u ");
//            sbSelectSql.append("inner join gpt_pa pa on pa.ID = u.FK_IDPA inner join gpt_resource rr on rr.OWNER = u.USERID ");
//            sbSelectSql.append(" where rr.UPDATEDATE >?  AND rr.UPDATEDATE <? group by pa.nome ");
//            rs = fetchsql(request, sbSelectSql.toString(),startDate,endDate);
//            while (rs.next()){
//                FA_RNDT.clsItemElencoDocumentiPerAmministrazione obj = clsFa.createclsItemElencoDocumentiPerAmministrazione();
//                obj.NumeroDocumenti=rs.getInt(2);
//                obj.Amministrazione =  rs.getString(1);
//                clsFa.ElencoDocumentiPerAmministrazione.item.add(obj);
//                clsFa.NumeroDocumentiCaricati +=rs.getInt(2);
//            }
//            rs.close();
//            
//            sbSelectSql = new StringBuilder();
//
//            sbSelectSql.append("select rr.PUBMETHOD, count(*) as conteggio from  gpt_user u  ");
//            sbSelectSql.append("inner join gpt_resource rr on rr.OWNER = u.USERID ");
//            sbSelectSql.append(" where rr.UPDATEDATE >?  AND rr.UPDATEDATE <? group by rr.PUBMETHOD ");
//            rs = fetchsql(request, sbSelectSql.toString(),startDate,endDate);
//            while (rs.next()){
//                FA_RNDT.clsItemElencoDocumentiPerMetodoAccesso obj = clsFa.createclsItemElencoDocumentiPerMetodoAccesso();
//                obj.NumeroDocumenti=rs.getInt(2);
//                obj.MetodoAccesso =  rs.getString(1);
//                clsFa.ElencoDocumentiPerMetodoAccesso.item.add(obj);
//            }
//            rs.close();
//            
//            sbSelectSql = new StringBuilder();
//            sbSelectSql.append("select rr.APPROVALSTATUS, count(*) as conteggio from  gpt_user u  ");
//            sbSelectSql.append("inner join gpt_resource rr on rr.OWNER = u.USERID ");
//            sbSelectSql.append(" where rr.UPDATEDATE >?  AND rr.UPDATEDATE <? group by rr.APPROVALSTATUS ");
//            rs = fetchsql(request, sbSelectSql.toString(),startDate,endDate);
//            while (rs.next()){
//                FA_RNDT.clsItemElencoDocumentiPerOperazione obj = clsFa.createclsItemElencoDocumentiPerOperazione();
//                obj.NumeroDocumenti=rs.getInt(2);
//                obj.Operazione =  rs.getString(1);
//                clsFa.ElencoDocumentiPerOperazione.item.add(obj);
//            }
//            rs.close();            
//            
//            sbSelectSql = new StringBuilder();
// 
//            sbSelectSql.append("SELECT case st.HIERARCHY when 'dataset' then 'dataset' when '005' then 'dataset' when 'serie' then 'serie' when '006' then 'serie' when 'series' then 'serie' when 'servizio' then 'servizio' when 'service' then 'servizio' when 'services' then 'servizio' when '014' then 'servizio' end as tipo, count(*) FROM gpt_resource rr  ");
//            sbSelectSql.append("inner join gpt_resource_stat st on st.DOCUUID = rr.DOCUUID ");
//            sbSelectSql.append(" where rr.UPDATEDATE >?  AND rr.UPDATEDATE <? and APPROVALSTATUS = 'approved' group by tipo ");
//            rs = fetchsql(request, sbSelectSql.toString(),startDate,endDate);
//            while (rs.next()){
//                FA_RNDT.clsItemElencoMetadatiPerTipologia obj = clsFa.createclsItemElencoMetadatiPerTipologia();
//                obj.NumeroPerTipologia=rs.getInt(2);
//                obj.Tipologia =  rs.getString(1);
//                clsFa.ElencoMetadatiPerTipologia.item.add(obj);
//                clsFa.NumeroMetadati +=rs.getInt(2);
//            }
//            rs.close();  
//            
////DA FARE MEGLIO!!!//
//            sbSelectSql = new StringBuilder();
//            sbSelectSql.append("select pa.nome, count(*) as conteggio from  gpt_user u ");
//            sbSelectSql.append("inner join gpt_pa pa on pa.ID = u.FK_IDPA inner join gpt_resource rr on rr.OWNER = u.USERID ");
//            sbSelectSql.append(" where rr.UPDATEDATE >?  AND rr.UPDATEDATE <? and APPROVALSTATUS = 'approved' group by pa.nome ");
//            rs = fetchsql(request, sbSelectSql.toString(),startDate,endDate);
//            while (rs.next()){
//                FA_RNDT.clsItemElencoMetadatiPerAmministrazioni obj = clsFa.createclsItemElencoMetadatiPerAmministrazioni();
//                obj.NumeroPerAmministrazione=rs.getInt(2);
//                obj.Amministrazione =  rs.getString(1);
//                clsFa.ElencoMetadatiPerAmministrazioni.item.add(obj);
//            }
//            rs.close(); 
//            
//            sbSelectSql = new StringBuilder();
//            sbSelectSql.append("SELECT st.TOPIC, count(*) FROM gpt_resource rr  ");
//            sbSelectSql.append("inner join gpt_resource_stat_topic st on st.DOCUUID = rr.DOCUUID  ");
//            sbSelectSql.append(" where rr.UPDATEDATE >?  AND rr.UPDATEDATE <? and APPROVALSTATUS = 'approved' group by st.TOPIC ");
//            rs = fetchsql(request, sbSelectSql.toString(),startDate,endDate);
//            while (rs.next()){
//                FA_RNDT.clsItemElencoMetadatiPerCategorieTematiche obj = clsFa.createclsItemElencoMetadatiPerCategorieTematiche();
//                obj.NumeroPerCategoria=rs.getInt(2);
//                obj.Categoria =  rs.getString(1);
//                clsFa.ElencoMetadatiPerCategorieTematiche.item.add(obj);
//            }
//            rs.close(); 
//
//            sbSelectSql = new StringBuilder();
//            sbSelectSql.append("SELECT st.INSPIRE_THEME, count(*) FROM gpt_resource rr  ");
//            sbSelectSql.append("inner join gpt_resource_stat_inspire_theme st on st.DOCUUID = rr.DOCUUID  ");
//            sbSelectSql.append(" where rr.UPDATEDATE >?  AND rr.UPDATEDATE <? and APPROVALSTATUS = 'approved' group by st.INSPIRE_THEME ");
//            rs = fetchsql(request, sbSelectSql.toString(),startDate,endDate);
//            while (rs.next()){
//                FA_RNDT.clsItemElencoMetadatiPerTemiINSPIRE obj = clsFa.createclsItemElencoMetadatiPerTemiINSPIRE();
//                obj.NumeroPerTemaINSPIRE=rs.getInt(2);
//                obj.TemaINSPIRE =  rs.getString(1);
//                clsFa.ElencoMetadatiPerTemiINSPIRE.item.add(obj);
//            }
//            rs.close(); 
//            
//            sbSelectSql = new StringBuilder();
//            sbSelectSql.append("SELECT st.INSPIRE_SERVICE, count(*) FROM gpt_resource rr  ");
//            sbSelectSql.append("inner join gpt_resource_stat_inspire_service st on st.DOCUUID = rr.DOCUUID  ");
//            sbSelectSql.append(" where rr.UPDATEDATE >?  AND rr.UPDATEDATE <? and APPROVALSTATUS = 'approved' group by st.INSPIRE_SERVICE ");
//            rs = fetchsql(request, sbSelectSql.toString(),startDate,endDate);
//            while (rs.next()){
//                FA_RNDT.clsItemElencoMetadatiPerTassonomiaISO19119 obj = clsFa.createclsItemElencoMetadatiPerTassonomiaISO19119();
//                obj.NumeroPerTassonomiaISO19119=rs.getInt(2);
//                obj.TassonomiaISO19119 =  rs.getString(1);
//                clsFa.ElencoMetadatiPerTassonomiaISO19119.item.add(obj);
//            }
//            rs.close(); 
//
//            sbSelectSql = new StringBuilder();
//            sbSelectSql.append("SELECT st.SERVICE_TYPE, count(*) FROM gpt_resource rr  ");
//            sbSelectSql.append("inner join gpt_resource_stat_service_type st on st.DOCUUID = rr.DOCUUID  ");
//            sbSelectSql.append(" where rr.UPDATEDATE >?  AND rr.UPDATEDATE <? and APPROVALSTATUS = 'approved' group by st.SERVICE_TYPE ");
//            rs = fetchsql(request, sbSelectSql.toString(),startDate,endDate);
//            while (rs.next()){
//                FA_RNDT.clsItemElencoMetadatiPerTipologiaServizio obj = clsFa.createclsItemElencoMetadatiPerTipologiaServizio();
//                obj.NumeroPerTipologiaServizio=rs.getInt(2);
//                obj.TipologiaServizio =  rs.getString(1);
//                clsFa.ElencoMetadatiPerTipologiaServizio.item.add(obj);
//            }
//            rs.close(); 
//            String strOut="";
//            if (isJson) strOut= clsFa.generateString();
//            if (!isJson) strOut= clsFa.generateXmlString();
//            java.util.Date dd= new SimpleDateFormat("yyyy-MM-dd").parse(endDate);
//            Calendar cal = Calendar.getInstance();
//            cal.setTime(dd);
//            String nomeFile= String.valueOf(cal.get(Calendar.YEAR)) + String.format("%02d",cal.get(Calendar.MONTH)+1) + "_RNDT." + (isJson ? "json" : "xml");
//            sendFile(response, strOut,nomeFile);
//        } catch (Exception e){
//            LOGGER.log(Level.WARNING, "Error reading record.", e);
//        }
    }
    void sendFile(HttpServletResponse response,String sb, String nomeFile){
        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition","attachment;filename=" + nomeFile);

	try
	{
            ServletOutputStream out = response.getOutputStream();
            out.write(sb.getBytes("UTF-8"));
            out.flush();
            out.close();

	  } catch (Exception e){
          }

    }
    protected ResultSet fetchsql(HttpServletRequest request,String sql,String startDate, String endDate) throws SQLException {
        RequestContext ff = RequestContext.extract(request);
        ManagedConnection mc =ff.getConnectionBroker().returnConnection("");
        Connection con = mc.getJdbcConnection();
        ResultSet rs = null;
        PreparedStatement st = null;

        try {
            st = con.prepareStatement(sql);
            int parameterIdx = 1;
             if (startDate.length() > 0) {
                 st.setDate(parameterIdx, Date.valueOf(startDate));
                 parameterIdx++;
             }
             if (endDate.length() > 0) {
                 st.setDate(parameterIdx, Date.valueOf(endDate));
                 parameterIdx++;
             }
             rs = st.executeQuery();
        } catch (Exception e){
            return null;
        } finally {

        }
        return rs;
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
