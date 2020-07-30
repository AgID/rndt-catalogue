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
package com.esri.gpt.server.usage.harvester;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;

import com.esri.gpt.control.rest.writer.ResponseWriter;
import com.esri.gpt.framework.collection.StringAttributeMap;
import com.esri.gpt.framework.context.ApplicationContext;
import com.esri.gpt.framework.sql.BaseDao;
import static com.esri.gpt.framework.sql.BaseDao.closeStatement;
import com.esri.gpt.framework.sql.IClobMutator;
import com.esri.gpt.framework.sql.ManagedConnection;
import com.esri.gpt.framework.util.DateProxy;
import com.esri.gpt.framework.util.UuidUtil;
import static com.esri.gpt.framework.util.UuidUtil.isUuid;
import com.esri.gpt.framework.util.Val;
import com.esri.gpt.server.usage.api.IStatisticsWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringWriter;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;
import org.apache.commons.io.IOUtils;
import org.json.JSONObject;
import org.json.XML;
import static java.util.stream.Collectors.toList;

/**
 * Harvester statistics data access object.
 */
public class HarvesterStatisticsDao extends BaseDao {

    // class variables =============================================================

    // instance variables ==========================================================
    private ResponseWriter writer = null;
    private IStatisticsWriter statWriter;
    private boolean isDbCaseSensitive = false;
    private class statistic{
        List<dettaglio> elenco = new ArrayList<dettaglio>();
        String tipologia="";
        List<String> raggruppamenti= new ArrayList<String>();
    }
    private class dettaglio{
        public String utente="";
        public String tipoEnte="";
        List<conteggi> arrConteggi= new ArrayList<conteggi>();
    }
    private class conteggi {
        public String raggruppamento="";
        public long conteggio=0;
}
    public enum StatisticsType {

	STATO("STATO"),
	METODO("METODO"),
	TIPOLOGIA("TIPOLOGIA"),
	CATEGORIA("CATEGORIA"),
	INSPIRE("INSPIRE"),
	SERVIZIO("SERVIZIO"),
	RESPONSABILE("RESPONSABILE");
	
	private String type;
	
	StatisticsType(String type){
		this.type = type;
	}
	
}

    // constructors ================================================================
    /**
     * Creates instance of the DAO.
     *
     * @param writer response writer
     */
    public HarvesterStatisticsDao(ResponseWriter writer) {
        this.writer = writer;
        this.statWriter = (IStatisticsWriter) writer;
        StringAttributeMap params = ApplicationContext.getInstance().getConfiguration().getCatalogConfiguration().getParameters();
        String s = Val.chkStr(params.getValue("database.isCaseSensitive"));
        isDbCaseSensitive = !s.equalsIgnoreCase("false");

    }
private String  addClauseH(String uuids, String startDate, String endDate, String dateField, String HarvestID) {
        StringBuilder sbSelectSql = new StringBuilder();
        boolean addWhere = true;
        String[] uuidArr = null;
        if (uuids.length() > 0 && uuids.indexOf(",") > -1) {
            uuidArr = uuids.split(",");
            if (uuidArr.length > 10) {
                uuidArr = null;
                uuids = "";
            } else {
                uuids = "(";
                for (int i = 0; i < uuidArr.length; i++) {
                    if (i == 0) {
                        uuids += "?";
                    } else {
                        uuids += ",?";
                    }
                }
                uuids += ")";
            }
        } else if (uuids.length() > 0) {
            uuids = "(?)";
        }

        if (uuids.length() > 0) {
            sbSelectSql.append(" WHERE HARVEST_ID IN ").append(uuids);
            addWhere = false;
        }
        if (startDate.length() > 0) {
            if (addWhere) {
                sbSelectSql.append(" WHERE ");
            } else {
                sbSelectSql.append(" AND ");
            }
            addWhere = false;
            sbSelectSql.append(dateField).append(" >= ?");
        }
        if (endDate.length() > 0) {
            if (addWhere) {
                sbSelectSql.append(" WHERE ");
            } else {
                sbSelectSql.append(" AND ");
            }
            addWhere=false;
            sbSelectSql.append(dateField).append(" <= ?");
        }
        if (HarvestID.length() > 0) {
            if (addWhere) {
                sbSelectSql.append(" WHERE ");
            } else {
                sbSelectSql.append(" AND ");
            }

            sbSelectSql.append(" HARVEST_ID IN ('").append(HarvestID).append("')");
            addWhere = false;
        }
        sbSelectSql.append(" ORDER BY ").append(dateField);
        return sbSelectSql.toString();
    }
	// properties ==================================================================
    // methods ==================================================================			
    /**
     * Adds clauses to sql query based on given constraints.
     *
     * @param uuids the uuids constraint
     * @param startDate the start date constraint
     * @param endDate the end date constraint
     * @param dateField the date field to be used to apply date constraints
     * @return the where clause
     */
    private String addClause(String uuids, String startDate, String endDate, String dateField) {
        StringBuilder sbSelectSql = new StringBuilder();
        boolean addWhere = true;
        String[] uuidArr = null;
        if (uuids.length() > 0 && uuids.indexOf(",") > -1) {
            uuidArr = uuids.split(",");
            if (uuidArr.length > 10) {
                uuidArr = null;
                uuids = "";
            } else {
                uuids = "(";
                for (int i = 0; i < uuidArr.length; i++) {
                    if (i == 0) {
                        uuids += "?";
                    } else {
                        uuids += ",?";
                    }
                }
                uuids += ")";
            }
        } else if (uuids.length() > 0) {
            uuids = "(?)";
        }

        if (uuids.length() > 0) {
            sbSelectSql.append(" WHERE UUID IN ").append(uuids);
            addWhere = false;
        }
        if (startDate.length() > 0) {
            if (addWhere) {
                sbSelectSql.append(" WHERE ");
            } else {
                sbSelectSql.append(" AND ");
            }
            addWhere = false;
            sbSelectSql.append(dateField).append(" >= ?");
        }
        if (endDate.length() > 0) {
            if (addWhere) {
                sbSelectSql.append(" WHERE ");
            } else {
                sbSelectSql.append(" AND ");
            }
            sbSelectSql.append(dateField).append(" <= ?");
        }
        sbSelectSql.append(" ORDER BY ").append(dateField);
        return sbSelectSql.toString();
    }

    /**
     * Creates Select SQL to count harvesting history table
     *
     * @return Select SQL
     */
    protected String createHistoryCountsSQL(int timePeriod) {
        StringBuilder sbSelectSql = new StringBuilder();
        sbSelectSql.append("select sum(HARVESTED_COUNT) as hc,sum(VALIDATED_COUNT) as vc, sum(PUBLISHED_COUNT) as pc from ")
          .append(getHarvestingHistoryTableName());
        if (timePeriod != -1) {
            sbSelectSql.append(" where HARVEST_DATE > ? ");
        }
        return sbSelectSql.toString();
    }
    
    protected statistic fetchGroupStat(String sql, String startDate, String endDate) throws SQLException {
        statistic retObj = new statistic();

        ManagedConnection mc = returnConnection();
        Connection con = mc.getJdbcConnection();
        ResultSet rs = null;
        PreparedStatement st = null;
        Logger.getLogger(HarvesterStatisticsDao.class.getName()).log(Level.FINE, "Preparing query:" + sql, (Throwable)null);

        try {
           st = con.prepareStatement(sql);
            /*if (!owner.equals("")) {
                st.setString(1, owner);
            }*/
           int parameterIdx = 1;
            if (startDate.length() > 0) {
                // La data può essere  yyyy-mm-dd e allora dobbiamo aggiungere hh:mm:ss dell'inizio. 15 è un valore intermedio
                if (startDate.trim().length() < 15)
                    startDate = startDate + " 00:00:00";
//                st.setDate(parameterIdx, Date.valueOf(startDate));
                st.setTimestamp(parameterIdx, java.sql.Timestamp.valueOf(startDate));
                parameterIdx++;
            }
            if (endDate.length() > 0) {
                // La data può essere  yyyy-mm-dd e allora  noi dobbiamo aggiungere hh:mm:ss della fine
                if (endDate.trim().length() < 15)
                    endDate = endDate + " 23:59:59";
//                st.setDate(parameterIdx, Date.valueOf(endDate));
                st.setTimestamp(parameterIdx, java.sql.Timestamp.valueOf(endDate));
                parameterIdx++;
            }
            Logger.getLogger(HarvesterStatisticsDao.class.getName()).log(Level.FINE, "Query:" + st, (Throwable)null);
            rs = st.executeQuery();
            String lastUSer="";
            dettaglio objDett = new dettaglio();
            while (rs.next()) {
                if (! lastUSer.equals(rs.getString(1))){
                    if (! lastUSer.equals("")) retObj.elenco.add(objDett);
                    objDett = new dettaglio();
                    objDett.utente = rs.getString(1);
                    objDett.tipoEnte=rs.getString(2);
                    lastUSer = rs.getString(1);
                    objDett.arrConteggi= new ArrayList<conteggi>();
                    
                }
                conteggi objCont = new conteggi();
                retObj.raggruppamenti.add(rs.getString(3));
                objCont.raggruppamento=rs.getString(3);
                objCont.conteggio = rs.getLong(4);
                objDett.arrConteggi.add(objCont);
            }
            retObj.elenco.add(objDett);
            return retObj;
        } finally {
            BaseDao.closeResultSet(rs);
            BaseDao.closeStatement(st);
            getRequestContext().getConnectionBroker().closeConnection(mc);
        }
    }

    protected Boolean verifySQLInjection(String parametro){
        // Verifica che non ci sia un'istruzione pericolosa
        if (parametro.isEmpty() || parametro.equals(""))
            return(false);
        String parametroLC = parametro.toLowerCase();
        if (
                parametroLC.contains("select") ||
                parametroLC.contains("delete") ||
                parametroLC.contains("update") ||
                parametroLC.contains("insert") )
            return(true);
        return(false);
    }
            
    
    protected String createAndFetchSelectGroupByMetadataSQL(String owner, String listType, String datiPA, String datiTipoPA, String startDate,String endDate){
        List<statistic> elencostat = new ArrayList<statistic>();
        List<String> elencoS = Arrays.asList(listType.split(","));

        // Prima di tutto cerco di verificare che non ci sia un SQLInjection
        if (verifySQLInjection(owner) || verifySQLInjection(datiPA) || verifySQLInjection(datiTipoPA)) {
            Logger.getLogger(HarvesterStatisticsDao.class.getName()).log(Level.SEVERE, "SQL Injection su uno dei parametri: [" + owner + "][" + datiPA + "][" + datiTipoPA + "]", (Throwable)null);
            return("");
        }
        statistic objStat=new statistic();        
        StringBuilder sbSelectSql = new StringBuilder();
        if (owner.equals("")) owner="*";
        //if (datiPA.equals("")) datiPA="*";
        String Ragg = " '*' as USERNAME_LOC, '*' as tipoPA_LOC,";
        String strGroupBy = "USERNAME_LOC, tipoPA_LOC";
        
        // Devo fare l'escape di datiTipoPA 
        if (!datiTipoPA.isEmpty()){
            datiTipoPA = datiTipoPA.replaceAll("'", "\\\\'");
            datiTipoPA = datiTipoPA.replaceAll("\\\"", "\\\\\"");
        }
        if ((!datiPA.equals("s"))&& (!datiPA.isEmpty())){
            Ragg= "p.nome as USERNAME_LOC,p.tipoPA as tipoPA_LOC,";
            strGroupBy = "USERNAME_LOC,tipoPA_LOC";
 
            //é stato impostato il 
            //if (! isRagg) Ragg= "u.USERNAME as USERNAME_LOC,";
        }
        if ((!datiTipoPA.equals("s"))&& (!datiTipoPA.isEmpty())){
            Ragg= "p.tipoPA as USERNAME_LOC,p.tipoPA as tipoPA_LOC,";
            strGroupBy = "USERNAME_LOC,tipoPA_LOC";
        }
        if ((listType.equals("")) ||(elencoS.contains(StatisticsType.TIPOLOGIA.toString()))){
            //TIPOLOGIA:
            
            /*
            SELECT p.nome,p.tipoPA, s.HIERARCHY, count(*) FROM gpt_resource_stat s inner join gpt_resource r on r.DOCUUID = s.DOCUUID 
inner join gpt_user u on u.USERID = r.OWNER inner join gpt_pa p on p.ID = u.FK_IDPA
group by p.nome,p.tipoPA, s.HIERARCHY
            */
            sbSelectSql.append("SELECT " + Ragg + " s.HIERARCHY, count(*) FROM gpt_resource_stat s inner join gpt_resource r on r.DOCUUID = s.DOCUUID ");
            sbSelectSql.append("inner join gpt_user u on u.USERID = r.OWNER inner join gpt_pa p on p.ID = u.FK_IDPA");
            if ((!datiPA.isEmpty()) && (!datiPA.equals("*")) && (!datiPA.equals("s"))){
                //sbSelectSql.append("WHERE u.USERNAME like '%?%' ");
               sbSelectSql.append(" WHERE u.FK_IDPA =  " + datiPA);
             
            }
            if ((!datiTipoPA.isEmpty()) && (!datiTipoPA.equals("*")) && (!datiTipoPA.equals("s"))){
                //sbSelectSql.append("WHERE u.USERNAME like '%?%' ");
               sbSelectSql.append(" WHERE p.tipoPA =  '" + datiTipoPA + "'");
             
            }
            if ((!owner.equals("*")) && (owner.length()>0)){
                //sbSelectSql.append("WHERE u.USERNAME like '%?%' ");
                if (sbSelectSql.toString().contains("WHERE")) {
                    sbSelectSql.append(" AND "); 
                } else {
                    sbSelectSql.append(" WHERE ");
                }
                sbSelectSql.append("u.USERID =  " + owner);
            }
            if (startDate.length() > 0) {
                if (sbSelectSql.toString().contains("WHERE")) {
                    sbSelectSql.append(" AND "); 
                } else {
                    sbSelectSql.append(" WHERE ");
                }
                sbSelectSql.append(" UPDATEDATE >= ? ");
            }
            if (endDate.length() > 0) {
                if (sbSelectSql.toString().contains("WHERE")) {
                    sbSelectSql.append(" AND "); 
                } else {
                    sbSelectSql.append(" WHERE ");
                }
                sbSelectSql.append(" UPDATEDATE <= ? ");
            }
            // Solo gli approvati
            sbSelectSql.append(" AND r.APPROVALSTATUS = 'approved' "); 
            
            sbSelectSql.append(" group by " + strGroupBy + ",s.HIERARCHY ");
            try {
                objStat = fetchGroupStat(sbSelectSql.toString(), startDate,endDate);
                objStat.tipologia=StatisticsType.TIPOLOGIA.toString();
            } catch (SQLException ex) {
                Logger.getLogger(HarvesterStatisticsDao.class.getName()).log(Level.SEVERE, null, ex);
            }
            elencostat.add(objStat);            
        }
       
        if ((listType.equals("")) ||(elencoS.contains(StatisticsType.STATO.toString()))){
            /*STATO*/
            objStat = new statistic();
            sbSelectSql = new StringBuilder();
            sbSelectSql.append("SELECT " + Ragg + " r.APPROVALSTATUS, count(*) FROM gpt_resource r ");
            sbSelectSql.append("inner join gpt_user u on u.USERID = r.OWNER  inner join gpt_pa p on p.ID = u.FK_IDPA ");
            if ((!datiPA.isEmpty()) && (!datiPA.equals("*")) && (!datiPA.equals("s"))){
                //sbSelectSql.append("WHERE u.USERNAME like '%?%' ");
               sbSelectSql.append(" WHERE u.FK_IDPA =  " + datiPA);
             
            }
            if ((!datiTipoPA.isEmpty()) && (!datiTipoPA.equals("*")) && (!datiTipoPA.equals("s"))){
                //sbSelectSql.append("WHERE u.USERNAME like '%?%' ");
               sbSelectSql.append(" WHERE p.tipoPA =  '" + datiTipoPA + "'");
             
            }
            if (!owner.equals("*")){
                //sbSelectSql.append(" WHERE u.USERNAME like '%?%' ");
                if (sbSelectSql.toString().contains("WHERE")) {
                    sbSelectSql.append(" AND "); 
                } else {
                    sbSelectSql.append(" WHERE ");
                }
                sbSelectSql.append("u.USERID =  " + owner);
            }
            if (startDate.length() > 0) {
                if (sbSelectSql.toString().contains("WHERE")) {
                    sbSelectSql.append(" AND "); 
                } else {
                    sbSelectSql.append(" WHERE ");
                }
                sbSelectSql.append(" UPDATEDATE >= ? ");
            }
            if (endDate.length() > 0) {
                if (sbSelectSql.toString().contains("WHERE")) {
                    sbSelectSql.append(" AND "); 
                } else {
                    sbSelectSql.append(" WHERE ");
                }
                sbSelectSql.append(" UPDATEDATE <= ? ");
            }
            sbSelectSql.append(" group by " + strGroupBy + ", r.APPROVALSTATUS ");
            try {
                objStat = fetchGroupStat(sbSelectSql.toString(),startDate,endDate);
                objStat.tipologia=StatisticsType.STATO.toString();
            } catch (SQLException ex) {
                Logger.getLogger(HarvesterStatisticsDao.class.getName()).log(Level.SEVERE, null, ex);
            }
            elencostat.add(objStat);
        }
        
        if ((listType.equals("")) ||(elencoS.contains(StatisticsType.METODO.toString()))){
            /*Metodo di caricamento*/
            objStat = new statistic();
            sbSelectSql = new StringBuilder();
            sbSelectSql.append("SELECT " + Ragg + " r.PUBMETHOD, count(*) FROM gpt_resource r  ");
            sbSelectSql.append("inner join gpt_user u on u.USERID = r.OWNER  inner join gpt_pa p on p.ID = u.FK_IDPA ");
            if ((!datiPA.isEmpty()) && (!datiPA.equals("*")) && (!datiPA.equals("s"))){
                //sbSelectSql.append("WHERE u.USERNAME like '%?%' ");
               sbSelectSql.append(" WHERE u.FK_IDPA =  " + datiPA);
             
            }
            if ((!datiTipoPA.isEmpty()) && (!datiTipoPA.equals("*")) && (!datiTipoPA.equals("s"))){
                //sbSelectSql.append("WHERE u.USERNAME like '%?%' ");
               sbSelectSql.append(" WHERE p.tipoPA =  '" + datiTipoPA + "'");
             
            }
            if (!owner.equals("*")){
                //sbSelectSql.append("WHERE u.USERNAME like '%?%' ");
                if (sbSelectSql.toString().contains("WHERE")) {
                    sbSelectSql.append(" AND "); 
                } else {
                    sbSelectSql.append(" WHERE ");
                }
                sbSelectSql.append("u.USERID =  " + owner);
            }
            if (startDate.length() > 0) {
                if (sbSelectSql.toString().contains("WHERE")) {
                    sbSelectSql.append(" AND "); 
                } else {
                    sbSelectSql.append(" WHERE ");
                }
                sbSelectSql.append(" UPDATEDATE >= ? ");
            }
            if (endDate.length() > 0) {
                if (sbSelectSql.toString().contains("WHERE")) {
                    sbSelectSql.append(" AND "); 
                } else {
                    sbSelectSql.append(" WHERE ");
                }
                sbSelectSql.append(" UPDATEDATE <= ? ");
            }
            sbSelectSql.append(" group by " + strGroupBy + ", r.PUBMETHOD ");
            try {
                objStat = fetchGroupStat(sbSelectSql.toString(),startDate,endDate);
                objStat.tipologia=StatisticsType.METODO.toString();
            } catch (SQLException ex) {
                Logger.getLogger(HarvesterStatisticsDao.class.getName()).log(Level.SEVERE, null, ex);
            }
            elencostat.add(objStat);
        }
        if ((listType.equals("")) ||(elencoS.contains(StatisticsType.CATEGORIA.toString()))){
            /*Categoria tematica*/
            objStat = new statistic();
            sbSelectSql = new StringBuilder();
            sbSelectSql.append("SELECT " + Ragg + " t.TOPIC, count(*) FROM gpt_resource r inner join gpt_resource_stat_topic t on t.DOCUUID = r.DOCUUID ");
            sbSelectSql.append("inner join gpt_user u on u.USERID = r.OWNER  inner join gpt_pa p on p.ID = u.FK_IDPA WHERE r.APPROVALSTATUS = 'approved' ");
            if ((!datiPA.isEmpty()) && (!datiPA.equals("*")) && (!datiPA.equals("s"))){
                //sbSelectSql.append("WHERE u.USERNAME like '%?%' ");
               sbSelectSql.append("AND u.FK_IDPA =  " + datiPA);
             
            }
            if ((!datiTipoPA.isEmpty()) && (!datiTipoPA.equals("*")) && (!datiTipoPA.equals("s"))){
                //sbSelectSql.append(" WHERE u.USERNAME like '%?%' ");
               sbSelectSql.append("AND p.tipoPA =  '" + datiTipoPA + "'");
             
            }
            if (!owner.equals("*")){
                //sbSelectSql.append(" WHERE u.USERNAME like '%?%' ");
                sbSelectSql.append(" AND u.USERID =  " + owner);
            }
            if (startDate.length() > 0) {
                sbSelectSql.append(" AND UPDATEDATE >= ? ");
            }
            if (endDate.length() > 0) {
                sbSelectSql.append(" AND UPDATEDATE <= ? ");
            }
            sbSelectSql.append(" group by " + strGroupBy + ", t.TOPIC ");
            try {
                objStat = fetchGroupStat(sbSelectSql.toString(),startDate,endDate);
                objStat.tipologia=StatisticsType.CATEGORIA.toString();
            } catch (SQLException ex) {
                Logger.getLogger(HarvesterStatisticsDao.class.getName()).log(Level.SEVERE, null, ex);
            }
            elencostat.add(objStat);
        }
        if ((listType.equals("")) ||(elencoS.contains(StatisticsType.INSPIRE.toString()))){
            /*Tema INSPIRE*/
            objStat = new statistic();
            sbSelectSql = new StringBuilder();
            sbSelectSql.append("SELECT " + Ragg + " i.INSPIRE_THEME, count(*) FROM gpt_resource r inner join gpt_resource_stat_inspire_theme i on i.DOCUUID = r.DOCUUID ");
            sbSelectSql.append("inner join gpt_user u on u.USERID = r.OWNER  inner join gpt_pa p on p.ID = u.FK_IDPA WHERE r.APPROVALSTATUS = 'approved' ");
            if ((!datiPA.isEmpty()) && (!datiPA.equals("*")) && (!datiPA.equals("s"))){
                //sbSelectSql.append("WHERE u.USERNAME like '%?%' ");
               sbSelectSql.append("AND u.FK_IDPA =  " + datiPA);
             
            }
            if ((!datiTipoPA.isEmpty()) && (!datiTipoPA.equals("*")) && (!datiTipoPA.equals("s"))){
                //sbSelectSql.append("WHERE u.USERNAME like '%?%' ");
               sbSelectSql.append("AND p.tipoPA =  '" + datiTipoPA + "'");
             
            }
            if (!owner.equals("*")){
                sbSelectSql.append(" AND u.USERID =  " + owner);
            }
            if (startDate.length() > 0) {
                sbSelectSql.append(" AND UPDATEDATE >= ? ");
            }
            if (endDate.length() > 0) {
                sbSelectSql.append(" AND UPDATEDATE <= ? ");
            }
            // Solo gli approvati
            sbSelectSql.append(" AND r.APPROVALSTATUS = 'approved' "); 
            
            sbSelectSql.append(" group by " + strGroupBy + ", i.INSPIRE_THEME ");
            try {
                objStat = fetchGroupStat(sbSelectSql.toString(),startDate,endDate);
                objStat.tipologia=StatisticsType.INSPIRE.toString();
            } catch (SQLException ex) {
                Logger.getLogger(HarvesterStatisticsDao.class.getName()).log(Level.SEVERE, null, ex);
            }
            elencostat.add(objStat);
        }
        if ((listType.equals("")) ||(elencoS.contains(StatisticsType.SERVIZIO.toString()))){
            /*Tipo Servizio*/
            objStat = new statistic();
            sbSelectSql = new StringBuilder();
            sbSelectSql.append("SELECT " + Ragg + " i.SERVICE_TYPE, count(*) FROM gpt_resource r inner join gpt_resource_stat_service_type i on i.DOCUUID = r.DOCUUID ");
            sbSelectSql.append("inner join gpt_user u on u.USERID = r.OWNER  inner join gpt_pa p on p.ID = u.FK_IDPA WHERE r.APPROVALSTATUS = 'approved' ");
            if ((!datiPA.isEmpty()) && (!datiPA.equals("*")) && (!datiPA.equals("s"))){
                //sbSelectSql.append("WHERE u.USERNAME like '%?%' ");
               sbSelectSql.append("AND u.FK_IDPA =  " + datiPA);
             
            }
            if ((!datiTipoPA.isEmpty()) && (!datiTipoPA.equals("*")) && (!datiTipoPA.equals("s"))){
                //sbSelectSql.append("WHERE u.USERNAME like '%?%' ");
               sbSelectSql.append("AND p.tipoPA =  '" + datiTipoPA + "'");
             
            }
            if (!owner.equals("*")){
                sbSelectSql.append(" AND u.USERID =  " + owner);
            }
            if (startDate.length() > 0) {
                sbSelectSql.append(" AND UPDATEDATE >= ? ");
            }
            if (endDate.length() > 0) {
                sbSelectSql.append(" AND UPDATEDATE <= ? ");
            }
            // Solo gli approvati
            sbSelectSql.append(" AND r.APPROVALSTATUS = 'approved' "); 
            
            sbSelectSql.append(" group by " + strGroupBy + ", i.SERVICE_TYPE ");
            try {
                objStat = fetchGroupStat(sbSelectSql.toString(),startDate,endDate);
                objStat.tipologia=StatisticsType.SERVIZIO.toString();
            } catch (SQLException ex) {
                Logger.getLogger(HarvesterStatisticsDao.class.getName()).log(Level.SEVERE, null, ex);
            }
            elencostat.add(objStat);
        }
        if ((listType.equals("")) ||(elencoS.contains(StatisticsType.RESPONSABILE.toString()))){
            /*Responsabile*/
            objStat = new statistic();
            sbSelectSql = new StringBuilder();
            sbSelectSql.append("SELECT " + Ragg + " s.RESPONSIBLE, count(*) FROM gpt_resource r inner join gpt_resource_stat s on s.DOCUUID = r.DOCUUID ");
            sbSelectSql.append("inner join gpt_user u on u.USERID = r.OWNER  inner join gpt_pa p on p.ID = u.FK_IDPA WHERE r.APPROVALSTATUS = 'approved' ");
            if ((!datiPA.isEmpty()) && (!datiPA.equals("*")) && (!datiPA.equals("s"))){
                //sbSelectSql.append("WHERE u.USERNAME like '%?%' ");
               sbSelectSql.append("AND u.FK_IDPA =  " + datiPA);
             
            }
            if ((!datiTipoPA.isEmpty()) && (!datiTipoPA.equals("*")) && (!datiTipoPA.equals("s"))){
                //sbSelectSql.append("WHERE u.USERNAME like '%?%' ");
               sbSelectSql.append("AND p.tipoPA =  '" + datiTipoPA + "'");
             
            }
            if (!owner.equals("*")){
                sbSelectSql.append(" AND u.USERID =  " + owner);
            }
            if (startDate.length() > 0) {
                sbSelectSql.append(" AND UPDATEDATE >= ? ");
            }
            if (endDate.length() > 0) {
                sbSelectSql.append(" AND UPDATEDATE <= ? ");
            }
            // Solo gli approvati
            sbSelectSql.append(" AND r.APPROVALSTATUS = 'approved' "); 
            
            sbSelectSql.append(" group by " + strGroupBy + ", s.RESPONSIBLE");
            try {
                objStat = fetchGroupStat(sbSelectSql.toString(),startDate,endDate);
                objStat.tipologia=StatisticsType.RESPONSABILE.toString();
            } catch (SQLException ex) {
                Logger.getLogger(HarvesterStatisticsDao.class.getName()).log(Level.SEVERE, null, ex);
            }
            elencostat.add(objStat);
        }
        StringBuilder stRet = new StringBuilder();
        stRet.append("\"elencoStat\": [");
        boolean isFirstS=true;
        for (statistic stat: elencostat){
            stat.raggruppamenti = stat.raggruppamenti.stream().distinct().collect(Collectors.toList());
            if (!isFirstS) stRet.append(",");
            isFirstS=false;            
            stRet.append("{\"tipoStat\":\"" + stat.tipologia + "\",");
            stRet.append("\"raggruppamenti\":\"" + String.join(", ", stat.raggruppamenti) + "\",");
            stRet.append("\"dettaglio\":[");
            boolean isFirst=true;
            for (dettaglio dett: stat.elenco){
                if (!isFirst) stRet.append(",");
                isFirst=false;
                stRet.append("{\"utente\":\"" + dett.utente + "\",");
                stRet.append("\"tipoEnte\":\"" + dett.tipoEnte + "\",");
                stRet.append("\"conteggio\":[");
                isFirst=true;
                for (conteggi cont: dett.arrConteggi){
                    if (!isFirst) stRet.append(",");
                    isFirst=false;
                    stRet.append("{\"raggruppamento\":\"" + cont.raggruppamento + "\",");
                    stRet.append("\"conteggio\":" + cont.conteggio + "}");
                }
                stRet.append("]}");
            }
            stRet.append("]}");
        }
        stRet.append("]");
        return stRet.toString();

    }
        /**
     * Creates Select SQL to fetch rows harvesting history table based on
     * constraints.
     *
     * @return Select SQL
     */
    protected String createSelectHistorySQL(String uuids, String startDate, String endDate, String harvestID) {
        StringBuilder sbSelectSql = new StringBuilder();
        sbSelectSql.append("select UUID,HARVEST_ID ,HARVEST_DATE,HARVESTED_COUNT,VALIDATED_COUNT,PUBLISHED_COUNT from ")
          .append(getHarvestingHistoryTableName()).append(" ");
        //sbSelectSql.append(addClause(uuids, startDate, endDate, "HARVEST_DATE"));
        sbSelectSql.append(addClauseH(uuids, startDate, endDate, "HARVEST_DATE",harvestID));
        return sbSelectSql.toString();
    }
protected String createSelectReportSQL(String fieldWhere){
    // intitalize
      // start the SQL expression
      StringBuilder sbSql   = new StringBuilder();
      sbSql.append("SELECT   h.HARVEST_REPORT, r.TITLE, r.SOURCEURI, r.PROTOCOL_TYPE, h.UUID, h.HARVEST_ID ");//A.HARVEST_REPORT");
      sbSql.append(" FROM ").append(getHarvestingHistoryTableName()).append(" h inner join gpt_resource r on r.DOCUUID = h.HARVEST_ID ");
      //sbSql.append(" WHERE UPPER(h.UUID)=?");
      sbSql.append(" WHERE UPPER(h." + fieldWhere + ")=?");

    return sbSql.toString();
  }

protected String fetchtReportSQL(String sqlSt, String uuids, Boolean xml){
    // intitalize
    PreparedStatement st = null;
    String jsonPrettyPrintString ="";
    try {


      // establish the connection
      ManagedConnection mc = returnConnection();
      Connection con = mc.getJdbcConnection();

      st = con.prepareStatement(sqlSt);
      st.setString(1,uuids.toUpperCase());

      // execute the query
      logExpression(sqlSt);
      ResultSet rs = st.executeQuery();

      if (rs.next()) {
        IClobMutator cm = mc.getClobMutator();
        InputStream in = null;
        try {
          in = cm.getStream(rs, 1);
        } finally {
          if (in!=null) {
            try {
                StringWriter writer = new StringWriter();
                IOUtils.copy(in, writer);
                String theString = writer.toString();
                JSONObject xmlJSONObj = new JSONObject();
                if (xml){
                    xmlJSONObj = XML.toJSONObject(theString);
                }
                xmlJSONObj.put("title", rs.getString(2));
                xmlJSONObj.put("sourceUri", rs.getString(3));
                xmlJSONObj.put("protocolType", rs.getString(4));
                if (xml) xmlJSONObj.put("uuidReport", rs.getString(5));
                xmlJSONObj.put("uuidCatalogo", rs.getString(6));
                jsonPrettyPrintString = xmlJSONObj.toString(4);
                in.close();
                jsonPrettyPrintString=jsonPrettyPrintString.substring(1,jsonPrettyPrintString.length()-1);
            } catch (IOException ex) {}
          }
        }
      }
      rs.close();
    }catch(Exception ex){
    } finally {
      closeStatement(st);
    }
    return jsonPrettyPrintString;
  }

    /**
     * Creates Select SQL to count jobs grouped by 'Running' or 'submitted'
     * statuses.
     *
     * @return Select SQL
     */
    protected String createCountPendingSQLByStatus() {
        StringBuilder sbSelectSql = new StringBuilder();
        sbSelectSql.append("select count(*) as cnt, job_status from ")
          .append(getHarvestingJobTableName());
        if (isDbCaseSensitive) {
            sbSelectSql.append(" where UPPER(job_status) in ('RUNNING','SUBMITED') ");
        } else {
            sbSelectSql.append(" where job_status in ('Running','submited') ");
        }
        sbSelectSql.append(" group by job_status order by job_status desc");
        return sbSelectSql.toString();
    }

    /**
     * Creates Select SQL to count jobs with 'Running' or 'submitted' statuses.
     *
     * @return Select SQL
     */
    protected String createCountPendingSQL(int timePeriod) {
        StringBuilder sbSelectSql = new StringBuilder();
        sbSelectSql.append("select count(*) as cnt from ")
          .append(getHarvestingJobTableName());
        if (isDbCaseSensitive) {
            sbSelectSql.append(" where UPPER(job_status) in ('RUNNING','SUBMITED') ");
        } else {
            sbSelectSql.append(" where job_status in ('Running','submited') ");
        }
        if (timePeriod != -1) {
            sbSelectSql.append(" and INPUT_DATE >= ? ");
        }
        return sbSelectSql.toString();
    }

    /**
     * Creates Select SQL to count completed jobs.
     *
     * @return Select SQL
     */
    protected String createCountCompletedSQL(int timePeriod) {
        StringBuilder sbSelectSql = new StringBuilder();
        sbSelectSql.append("select count(*) as cnt from ")
          .append(getHarvestingJobsCompletedTableName());
        if (timePeriod != -1) {
            sbSelectSql.append(" where harvest_date >= ? ");
        }
        return sbSelectSql.toString();
    }

    /**
     * Creates Select SQL to select pending jobs based on criteria.
     *
     * @return Select SQL
     */
    protected String createSelectPendingSQL(String uuids, String startDate, String endDate) {
        StringBuilder sbSelectSql = new StringBuilder();
        sbSelectSql.append("select UUID,HARVEST_ID ,HARVEST_DATE, INPUT_DATE,JOB_TYPE,JOB_STATUS,CRITERIA,SERVICE_ID from ")
          .append(getHarvestingJobTableName()).append(" ");
        sbSelectSql.append(addClause(uuids, startDate, endDate, "INPUT_DATE"));
        return sbSelectSql.toString();
    }

    /**
     * Creates Select SQL to select complete jobs based on criteria.
     *
     * @return Select SQL
     */
    protected String createSelectCompletedSQL(String uuids, String startDate, String endDate) {
        StringBuilder sbSelectSql = new StringBuilder();
        sbSelectSql.append("select UUID,HARVEST_ID ,HARVEST_DATE, INPUT_DATE,JOB_TYPE,SERVICE_ID from ")
          .append(getHarvestingJobsCompletedTableName()).append(" ");
        sbSelectSql.append(addClause(uuids, startDate, endDate, "INPUT_DATE"));
        return sbSelectSql.toString();
    }

    /**
     * Create sql to fetch count of registered sites
     *
     * @return the sql string
     */
    protected String createCountOfRegisteredSites() {
        StringBuilder sbSelectSql = new StringBuilder();
        sbSelectSql.append("SELECT count(*) as cnt FROM ").append(getResourceTableName());
        if (isDbCaseSensitive) {
            sbSelectSql.append(" where UPPER(pubmethod)='REGISTRATION' ");
        } else {
            sbSelectSql.append(" where pubmethod='registration' ");
        }
        return sbSelectSql.toString();
    }

    /**
     * Create sql to fetch count of approved sites
     *
     * @return the sql string
     */
    protected String createCountOfApprovedSites() {
        StringBuilder sbSelectSql = new StringBuilder();
        sbSelectSql.append("SELECT count(*) as cnt FROM ").append(getResourceTableName());
        if (isDbCaseSensitive) {
            sbSelectSql.append(" where UPPER(pubmethod)='REGISTRATION' and UPPER(approvalstatus)='APPROVED'");
        } else {
            sbSelectSql.append(" where pubmethod='registration' and approvalstatus='approved'");
        }
        return sbSelectSql.toString();
    }

    /**
     * Create sql to fetch count of approved sites that are on a schedule
     *
     * @return the sql string
     */
    protected String createCountOfApprovedSitesOnSchedule() {
        StringBuilder sbSelectSql = new StringBuilder();
        sbSelectSql.append("SELECT count(*) as cnt FROM ").append(getResourceTableName());
        if (isDbCaseSensitive) {
            sbSelectSql.append(" where UPPER(pubmethod)='REGISTRATION' and UPPER(approvalstatus)='APPROVED' and UPPER(synchronizable) = 'TRUE'");
        } else {
            sbSelectSql.append(" where pubmethod='registration' and approvalstatus='approved' and synchronizable = 'true'");
        }
        return sbSelectSql.toString();
    }

    /**
     * Create sql to fetch count of approved sites by protocol
     *
     * @return the sql string
     */
    protected String createCountOfApprovedSitesByProtocol() {
        StringBuilder sbSelectSql = new StringBuilder();
        sbSelectSql.append("SELECT count(*) as cnt,protocol_type FROM ").append(getResourceTableName());
        if (isDbCaseSensitive) {
            sbSelectSql.append(" where UPPER(pubmethod)='REGISTRATION' and UPPER(approvalstatus)='APPROVED' ");
        } else {
            sbSelectSql.append(" where pubmethod='registration' and approvalstatus='approved' ");
        }
        sbSelectSql.append(" group by protocol_type");
        return sbSelectSql.toString();
    }

    /**
     * Create sql to fetch count of registered sites by protocol
     *
     * @return the sql string
     */
    protected String createCountOfRegisteredSitesByProtocol() {
        StringBuilder sbSelectSql = new StringBuilder();
        sbSelectSql.append("SELECT count(*) as cnt,protocol_type FROM ").append(getResourceTableName());
        if (isDbCaseSensitive) {
            sbSelectSql.append(" where UPPER(pubmethod)='REGISTRATION' ");
        } else {
            sbSelectSql.append(" where pubmethod='registration' ");
        }
        sbSelectSql.append(" group by protocol_type");
        return sbSelectSql.toString();
    }

    /**
     * Create sql to select distinct of registered sites on schedule by protocol
     *
     * @return the sql string
     */
    private String selectDistinctHarvestSitesOnScheduleOrderByProtocol() {
        StringBuilder sbSelectSql = new StringBuilder();
        sbSelectSql.append("SELECT distinct docuuid,protocol_type from ").append(getResourceTableName());
        if (isDbCaseSensitive) {
            sbSelectSql.append(" where UPPER(pubmethod)='REGISTRATION' and UPPER(approvalstatus)='APPROVED' and UPPER(synchronizable) = 'TRUE'");
        } else {
            sbSelectSql.append(" where pubmethod='registration' and approvalstatus='approved' and synchronizable = 'true'");
        }
        sbSelectSql.append(" order by protocol_type");
        return sbSelectSql.toString();
    }

    /**
     * Create sql to fetch count of approved sites on a schedule by protocol
     *
     * @return the sql string
     */
    protected String createCountOfApprovedSitesOnScheduleByProtocol() {
        StringBuilder sbSelectSql = new StringBuilder();
        sbSelectSql.append("SELECT count(*) as cnt,protocol_type FROM ").append(getResourceTableName());
        if (isDbCaseSensitive) {
            sbSelectSql.append(" where UPPER(pubmethod)='REGISTRATION' and UPPER(approvalstatus)='APPROVED' and UPPER(synchronizable) = 'TRUE'");
        } else {
            sbSelectSql.append(" where pubmethod='registration' and approvalstatus='approved' and synchronizable = 'true'");
        }
        sbSelectSql.append(" group by protocol_type");
        return sbSelectSql.toString();
    }

    /**
     * Create sql to fetch published document count for a site.
     *
     * @return the sql string
     */
    protected String createDocumentCount() {
        StringBuilder sbSelectSql = new StringBuilder();
        sbSelectSql.append("SELECT sum(published_count) as pc FROM ").append(getHarvestingHistoryTableName())
          .append(" where harvest_id = ? ");
        return sbSelectSql.toString();
    }

    /**
     * Collect docuuid of sites on a schedule by protocol type
     *
     * @param protocolMap map of docuuid of sites on schedule and their
     * corresponding protocol type
     * @return docuuid map
     * @throws SQLException if sql exception occurs
     */
    protected HashMap<String, String> collectSitesByProtocolType(HashMap<String, Object> protocolMap) throws SQLException {
        ManagedConnection mc = returnConnection();
        Connection con = mc.getJdbcConnection();
        ResultSet rs = null;
        PreparedStatement st = null;
        HashMap<String, String> docuuidMap = new HashMap<String, String>();
        try {
            st = con.prepareStatement(selectDistinctHarvestSitesOnScheduleOrderByProtocol());
            rs = st.executeQuery();
            while (rs.next()) {
                String docuuid = Val.chkStr(rs.getString("docuuid"));
                String protocolType = Val.chkStr(rs.getString("protocol_type"));
                docuuidMap.put(docuuid, protocolType);
            }
            return docuuidMap;
        } finally {
            BaseDao.closeResultSet(rs);
            BaseDao.closeStatement(st);
            getRequestContext().getConnectionBroker().closeConnection(mc);
        }
    }

    /**
     * Fetch count of records using given sql and timeperiod
     *
     * @param sql the sql query to execute
     * @param timePeriod the number of days from current date
     * @return count value
     * @throws SQLException if sql exception occurs
     */
    protected int fetchCountByTime(String sql, int timePeriod) throws SQLException {
        int count = 0;
        ManagedConnection mc = returnConnection();
        Connection con = mc.getJdbcConnection();
        ResultSet rs = null;
        PreparedStatement st = null;
        try {
            st = con.prepareStatement(sql);
            if (timePeriod != -1) {
                st.setTimestamp(1, DateProxy.subtractDays(timePeriod));
            }
            rs = st.executeQuery();
            while (rs.next()) {
                count = rs.getInt("cnt");
            }
            return count;
        } finally {
            BaseDao.closeResultSet(rs);
            BaseDao.closeStatement(st);
            getRequestContext().getConnectionBroker().closeConnection(mc);
        }
    }

    /**
     * Fetches information from harvesting complete table
     *
     * @param sql the sql query to execute
     * @param uuids the uuids constraint
     * @param startDate the start date constraint
     * @param endDate the end date constraint
     * @throws Exception if exception occurs
     */
    protected void fetchCompleted(String sql, String uuids, String startDate, String endDate) throws Exception {
        // establish the connection
        ManagedConnection mc = returnConnection();
        Connection con = mc.getJdbcConnection();
        ResultSet rs = null;
        PreparedStatement st = null;
        try {
            // initialize
            st = con.prepareStatement(sql);
            int parameterIdx = 1;
            String[] uuidArr = null;
            if (uuids.length() > 0 && uuids.indexOf(",") > -1) {
                uuidArr = uuids.split(",");
                if (uuidArr.length <= 10) {
                    for (int i = 0; i < uuidArr.length; i++) {
                        String uuid = UuidUtil.addCurlies(uuidArr[i]);
                        if (!isUuid(uuid)) {
                            throw new IllegalArgumentException("Illegal SQL parameter");
                        }
                        st.setString(parameterIdx, uuid);
                        parameterIdx++;
                    }
                }
            } else if (uuids.length() > 0) {
                String uuid = UuidUtil.addCurlies(uuids);
                if (!isUuid(uuid)) {
                    throw new IllegalArgumentException("Illegal SQL parameter");
                }
                st.setString(parameterIdx, uuid);
                parameterIdx++;
            }

            if (startDate.length() > 0) {
                st.setDate(parameterIdx, Date.valueOf(startDate));
                parameterIdx++;
            }
            if (endDate.length() > 0) {
                st.setDate(parameterIdx, Date.valueOf(endDate));
                parameterIdx++;
            }
            String[] columnTags = {
                "UUID", "HARVEST_ID", "HARVEST_DATE", "INPUT_DATE", "JOB_TYPE", "SERVICE_ID"
            };
            rs = st.executeQuery();
            statWriter.writeResultSet(getHarvestingJobsCompletedTableName(), rs, columnTags);

        } finally {
            BaseDao.closeResultSet(rs);
            BaseDao.closeStatement(st);
            getRequestContext().getConnectionBroker().closeConnection(mc);

        }
    }

    /**
     * Fetches published document count grouped by protocol type
     *
     * @param protocolMap the protocol type object map
     * @param docuuidMap the docuuid map of sites on schedule
     * @throws SQLException if sql exception occurs
     */
    protected void fetchDocumentCountByProtocol(HashMap<String, Object> protocolMap, HashMap<String, String> docuuidMap) throws SQLException {
        ManagedConnection mc = returnConnection();
        Connection con = mc.getJdbcConnection();
        ResultSet rs = null;
        PreparedStatement st = null;
        try {
            ArrayList<String> sortedKeys = new ArrayList<String>(docuuidMap.keySet());
            Collections.sort(sortedKeys);
            for (int i = 0; i < sortedKeys.size(); i++) {
                String docuuid = sortedKeys.get(i);
                String protocolType = docuuidMap.get(docuuid);
                st = con.prepareStatement(createDocumentCount());
                st.setString(1, docuuid);
                rs = st.executeQuery();
                while (rs.next()) {
                    int count = Val.chkInt(rs.getString("pc"), 0);
                    ProtocolInfo pi = (ProtocolInfo) protocolMap.get(protocolType);
                    pi.setDocumentCount(pi.getDocumentCount() + count);
                }
                BaseDao.closeResultSet(rs);
                BaseDao.closeStatement(st);
            }
        } finally {
            BaseDao.closeResultSet(rs);
            BaseDao.closeStatement(st);
            getRequestContext().getConnectionBroker().closeConnection(mc);
        }
    }

    /**
     * Fetches harvesting history information
     *
     * @param sql the sql query to execute
     * @param uuids the uuids constraint
     * @param startDate the start date constraint
     * @param endDate the end date constraint
     * @throws Exception if exception occurs
     */
    protected void fetchHistory(String sql, String uuids, String startDate, String endDate) throws Exception {

        // establish the connection
        ManagedConnection mc = returnConnection();
        Connection con = mc.getJdbcConnection();
        ResultSet rs = null;
        PreparedStatement st = null;
        try {
            // initialize
            st = con.prepareStatement(sql);
            int parameterIdx = 1;
            String[] uuidArr = null;
            if (uuids.length() > 0 && uuids.indexOf(",") > -1) {
                uuidArr = uuids.split(",");
                if (uuidArr.length <= 10) {
                    for (int i = 0; i < uuidArr.length; i++) {
                        String uuid = UuidUtil.addCurlies(uuidArr[i]);
                        if (!isUuid(uuid)) {
                            throw new IllegalArgumentException("Illegal SQL parameter");
                        }
                        st.setString(parameterIdx, uuid);
                        parameterIdx++;
                    }
                }
            } else if (uuids.length() > 0) {
                String uuid = UuidUtil.addCurlies(uuids);
                if (!isUuid(uuid)) {
                    throw new IllegalArgumentException("Illegal SQL parameter");
                }
                st.setString(parameterIdx, uuid);
                parameterIdx++;
            }

            if (startDate.length() > 0) {
                st.setDate(parameterIdx, Date.valueOf(startDate));
                parameterIdx++;
            }
            if (endDate.length() > 0) {
                st.setDate(parameterIdx, Date.valueOf(endDate));
                parameterIdx++;
            }

            String[] columnTags = {
                "UUID",
                "HARVEST_ID",
                "HARVEST_DATE",
                "HARVESTED_COUNT",
                "VALIDATED_COUNT",
                "PUBLISHED_COUNT",};
            rs = st.executeQuery();
            statWriter.writeResultSet(getHarvestingHistoryTableName(), rs, columnTags);

        } finally {
            BaseDao.closeResultSet(rs);
            BaseDao.closeStatement(st);
            getRequestContext().getConnectionBroker().closeConnection(mc);

        }
    }

    /**
     * Fetches information from pending table.
     *
     * @param sql the sql query to execute
     * @param uuids the uuids constraint
     * @param startDate the start date constraint
     * @param endDate the end date constraint
     * @throws Exception if exception occurs
     */
    protected void fetchPending(String sql, String uuids, String startDate, String endDate) throws Exception {
        // establish the connection
        ManagedConnection mc = returnConnection();
        Connection con = mc.getJdbcConnection();
        ResultSet rs = null;
        PreparedStatement st = null;
        try {
            // initialize
            st = con.prepareStatement(sql);
            String[] columnTags = {
                "UUID", "HARVEST_ID", "HARVEST_DATE", "INPUT_DATE", "JOB_TYPE", "JOB_STATUS", "CRITERIA", "SERVICE_ID"
            };

            int parameterIdx = 1;
            String[] uuidArr = null;
            if (uuids.length() > 0 && uuids.indexOf(",") > -1) {
                uuidArr = uuids.split(",");
                if (uuidArr.length <= 10) {
                    for (int i = 0; i < uuidArr.length; i++) {
                        String uuid = UuidUtil.addCurlies(uuidArr[i]);
                        if (!isUuid(uuid)) {
                            throw new IllegalArgumentException("Illegal SQL parameter");
                        }
                        st.setString(parameterIdx, uuid);
                        parameterIdx++;
                    }
                }
            } else if (uuids.length() > 0) {
                String uuid = UuidUtil.addCurlies(uuids);
                if (!isUuid(uuid)) {
                    throw new IllegalArgumentException("Illegal SQL parameter");
                }
                st.setString(parameterIdx, uuid);
                parameterIdx++;
            }

            if (startDate.length() > 0) {
                st.setDate(parameterIdx, Date.valueOf(startDate));
                parameterIdx++;
            }
            if (endDate.length() > 0) {
                st.setDate(parameterIdx, Date.valueOf(endDate));
                parameterIdx++;
            }

            rs = st.executeQuery();
            statWriter.writeResultSet(getHarvestingJobTableName(), rs, columnTags);

        } finally {
            BaseDao.closeResultSet(rs);
            BaseDao.closeStatement(st);
            getRequestContext().getConnectionBroker().closeConnection(mc);

        }
    }

    /**
     * This method is used to fetch harvest counts for given number of days from
     * current date
     *
     * @param timePeriod the number days to aggregate for
     * @return the counts array (harvestedCount,publishedCount,validatedCount)
     * @throws Exception if exception occurs
     */
    protected int[] fetchHarvestCounts(int timePeriod) throws Exception {
        int harvestedCount = 0;
        int publishedCount = 0;
        int validatedCount = 0;
        ManagedConnection mc = returnConnection();
        Connection con = mc.getJdbcConnection();
        ResultSet rs = null;
        PreparedStatement st = null;
        int[] counts = new int[3];
        try {
            st = con.prepareStatement(createHistoryCountsSQL(timePeriod));
            if (timePeriod != -1) {
                st.setTimestamp(1, DateProxy.subtractDays(timePeriod));
            }
            rs = st.executeQuery();
            while (rs.next()) {
                harvestedCount = rs.getInt("hc");
                publishedCount = rs.getInt("pc");
                validatedCount = rs.getInt("vc");
            }

            counts[0] = harvestedCount;
            counts[1] = publishedCount;
            counts[2] = validatedCount;

        } finally {
            BaseDao.closeResultSet(rs);
            BaseDao.closeStatement(st);
            getRequestContext().getConnectionBroker().closeConnection(mc);
        }

        return counts;
    }

    /**
     * Fetches Summary information for web harvester
     *
     * @return the active and submitted count for web harvest jobs from pending
     * table
     * @throws Exception if exception occurs
     */
    protected int[] fetchSummary() throws Exception {
        ManagedConnection mc = returnConnection();
        Connection con = mc.getJdbcConnection();
        ResultSet rs = null;
        PreparedStatement st = null;
        int activeCnt = 0;
        int submittedCnt = 0;
        int[] counts = new int[2];
        counts[0] = activeCnt;
        counts[1] = submittedCnt;
        try {
            // initialize
            st = con.prepareStatement(createCountPendingSQLByStatus());
            rs = st.executeQuery();
            while (rs.next()) {
                String status = Val.chkStr(rs.getString("job_status"));

                if (status.equalsIgnoreCase("submited")) {
                    submittedCnt = rs.getInt("cnt");
                } else if (status.equalsIgnoreCase("Running")) {
                    activeCnt = rs.getInt("cnt");
                }
            }

        } finally {
            BaseDao.closeResultSet(rs);
            BaseDao.closeStatement(st);
            getRequestContext().getConnectionBroker().closeConnection(mc);
        }

        return counts;
    }

    /**
     * Fetches repository summary information by protocol
     *
     * @return map of protocol info objects
     * @throws Exception if exception occurs
     */
    protected HashMap<String, Object> fetchRepositoriesSummaryByProtocol() throws Exception {
        HashMap<String, Object> protocolMap = new HashMap<String, Object>();
        ManagedConnection mc = returnConnection();
        Connection con = mc.getJdbcConnection();
        ResultSet rs = null;
        PreparedStatement st = null;
        try {
            st = con.prepareStatement(selectDistinctProtocols());
            rs = st.executeQuery();
            while (rs.next()) {
                String protocolType = rs.getString("protocol_type");
                protocolMap.put(protocolType, new ProtocolInfo());
            }
        } finally {
            BaseDao.closeResultSet(rs);
            BaseDao.closeStatement(st);
            getRequestContext().getConnectionBroker().closeConnection(mc);
        }
        return protocolMap;
    }

    /**
     * Gets the harvesting table name.
     *
     * @return the harvesting table name
     */
    protected String getHarvestingTableName() {
        return getRequestContext().getCatalogConfiguration().getResourceTableName();
    }

    /**
     * Gets the harvesting table name.
     *
     * @return the harvesting table name
     */
    protected String getHarvestingDataTableName() {
        return getRequestContext().getCatalogConfiguration().getResourceDataTableName();
    }

    /**
     * Gets harvesting history table name.
     *
     * @return the harvesting history table name
     */
    protected String getHarvestingHistoryTableName() {
        return getRequestContext().getCatalogConfiguration().
          getHarvestingHistoryTableName();
    }

    /**
     * Gets harvesting job table name.
     *
     * @return the harvesting job table name
     */
    protected String getHarvestingJobTableName() {
        return getRequestContext().getCatalogConfiguration().
          getHarvestingJobsPendingTableName();
    }

    /**
     * Gets completed harvesting jobs table name.
     *
     * @return completed harvesting jobs table name
     */
    protected String getHarvestingJobsCompletedTableName() {
        return getRequestContext().getCatalogConfiguration().
          getHarvestingJobsCompletedTableName();
    }

    /**
     * Gets completed harvesting jobs table name.
     *
     * @return completed harvesting jobs table name
     */
    protected String getResourceTableName() {
        return getRequestContext().getCatalogConfiguration().
          getResourceTableName();
    }

    /**
     * Populates protocol info objects map using sql.
     *
     * @param protocolMap the protocol map object
     * @param sql the sql string
     * @param propertyName the property name of protocol info object to populate
     * count using sql
     * @throws SQLException if sql exception occurs
     */
    protected void populateProtocolInfo(HashMap<String, Object> protocolMap, String sql, String propertyName) throws SQLException {
        ManagedConnection mc = returnConnection();
        Connection con = mc.getJdbcConnection();
        ResultSet rs = null;
        PreparedStatement st = null;
        try {
            st = con.prepareStatement(sql);
            rs = st.executeQuery();
            while (rs.next()) {
                int count = rs.getInt("cnt");
                String protocolType = Val.chkStr(rs.getString("protocol_type"));
                ProtocolInfo pi = (ProtocolInfo) protocolMap.get(protocolType);
                if (propertyName.equalsIgnoreCase("Approved")) {
                    pi.setApprovedCount(count);
                } else if (propertyName.equalsIgnoreCase("OnSchedule")) {
                    pi.setOnScheduleCount(count);
                } else if (propertyName.equalsIgnoreCase("Registered")) {
                    pi.setRegisteredCount(count);
                }
            }
        } finally {
            BaseDao.closeResultSet(rs);
            BaseDao.closeStatement(st);
            getRequestContext().getConnectionBroker().closeConnection(mc);
        }
    }

    /**
     * Create sql to select distinct registered site protocols
     *
     * @return the sql string
     */
    protected String selectDistinctProtocols() {
        StringBuilder sbSelectSql = new StringBuilder();
        sbSelectSql.append(" select distinct protocol_type from ").append(getResourceTableName()).append(" where protocol_type is not null");
        return sbSelectSql.toString();
    }
}
