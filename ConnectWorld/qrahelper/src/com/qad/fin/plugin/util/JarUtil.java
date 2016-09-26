package com.qad.fin.plugin.util;


import java.io.IOException;
import java.lang.reflect.Method;
import java.net.URL;
import java.net.URLClassLoader;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;

/**
 *
 * @author zal
 */
public class JarUtil {
    
      public  ArrayList<String[]> getJarMethod(String jarFile) throws Exception {
        String NORMAL_METHOD= "waitequalsnotifynotifyAlltoStringhashCodegetClass"; 
        ArrayList<String[]> a = new ArrayList<String[]>();
        try {
            //通过jarFile 和JarEntry得到所有的类
            JarFile jar = new JarFile(jarFile);
            Enumeration e = jar.entries();
            while (e.hasMoreElements()) {
                JarEntry entry = (JarEntry) e.nextElement();

                if (entry.getName().indexOf("META-INF") < 0) {
                    String sName = entry.getName();
                    String substr[] = sName.split("/");
                    String pName = "";

                    if(!sName.endsWith("Service.class"))
                    	continue;
                    
                    for (int i = 0; i < substr.length - 1; i++) {
                        if (i > 0)
                            pName = pName + "/" + substr[i];
                        else
                            pName = substr[i];
                    }
                    
                    if (sName.indexOf(".class") < 0)
                    {
                        sName = sName.substring(0, sName.length() - 1);
                    }
                    else
                    {
         
                        URL url1=new URL("file:" + jarFile);
                        URLClassLoader myClassLoader=new URLClassLoader(new URL[]{url1},Thread.currentThread().getContextClassLoader());
                        String ppName = sName.replace("/", ".").replace(".class", "");
                        Class myClass = myClassLoader.loadClass(ppName);
                        
                    
                        Method m[] = myClass.getMethods();
                        for(int i=0; i<m.length; i++)
                        { 
                            
                            String sm = m[i].getName();
                           // if(sm.equals("getToBillDInvoice"))
                           // {
                           //      m[i].getParameters();
                           // }
                            if (NORMAL_METHOD.indexOf(sm) <0)
                            {
                                String[] c = {sName  + "$" + sm , sName};
                               
                                a.add(c);
                            }
                        }
                    }
                    String[] b = { sName, pName };
                    a.add(b);
                }
            }
            return a;
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return a;
    }
}
