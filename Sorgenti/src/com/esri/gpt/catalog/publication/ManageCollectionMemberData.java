package com.esri.gpt.catalog.publication;

import com.esri.gpt.framework.context.RequestContext;
import java.io.IOException;
import java.io.Serializable;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;
 
@ManagedBean(name="CollectionData")
@ViewScoped
public class ManageCollectionMemberData implements Serializable{
 
	private static final long serialVersionUID = 1L;
 
	private static  ArrayList<Collection> collectionList = findData();
        private static String idPadre="";
        private static String numDati="0";

        public static void showSomething(){
            collectionList=findData();
 	}
	public static ArrayList<Collection> findData()  {
            ArrayList<Collection> pp=new ArrayList<Collection> ();
            try {
                if (idPadre instanceof String){
                    if (! idPadre.equals("")){
                        CatalogDao colDao = new CatalogDao(RequestContext.extract(null));
                        ArrayList<CatalogDao.collData> elenco= colDao.getAllCollectionData(idPadre);
                        for (int i=0;i<elenco.size();i++){
                            pp.add(new Collection(elenco.get(i).ID,elenco.get(i).Tilte));
                        }
                    }
                }
		numDati=pp.size()+"";
           } catch (SQLException ex) {
                Logger.getLogger(ManageCollectionMemberData.class.getName()).log(Level.SEVERE, null, ex);
            } catch (IOException ex) {
                Logger.getLogger(ManageCollectionMemberData.class.getName()).log(Level.SEVERE, null, ex);
            }
            return pp;
 	}
 
 
	public ArrayList<Collection>  getCollectionList() {
            //collectionList=findData();
		return collectionList;
 	}
	public void setCollectionList(ArrayList<Collection> aa) {
		collectionList=aa;
 	}
 	public String  getidPadre() {
		return idPadre;
 	}
	public void setidPadre(String aa) {
		idPadre=aa;
                
 	}
 	public String  getnumDati() {
		return numDati;
 	}
	public void setnumDati(String aa) {
		numDati=aa;
                
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
                        if (this.ID.length()>20){
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
                    if (this.ID.length()>15){
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