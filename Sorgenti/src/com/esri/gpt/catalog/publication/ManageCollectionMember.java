package com.esri.gpt.catalog.publication;

import com.esri.gpt.catalog.arcims.ImsServiceException;
import com.esri.gpt.catalog.context.CatalogIndexException;
import com.esri.gpt.catalog.management.CollectionDao;
import com.esri.gpt.framework.collection.StringSet;
import com.esri.gpt.framework.context.RequestContext;
import com.esri.gpt.framework.jsf.BaseActionListener;
import com.esri.gpt.framework.security.identity.IdentityException;
import com.esri.gpt.framework.security.identity.NotAuthorizedException;
import com.esri.gpt.framework.security.principal.Publisher;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintStream;
import java.io.Serializable;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;

@ManagedBean(name="Collection")
@ViewScoped
public class ManageCollectionMember extends BaseActionListener  implements Serializable {
 
	private static final long serialVersionUID = 1L;
        
	private static ArrayList<Collection> collectionList = findData();

        private String localID="";
        private String localTitle="";
        private String localUpdateID="";
        private String localSelectedID="";
        private String localSelectedTitle="";
        private boolean show=false;
        private String message="";
        
        
        //Setting and getting parameter

        
        public void setshow(String param){
            if (param.equals("false")){
                this.show=false;
            } else {
                this.show=true;
            }
       }
        public boolean getshow(){
            return this.show;
        }
 
        public void setmessage(String param){
            this.message=param;
        }
       public String getmessage(){
           String ret=this.message;
           return ret;
        }

        public String getlocalSelectedID(){
            return this.localSelectedID;
        }
       public void setlocalSelectedID(String sID){
            this.localSelectedID=sID;
        }
       public String getlocalSelectedTitle(){
            return this.localSelectedTitle;
        }
       public void setlocalSelectedTitle(String sID){
            this.localSelectedTitle=sID;
        }
       public void setlocalID(String sID){
            this.localID=sID;
        }
        public void setlocalTitle(String sTitle){
            this.localTitle=sTitle;
        }
       public void setlocalUpdateID(String sID){
            this.localUpdateID=sID;
        }
        public String getlocalID(){
            return this.localID;
        }
        public String getlocalUpdateID(){
            return this.localUpdateID;
        }
        public String getlocalTitle(){
            return this.localTitle;
        }
        public String  refreshData(){
            collectionList = findData();
            return null;
        }
        public String  clearData(){
            message="";
            show=false;
            return null;
        }
        //Function for deleting one collection
    public String  deleteCollection() throws SQLException, IOException, NotAuthorizedException, IdentityException, ImsServiceException{
        RequestContext context = this.getContextBroker().extractRequestContext();
        CollectionDao ccc = new CollectionDao(context);
        Publisher publisher = new Publisher(context);
        CatalogDao colDao = new CatalogDao(context);
        CatalogDao.collData c = new CatalogDao.collData();
        c.ID=this.localID;
        c.Tilte=this.localTitle;
        ArrayList<CatalogDao.collData> lista=colDao.getAllCollectionData(this.localID);
        StringSet ss =new StringSet();
        for (int i=0;i<lista.size();i++){
            ss.add(lista.get(i).ID);
        }
        try {
            
            ccc.removeMembers(publisher, ss,c.ID);
        } catch (CatalogIndexException ex) {
            Logger.getLogger(ManageCollectionMember.class.getName()).log(Level.SEVERE, null, ex);
        }
        try {
            colDao.deleteCollection(c);
        } catch (IOException ex) {
            Logger.getLogger(ManageCollectionMemberData.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {

            Logger.getLogger(ManageCollectionMemberData.class.getName()).log(Level.SEVERE, null, ex);
        }
        collectionList = findData();
        show=true;
        message="1";
        return null;
    }
    
    //Function for add Collection
    public String addAction() {
        if ((this.localID.equals("")) || (this.localTitle.equals(""))){
            message="2";
        } else {
            CatalogDao colDao = new CatalogDao(RequestContext.extract(null));
            CatalogDao.collData c = new CatalogDao.collData();
            c.ID=this.localID;
            c.Tilte=this.localTitle;
            try {
                String ret =colDao.insertCollection(c);
                message="3";
                if (ret.equals("1")) message="4";
            } catch (IOException ex) {
                Logger.getLogger(ManageCollectionMemberData.class.getName()).log(Level.SEVERE, null, ex);
            } catch (SQLException ex) {

                Logger.getLogger(ManageCollectionMemberData.class.getName()).log(Level.SEVERE, null, ex);
            }
            collectionList = findData();
        }
        show=true;

        return null;
    }
    //Function for update collection selected
    public String updateCollection() throws NotAuthorizedException, IdentityException, ImsServiceException, SQLException{
        RequestContext context = this.getContextBroker().extractRequestContext();
        CollectionDao ccc = new CollectionDao(context);
        Publisher publisher = new Publisher(context);
        CatalogDao colDao = new CatalogDao(context);
        CatalogDao.collData c = new CatalogDao.collData();
        c.ID=this.localUpdateID;
        c.Tilte=this.localTitle;
        String ret="";
        try {
            message=colDao.updateCollection(c);

            //devo rimuovere e poi aggiungere di nuovo la risorsa
            ArrayList<CatalogDao.collData> lista=colDao.getAllCollectionData(c.ID);
            StringSet ss =new StringSet();

            for (int i=0;i<lista.size();i++){
                ss.add(lista.get(i).ID);

            }
            try {
                ccc.removeMembers(publisher, ss,c.ID);
                ccc.addMembers(publisher, ss, c.ID);
            } catch (CatalogIndexException ex) {
                Logger.getLogger(ManageCollectionMember.class.getName()).log(Level.SEVERE, null, ex);
            }

            
        } catch (IOException ex) {
            Logger.getLogger(ManageCollectionMemberData.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(ManageCollectionMemberData.class.getName()).log(Level.SEVERE, null, ex);
        }
        collectionList = findData();
        show=true;
        message="5";
        return null;

    }
    
    //Function for retrieve Collection Data
	public static ArrayList<Collection> findData()  {
            ArrayList<Collection> pp=new ArrayList<Collection> ();
            try {
                CatalogDao colDao = new CatalogDao(RequestContext.extract(null));
                ArrayList<CatalogDao.collData> elenco= colDao.getAllCollection();
                for (int i=0;i<elenco.size();i++){
                    pp.add(new Collection(elenco.get(i).ID,elenco.get(i).Tilte));
                }
		
           } catch (SQLException ex) {
                Logger.getLogger(ManageCollectionMember.class.getName()).log(Level.SEVERE, null, ex);
            } catch (IOException ex) {
                Logger.getLogger(ManageCollectionMember.class.getName()).log(Level.SEVERE, null, ex);
            }
            return pp;
 	}
 
 
	public ArrayList<Collection>  getCollectionList() {
		return collectionList;//findData();
 	}
 
        //Collection Object
	public static class Collection{
 
		String ID;
		String TITLE;
                String IDTrunched;
 
		public Collection(String ID, String Title) {
 
			this.ID=ID;
			this.TITLE = Title;
                        this.IDTrunched=this.ID;
                        if (this.ID.length()>15){
                            this.IDTrunched=this.IDTrunched.substring(0, 20) + "...";
                        }
		}
                public String getID(){
                    return this.ID;
                }
                public String getTITLE(){
                    return this.TITLE;
                }
                public String getIDTrunched(){
                    return this.IDTrunched;
                }
                public void setID(String sID){
                    this.ID=sID;
                    this.IDTrunched=this.ID;
                    if (this.ID.length()>20){
                        this.IDTrunched=this.IDTrunched.substring(0, 20) + "...";
                    }
                }
                public void setIDTrunched(String sID){
                    this.IDTrunched=sID;
                }
                public void setTITLE(String sTitle){
                    this.TITLE=sTitle;
                }
		//getter and setter methods
	}

}