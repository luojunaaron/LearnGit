package com.qad.fin.plugin.util;

import java.util.ArrayList;
import java.util.List;

public class CodeUtil {
String s= "";


//Write DataItem name
public ArrayList<String> FillInDataItemName(ArrayList<String> lines,String target)
{
	//String selectedDI = this.dataItemListBox.Text.Trim();

    int i = 0;
    for (String line : lines)
    {
        if (line.contains("$DataItemName$"))
        {
            lines.set(i, line.replace("$DataItemName$", target));
        }
        i++;

    }
    return lines;
}



//Write Interface name
public ArrayList<String> FillInInterfaceName(ArrayList<String> lines, String target)
{
    //String selectedDI = this.dataItemListBox.Text.Trim();

    int i = 0;
    for (String line : lines)
    {
        if (line.contains("$InterfaceName$"))
        {
            lines.set(i , line.replace("$InterfaceName$", target));
        }
        i++;

    }
    return lines;
}



public ArrayList<String> FillInElementsForComments(ArrayList<String> lines, String holder, String target)
{

  int i = 0;
  for (String line : lines)
  {
      if (line.contains(holder))
      {
          lines.set(i , line.replace(holder, target));
      }
      i++;

  }
  return lines;
}

//Write DataItem Variable  name
public ArrayList<String> FillInDataItemVarName(ArrayList<String> lines ,String target)
{
   // String selectedDI = this.dataItemListBox.Text.Trim();

    int i = 0;
    for (String line : lines)
    {
        if (line.contains("$DataItemVarName$"))
        {
            lines.set(i,line.replace("$DataItemVarName$", target.substring(0, 1).toLowerCase() + target.substring(1, target.length() - 1)));
        }
        i++;

    }
    return lines;
}

//Write Entity  name
public ArrayList<String> FillInEntityName(ArrayList<String> lines,String target)
{
  int i = 0;
  for (String line : lines)
  {
      if (line.contains("$EntityName$"))
      {
          lines.set(i,  line.replace("$EntityName$", target.substring(1)));
      }
      i++;

  }
  return lines;
}



//Write Model  name
public ArrayList<String> FillInModelName(ArrayList<String> lines,String target)
{
    //String selectedDI = this.txtDefaultName.Text

    int i = 0;
    for (String line : lines)
    {
        if (line.contains("$ModelName$"))
        {
            lines.set(i,  line.replace("$ModelName$", target.substring(1)));
        }
        i++;

    }
    return lines;
}


//Write DataItem name
public ArrayList<String> FillInPropertiesForDataSet(ArrayList<String> lines, String[] fieldList)
{
    int i = 0;
    for (String line : lines)
    {

        if (line.contains("$InterfaceList$"))
        {
            lines.set(i, line.replace("$InterfaceList$", this.GenerateInterfaceForDataSet(fieldList)));
            break;
        }
        i++;

    }
    return lines;
}

//Write DataItem name
public ArrayList<String> FillInPropertiesForWidgetHelper(ArrayList<String> lines, String[] target)
{
  int i = 0;
  
  for(String line : lines)
  {
      if (line.contains("$Properties$"))
      {
          String propList = "";
          
          //Remove dupliated fields
          ArrayList<String> list = new ArrayList<String>();  
          for (int k=0; k< target.length; k++) {  
              if(!list.contains(target[k])) {  
                  list.add(target[k]);  
              }  
          }  
          
          String[] fieldList =   list.toArray(new String[list.size()]); // this.dataFieldListBox.Items.Cast<String>().ToArray();
          
          // public static $FieldName$AutoField = "$FieldName$AutoField";
          for (String strProp : fieldList)
          {
        	  if(strProp.indexOf("(")==-1)
        		  continue;
        	  
          	  strProp = strProp.trim();
              String fieldName = strProp.substring(0, strProp.indexOf("("));
              //fieldName = fieldName.substring(0, 1).toLowerCase() + fieldName.substring(1, fieldName.length() );
              String fieldType = strProp.substring(strProp.indexOf("(") + 1, strProp.indexOf(")") );
              propList = propList + "        public static " + fieldName + "AutoField = "  + "\""  + fieldName + "AutoField\";" + "\r\n" ;
          }
          lines.set(i, line.replace("$Properties$", propList));
          break;
      }
      i++;


  }
  return lines;
}

//Write DataItem name
public ArrayList<String> FillInProperties(ArrayList<String> lines, String[] target)
{
    int i = 0;
    String spaceStr = "";
    for(String line : lines)
    {
        if (line.contains("$Properties$"))
        {
            int startP = line.indexOf("$");
            int k = 0;
            while (k < startP)
            {
                spaceStr = spaceStr + " ";
                k++;
            }

            String propList = "";
            String[] fieldList =   target; // this.dataFieldListBox.Items.Cast<String>().ToArray();
            for (String strProp : fieldList)
            {
          	    if(strProp.indexOf("(")==-1)
        		  continue;
          	  
            	strProp = strProp.trim();
                String fieldName = strProp.trim().substring(0, strProp.indexOf("(") );
                fieldName = fieldName.substring(0, 1).toLowerCase() + fieldName.substring(1, fieldName.length() );
                String fieldType = strProp.substring(strProp.indexOf("(") + 1, strProp.indexOf(")") );
                propList = propList + fieldName + ":" + this.ConvertType(fieldType) + ";" + "\r\n" + spaceStr;
            }
            lines.set(i, line.replace("$Properties$", propList));
            break;


        }
        i++;


    }
    return lines;
}



public static String ConvertType(String jsonType)
{
    if (jsonType.contains("xsd:string"))
        return "string";

    if (jsonType.contains("xsd:boolean"))
        return "boolean";

    if (jsonType.contains("xsd:date"))
        return "Date";

    return "number";
}


//Write DataItem name
public String GenerateInterfaceForDataSet(String[] fieldList)
{
    String interfaceTemplate = "export interface $InterfaceName${\r\n$Properties$\r\n}\r\n\r\n";
    String firstInterfaceTemplate = "export interface " + fieldList[0].trim() + "{\r\n$Child$\r\n$Properties$\r\n}\r\n\r\n";
    String wholeInterfaceCodeString = ""; 
    String childTablesString = "\r\n";
    //String[] fieldList = this.dataFieldListBox.Items.Cast<String>().ToArray();
    String oneInterfaceString = "";
    String preInterfaceString = "";
    String propList = "";
    int i = 0;
    for(String strProp : fieldList)
    {
    	if(i > 0 && !strProp.startsWith("  "))
    	{ 
    		childTablesString = childTablesString + "    "  + strProp + "s: Array<" + strProp + ">;" + "\r\n";
    	}   	
        i ++;
    }
    
    
    i =0;
    for(String strProp : fieldList)
    {

        if (!strProp.startsWith("  ") || i== fieldList.length-1)
        {
            if(i ==0)
            {
                preInterfaceString = firstInterfaceTemplate.replace("$InterfaceName$", strProp.trim() + "\r\n");   
                preInterfaceString = preInterfaceString.replace("$Child$", childTablesString + "\r\n");   
                
            }
            else
                preInterfaceString = oneInterfaceString;

           
            if(i==0)
            {
                oneInterfaceString = firstInterfaceTemplate.replace("$InterfaceName$", strProp.trim());
                oneInterfaceString = firstInterfaceTemplate.replace("$Child$", childTablesString);
                
            }
            else
            {
            	oneInterfaceString = interfaceTemplate.replace("$InterfaceName$", strProp.trim());
            }
            
            i++;
            if (propList.trim().length() > 0)
            {
                wholeInterfaceCodeString = wholeInterfaceCodeString + preInterfaceString.replace("$Properties$", propList);
            }
            propList = "";
            continue;
        }
        
        String fieldName = strProp.trim().substring(0, strProp.trim().indexOf("("));
        fieldName = fieldName.substring(0, 1).toLowerCase() + fieldName.substring(1, fieldName.length());
        String fieldType = strProp.trim().substring(strProp.trim().indexOf("("),  strProp.trim().indexOf(")"));
        propList = propList + "    " + fieldName + ":" + this.ConvertType(fieldType) + ";" + "\r\n" ;
        i++;
        
    }
         
    return  wholeInterfaceCodeString;
}


	
}
