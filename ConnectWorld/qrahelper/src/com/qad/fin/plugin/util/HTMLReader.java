package com.qad.fin.plugin.util;


import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

public class HTMLReader {    
    
    public static ArrayList<String> getComponentURL(String infourl) {        
        //String infourl = "http://vmzal03:16560/wsa/wsa1/wsdl";        
        System.setProperty("sun.net.client.defaultConnectTimeout", "60000");        
        System.setProperty("sun.net.client.defaultReadTimeout", "60000");        
        ArrayList<String> retValue = new ArrayList();
        StringBuffer content = new StringBuffer();        
        BufferedReader reader = null;        
        URLConnection connection = null;        
        try {            
            ArrayList<String> lines = new ArrayList();
            URL url = new URL(infourl);            
            connection = url.openConnection();            
            InputStream inputstream = connection.getInputStream();            
            reader = new BufferedReader(new InputStreamReader(inputstream,
                    "utf-8"));            
            String line = null;            
            while ((line = reader.readLine()) != null) {                
                
                lines.add(line);
                content.append(line);
            }            
            Document doc = parseXMLDocument(content.toString());
            retValue =  getComponents(doc);
          
            
        } catch (Exception e) {            
            e.printStackTrace();            
            
        } finally {            
            if (reader != null) {                
                try {                    
                    reader.close();                    
                } catch (IOException e) {                    
                    
                    e.printStackTrace();                    
                }                
            }            
        }
        return retValue;
         
    }    
    
    public static Document parseXMLDocument(String xmlString) {        
        if (xmlString == null) {            
            throw new IllegalArgumentException();            
        }        
        try {            
            return DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(new InputSource(new StringReader(xmlString)));            
        } catch (Exception e) {            
            throw new RuntimeException(e.getMessage());            
        }        
    }    
    
    public static ArrayList<String> getComponents(Document d) throws Exception {
        
        NodeList elements = d.getElementsByTagName("a");
        ArrayList<String> ret = new ArrayList<String>();
        
        for (int j = 0; j < elements.getLength(); j++) {
            Node node = elements.item(j);
            
            NamedNodeMap map = node.getAttributes();
            for (int i = 0; i < map.getLength(); i++) {
                String component = map.item(0).getNodeValue();
                if (component.contains("fin") && !ret.contains(component)) {
                    ret.add(component);
                }
            }
            
        }
        
        return ret;
    }
    
}
