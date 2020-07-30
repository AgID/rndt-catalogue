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
package com.esri.gpt.catalog.publication;
import com.esri.gpt.catalog.arcims.DeleteMetadataRequest;
import com.esri.gpt.catalog.arcims.ImsMetadataAdminDao;
import com.esri.gpt.catalog.arcims.ImsServiceException;
import com.esri.gpt.catalog.context.CatalogIndexException;
import com.esri.gpt.framework.collection.StringAttributeMap;
import com.esri.gpt.framework.context.RequestContext;
import com.esri.gpt.framework.security.principal.Publisher;
import com.esri.gpt.framework.sql.BaseDao;
import com.esri.gpt.framework.util.Val;
import java.io.IOException;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Logger;

/**
 * Database access object associated with the metadata catalog.
 */
class CatalogDao extends BaseDao {
  
  /** class variables ========================================================= */
  
  /** Logger */
  private static Logger LOGGER = Logger.getLogger(CatalogDao.class.getName());
  
  /** constructors  =========================================================== */
  
  /**
   * Constructs with an associated request context.
   * @param requestContext the request context
   */
  public CatalogDao(RequestContext requestContext) {
    super(requestContext);
  }
    /**
   * Constructs with an associated request context.
   * @param requestContext the request context
   */
  public CatalogDao() {
      super();
  }
  
  /** properties  ============================================================= */
  
  /**
   * Gets the primary catalog table name.
   * @return the primary catalog table name
   */
  private String getResourceTableName() {
    return getRequestContext().getCatalogConfiguration().getResourceTableName();
  }
  
  /** methods ================================================================= */
  
  /**
   * Deletes catalog documents that are no longer referenced by a parent resource.
   * @param context the processing context
   * @param sourceURIs the collection of source URIs to delete (key is SOURCEURI value is DOCUUID)
   * @throws SQLException if an exception occurs while communicating with the database
   * @throws ImsServiceException if an exception occurs during delete
   * @throws CatalogIndexException if an exception occurs during delete
   * @throws IOException if accessing index fails
   */
  protected void deleteSourceURIs(final ProcessingContext context, Map<String,String> sourceURIs)
    throws SQLException, ImsServiceException, CatalogIndexException, IOException {
    this.deleteSourceURIs(context.getPublisher(), sourceURIs.entrySet(), new CatalogRecordListener() {
      @Override
      public void onRecord(String sourceUri, String uuid) {
        context.incrementNumberDeleted();
        ProcessedRecord record = new ProcessedRecord();
        record.setSourceUri(sourceUri);
        record.setStatusType(ProcessedRecord.StatusType.DELETED);
        context.getProcessedRecords().add(record);
      }
    });
  }

  /**
   * Deletes catalog documents that are no longer referenced by a parent resource.
   * @param publisher publisher
   * @param sourceURIs the collection of source URIs to delete (key is SOURCEURI value is DOCUUID)
   * @param listener listener called upon deleting a single document
   * @throws SQLException if an exception occurs while communicating with the database
   * @throws ImsServiceException if an exception occurs during delete
   * @throws CatalogIndexException if an exception occurs during delete
   * @throws IOException if accessing index fails
   */
  protected void deleteSourceURIs(Publisher publisher, Iterable<Map.Entry<String,String>> sourceURIs, CatalogRecordListener listener)
      throws ImsServiceException, SQLException, CatalogIndexException, IOException {
    ImsMetadataAdminDao adminDao = new ImsMetadataAdminDao(getRequestContext());
    DeleteMetadataRequest delRequest = new DeleteMetadataRequest(
        this.getRequestContext(),publisher);
    for (Map.Entry<String,String> entry: sourceURIs) {
      if (Thread.currentThread().isInterrupted()) break;
      String uri = entry.getKey();
      String uuid = entry.getValue();
      LOGGER.finest("Deleting uuid="+uuid+", sourceuri="+uri);
      boolean bOk = delRequest.executeDelete(uuid);
      if (bOk) {
        listener.onRecord(uri, uuid);
      }
    }
  }

  /**
   * Queries document source URIs associated with a parent resource (SQL LIKE).
   * @param pattern the source URI pattern of the parent resource
   * @param pattern2 optional secondary source URI pattern of the parent resource
   * @return the collection of associated source URIs (key is SOURCEURI value is DOCUUID)
   * @throws SQLException if an exception occurs while communicating with the database
   */
  protected Map<String,String> querySourceURIs(String pattern, String pattern2) 
    throws SQLException {
    PreparedStatement st = null;
    Map<String,String> uris = new HashMap<String,String>();
    try {
      String table = this.getResourceTableName();
      String sql = "SELECT SOURCEURI,DOCUUID FROM "+table+" WHERE SOURCEURI LIKE ?";
      if ((pattern2 != null) && (pattern2.length() > 0)) {
        sql += " OR SOURCEURI LIKE ?";
      }
      this.logExpression(sql);
      Connection con = this.returnConnection().getJdbcConnection();
      st = con.prepareStatement(sql);
      st.setString(1,pattern+"%");
      if ((pattern2 != null) && (pattern2.length() > 0)) {
        st.setString(2,pattern2+"%");
      }
      ResultSet rs = st.executeQuery();
      int numFound = 0;
      while (rs.next()) {
        if (Thread.currentThread().isInterrupted()) return null;
        numFound++;
        String uri = rs.getString(1);
        String uuid = rs.getString(2);
        uris.put(uri,uuid);
      }
    } finally {
      CatalogDao.closeStatement(st);
    }
    return uris;
  }


  /**
   * Queries document source URIs associated with the harvesting site.
   * @param siteUuid site UUID
   * @param listener source URI listener
   * @throws SQLException if an exception occurs while communicating with the database
   * @throws IOException if accessing index fails
   */
  protected void querySourceURIs(String siteUuid, CatalogRecordListener listener)
    throws SQLException, IOException {
    PreparedStatement st = null;
    try {
      String table = this.getResourceTableName();
      String sql = "SELECT SOURCEURI,DOCUUID FROM "+table+" WHERE SITEUUID = ?";
      this.logExpression(sql);
      Connection con = this.returnConnection().getJdbcConnection();
      st = con.prepareStatement(sql);
      st.setString(1,siteUuid);
      ResultSet rs = st.executeQuery();
      int numFound = 0;
      while (rs.next()) {
        if (Thread.currentThread().isInterrupted()) return;
        numFound++;
        String uri = rs.getString(1);
        String uuid = rs.getString(2);
        listener.onRecord(uri, uuid);
      }
    } finally {
      CatalogDao.closeStatement(st);
    }
  }

  protected static interface CatalogRecordListener {
    void onRecord(String sourceUri, String uuid) throws IOException;
  }
  /**
   * Determine if collections are in use.
   * @return <code>true</code> if collections are in use
   */
  public boolean getUseCollections() {
    RequestContext context = this.getRequestContext();
    StringAttributeMap params = context.getCatalogConfiguration().getParameters();
    String s = Val.chkStr(params.getValue("catalog.useCollections"));
    return s.equalsIgnoreCase("true");
  }
  /**
   * Queries all the collection.
    * @throws SQLException if an exception occurs while communicating with the database
   * @throws IOException if accessing index fails
   */
  public ArrayList<collData> getAllCollection()
    throws SQLException, IOException {
      ArrayList<collData> lstColl = new ArrayList<collData>();
    PreparedStatement st = null;
    try {
      String sql = "SELECT COLUUID, SHORTNAME from gpt_collection";
      this.logExpression(sql);
      Connection con = this.returnConnection().getJdbcConnection();
      st = con.prepareStatement(sql);
      ResultSet rs = st.executeQuery();
      while (rs.next()) {
        collData oo= new collData();
        oo.ID=rs.getString(1);
        oo.Tilte=rs.getString(2);
        lstColl.add(oo);
      }
    } finally {
      CatalogDao.closeStatement(st);
    }
    return lstColl;
  }
 /**
   * Collection object returned from query for all the collection.
    * @throws SQLException if an exception occurs while communicating with the database
   * @throws IOException if accessing index fails
   */
  
public static class collData{
    String ID="";
    String Tilte="";

}
 /**
   * Queries all the resource data joined with the collection.
   * @params ID: collection ID Queries
    * @throws SQLException if an exception occurs while communicating with the database
   * @throws IOException if accessing index fails
   */
public ArrayList<collData> getAllCollectionData(String ID)
    throws SQLException, IOException {
      ArrayList<collData> lstColl = new ArrayList<collData>();
    PreparedStatement st = null;
    try {
      String sql = "SELECT  r.DOCUUID,r.TITLE FROM gpt_collection c " +
"inner join gpt_collection_member m on m.COLUUID = c.COLUUID " +
"inner join gpt_resource r on r.DOCUUID = m.DOCUUID";
      if (ID instanceof String){
           if (! ID.equals("")) sql +=" WHERE c.COLUUID = '" + ID + "'";
      }
     

      Connection con = this.returnConnection().getJdbcConnection();
      st = con.prepareStatement(sql);
      ResultSet rs = st.executeQuery();
      while (rs.next()) {
        collData oo= new collData();
        oo.ID=rs.getString(1);
        oo.Tilte=rs.getString(2);
        lstColl.add(oo);
      }
    } finally {
      CatalogDao.closeStatement(st);
    }
    return lstColl;
  }
 /**
   * Insert on collection 
   * @params c= collData Type 
    * @throws SQLException if an exception occurs while communicating with the database
   * @throws IOException if accessing index fails
   */
    public String insertCollection(collData c)throws SQLException, IOException {
        String ret="0";
        //Check if id ai already inserted
        PreparedStatement st = null;
        boolean continua=true;
        String sql = "SELECT count(*) FROM gpt_collection c  WHERE c.COLUUID = '" + c.ID + "'";
        this.logExpression(sql);
        Connection con = this.returnConnection().getJdbcConnection();
        st = con.prepareStatement(sql);
        ResultSet rs = st.executeQuery();
        while (rs.next()) {
            if (rs.getInt(1)>0){ 
                ret="1";
                continua=false;
            }
        }
        if (continua){
          //Can Insert
            PreparedStatement st2 = null;
            try {
                String sql2 = "INSERT INTO gpt_collection (COLUUID,SHORTNAME) VALUES (?,?)";

                st2 = con.prepareStatement(sql2);
                st2.setString(1,c.ID);
                st2.setString(2,c.Tilte);
                st2.addBatch();
                st2.executeBatch();
            } finally {
                CatalogDao.closeStatement(st);
            }
        }
        return ret;
    }
     /**
   * Delete one collection 
   * @params c= collData Type 
    * @throws SQLException if an exception occurs while communicating with the database
   * @throws IOException if accessing index fails
   */
    public void deleteCollection(collData c)throws SQLException, IOException {

        PreparedStatement st2 = null;
        Connection con = this.returnConnection().getJdbcConnection();
        try {
           /* String sql2 = "DELETE FROM  gpt_collection_member where COLUUID ='" + c.ID + "'";
            st2 = con.prepareStatement(sql2);
            st2.addBatch();
            st2.executeBatch();
*/
            String sql2 = "DELETE FROM gpt_collection WHERE COLUUID ='" + c.ID + "'";
            st2 = con.prepareStatement(sql2);
            st2.addBatch();
            st2.executeBatch();
        } finally {
              CatalogDao.closeStatement(st2);
        }
    }
    
     /**
   * Update one collection 
   * @params c= collData Type 
    * @throws SQLException if an exception occurs while communicating with the database
   * @throws IOException if accessing index fails
   */
    public String updateCollection(collData c)throws SQLException, IOException {
        PreparedStatement st2 = null;
        Connection con = this.returnConnection().getJdbcConnection();
        String sql2 = "";
        try {
            sql2 = "UPDATE gpt_collection set SHORTNAME = '" + c.Tilte + "' WHERE COLUUID ='" + c.ID + "'";
            st2 = con.prepareStatement(sql2);
            st2.addBatch();
            st2.executeBatch();
        } finally {
              CatalogDao.closeStatement(st2);
        }
        return sql2;
    }
 /**
   * Insert on collection 
   * @params c= collData Type 
    * @throws SQLException if an exception occurs while communicating with the database
   * @throws IOException if accessing index fails
   */
}
