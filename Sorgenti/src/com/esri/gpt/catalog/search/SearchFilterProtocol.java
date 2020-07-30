package com.esri.gpt.catalog.search; 

import com.esri.gpt.catalog.search.ISearchFilter; 
import com.esri.gpt.catalog.search.SearchException;
import com.esri.gpt.catalog.search.SearchFilterContentTypes;
import com.esri.gpt.catalog.search.SearchParameterMap; 
import com.esri.gpt.catalog.search.SearchParameterMap.Value;
import com.esri.gpt.framework.util.Val;
import java.util.logging.Logger;

@SuppressWarnings("serial") 
public class SearchFilterProtocol implements ISearchFilter { 

private static Logger LOG = 
	    Logger.getLogger(SearchFilterContentTypes.class.getCanonicalName());	
	
// key to be used to serialize class to a map 
private static String KEY_PROTOCOL = "protocol"; 

// instance variable 
private String protocol;

// property (Can be used by jsf(advanced search page) 
public String getProtocol() { 
return Val.chkStr(protocol);
 } 

// property (Can be used by jsf(advanced search page) 
public void setProtocol(String protocol) {
this.protocol = protocol; 
} 

// Serialize class instance into a map 
public SearchParameterMap getParams() { 
SearchParameterMap map = new SearchParameterMap(); 
map.put(KEY_PROTOCOL, map.new Value(this.getProtocol(), ""));
LOG.fine("map:"+map.toString());
return map;
}

//20131002-ricompilato con Java7

// The class may receive a new map for deserialization (e.g. saved searches 
// can trigger this 
public void setParams(SearchParameterMap parameterMap) throws SearchException { 
Value val = parameterMap.get(KEY_PROTOCOL);
 this.setProtocol(val.getParamValue());
 LOG.fine("val:"+val.getParamValue());
}

// Deep comparison of filters 
public boolean isEquals(Object obj) {
if (obj instanceof SearchFilterProtocol) { 
return ((SearchFilterProtocol) obj).getProtocol().equals(this.getProtocol()); 
} 
return false; 
} 

// This will be called by the clear button 
public void reset() { 
this.setProtocol(""); 
} 

// Before search, validate will be called. An exception can be thrown 
// that will stop the search and the error is displayed on the search page 
public void validate() throws SearchException {
if (this.getProtocol().equals("this should throw an exception")) {
throw new SearchException("this should throw an exception");
} 
} 
}