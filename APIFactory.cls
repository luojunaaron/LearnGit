/* APIFactory.cls - Service Interface Native API Factory Class               */
/* Copyright 1986-2011 QAD Inc., Santa Barbara, CA, USA.                     */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Id:: APIFactory.cls 3191 2010-12-08 11:23:39Z ddo                     $: */
/*                                                                           */
/* Creates API controller class objects based on the name of the API         */
/*                                                                           */

using com.qad.qra.api.IAPIController.
using com.qad.qra.api.APIFactory.

class com.qad.qra.api.APIFactory:

   {us/px/pxsevcon.i}
   
   /*
    * Controller configuration dataset
    */
   {com/qad/qra/api/dsController.i "private"}
      
   /*
    * Controller configuration XML file name
    */
   define private variable gcControllerXML as character no-undo.
   
   /* Implementation of the Singleton pattern */
   define public static property Instance as class APIFactory
      get:
         if not valid-object(Instance) then do:
            Instance = new APIFactory() no-error.
            if not valid-object(Instance) then 
               return error.
         end.         
         return Instance.
      end.
      private set.
      
   constructor private APIFactory():
      
      define variable lContinue as logical no-undo.
      
      assign
         gcControllerXML = "controllers.xml".
      
      /*
       * Load the controller configuration file
       */ 
      lContinue = loadControllerConfig().
      if not lContinue then return error.
                 
   end constructor.
   
   method public class IAPIController getAPIController (input pcAPIName as character): 
   
      define variable oController as class IAPIController no-undo.

      if not can-find(first ttAPI where ttAPI.cName = pcAPIName) then do on error undo, return error:
         /* No entry for # in API Controller configuration file */
         run throwException (input "11223",
                             input {&APP-ERROR-NO-REENTER-RESULT},
                             input ?,
                             input ?,
                             input pcAPIName,
                             input ?,
                             input ?,
                             input ?).
      end.
        
      for first ttAPI where ttAPI.cName = pcAPIName:            
 
         oController = cast(getObjectInstance (input ttAPI.cClass), "IAPIController").
         if not valid-object(oController) then
            oController = dynamic-new ttAPI.cClass () no-error.
         
         if valid-object(oController) then
            oController:setAPIName (input ttAPI.cName).
      end.
     
      if not valid-object(oController) then do on error undo, return error:
         /* Unable to create API Controller for # */
         run throwException (input "11221",
                             input {&APP-ERROR-NO-REENTER-RESULT},
                             input ?,
                             input ?,
                             input ttAPI.cName,
                             input ?,
                             input ?,
                             input ?).
      end.    
      
      return oController.
      
   end method.

   method public character getAPIProgram (input pcAPIName as character):
   /*-------------------------------------------------------------------------
      Purpose      : Return the name of the MFG/PRO program to run for the
                      API controller
                     
      Parameters   : [input]
                      pcAPIName - Name of the API
      
      Returns      : MFG/PRO program name
      
      Notes        : 
    ------------------------------------------------------------------------*/
   
      define variable cExtProgram as character no-undo.
      define variable cAPIType as character no-undo.
      define buffer ttAPI for ttAPI.

      for first ttAPI where ttAPI.cName = pcAPIName:
         
         assign
            cExtProgram = ttAPI.cExtProgram
            cAPIType    = ttAPI.cType. 
         
      end.
      
      if cExtProgram = "" and cAPIType <> "query" then do on error undo, leave:
         /* API # has no entry point */
         run throwException (input "11224",
                             input {&APP-ERROR-NO-REENTER-RESULT},
                             input ?,
                             input ?,
                             input pcAPIName,
                             input ?,
                             input ?,
                             input ?).
      end.
 
      return cExtProgram.   
   end method.
   
   method public character getAPIMethod (input pcAPIName as character):
   /*-------------------------------------------------------------------------
      Purpose      : Return the name of the method in the program to run for 
                       the API controller
                     
      Parameters   : [input]
                      pcAPIName - Name of the API
      
      Returns      : MFG/PRO program method name
      
      Notes        : 
    ------------------------------------------------------------------------*/
          
      define variable cExtMethod as character no-undo.
      define buffer ttAPI for ttAPI.
      
      for first ttAPI where ttAPI.cName = pcAPIName:
         
         cExtMethod = ttAPI.cExtMethod.
         
      end.
      
      return cExtMethod.

   end method.

   method public character getRequestSchemaFileName (input pcAPIName as character):
   /*-------------------------------------------------------------------------
      Purpose      : Return the name of the request schema file for the API
                     
      Parameters   : [input]
                      pcAPIName - Name of the API
      
      Returns      : Request Schema File Name 
      
      Notes        : 
    ------------------------------------------------------------------------*/
          
      define variable cFileName as character no-undo.
      define buffer ttAPI for ttAPI.
      
      for first ttAPI where ttAPI.cName = pcAPIName:
         
         cFileName = ttAPI.cRequestSchema.
         
      end.
      
      return cFileName.

   end method.

   method public character getResponseSchemaFileName (input pcAPIName as character):
   /*-------------------------------------------------------------------------
      Purpose      : Return the name of the response schema file for the API
                     
      Parameters   : [input]
                      pcAPIName - Name of the API
      
      Returns      : Response Schema File Name 
      
      Notes        : 
    ------------------------------------------------------------------------*/
          
      define variable cFileName as character no-undo.
      define buffer ttAPI for ttAPI.
      
      for first ttAPI where ttAPI.cName = pcAPIName:
         
         cFileName = ttAPI.cResponseSchema.
         
      end.
      
      return cFileName.

   end method.

   method public character getAPIName (input pcClassName as character):
   /*-------------------------------------------------------------------------
      Purpose      : Return the name of the API for the class
                     
      Parameters   : [none]
      
      Returns      : API Name
      
      Notes        : 
    ------------------------------------------------------------------------*/
          
      define variable cAPIName as character no-undo.
      define buffer ttAPI for ttAPI.
      
      for first ttAPI where ttAPI.cClass = pcClassName:
         
         cAPIName = ttAPI.cName.
         
      end.
      
      return cAPIName.

   end method.

   method public character getAPIType (input pcAPIName as character):
   /*-------------------------------------------------------------------------
      Purpose      : Return the type of the API
                     
      Parameters   : [input]
                      pcAPIName - name of the API
      
      Returns      : API Type
      
      Notes        : 
    ------------------------------------------------------------------------*/
          
      define variable cAPIType as character no-undo.
      define buffer ttAPI for ttAPI.
      
      for first ttAPI where ttAPI.cName = pcAPIName:
         
         cAPIType = ttAPI.cType.
         
      end.
      
      return cAPIType.

   end method.

   method private logical loadControllerConfig ():
   /*-------------------------------------------------------------------------
      Purpose      : Load the Controller Configuration 
                     
      Parameters   : [none]

      Notes        : Looks in current propath, if not available looks in the
                     "config" directory in the propath 
    ------------------------------------------------------------------------*/
            
      define variable cFullPath  as character no-undo.
      define variable cSeparator as character no-undo.
      define variable lOK        as logical   no-undo.
      define variable i          as integer   no-undo.
      
      empty temp-table ttAPI.
            
      if opsys = "unix" then cSeparator = "/".
      else cSeparator = "~\".
      
      cFullPath = search(gcControllerXML).
      if cFullPath = ? then 
         cFullPath = search("config" + cSeparator + gcControllerXML).
      
      if cFullPath <> ? then do:
         lOK = dataset dsControllers:read-xml("file", cFullPath, "empty", ?, ?) no-error.
         if not lOK then do on error undo, leave:
            run throwException (input ?,
                                input {&APP-ERROR-NO-REENTER-RESULT},
                                input ?,
                                input ?,
                                input ?,
                                input ?,
                                input ?,
                                input ?).
         end.
      end.      
      else do on error undo, leave:
         /* Unable to find API Controller configuration file */
         run throwException (input "11222",
                             input {&APP-ERROR-NO-REENTER-RESULT},
                             input ?,
                             input ?,
                             input ?,
                             input ?,
                             input ?,
                             input ?).
         
      end.
            
      return lOK.
   end method.

   method private Progress.Lang.Object getObjectInstance (input pcClassName as character):
   /*------------------------------------------------------------------------------
     Purpose:     Searches the object stack and returns the first running instance 
                  of the object type on the object stack. If there is no running 
                  instance on the stack then the unknown value (?/null) is 
                  returned.
                                
     Parameters:  <input>
                  pcClassName - Class Name of the object that you want to 
                                retrieve from the object stack.

     Notes:
   ------------------------------------------------------------------------------*/ 
   
      define variable objectInstance as progress.Lang.Object no-undo.
      define variable currentObject  as progress.Lang.Object no-undo.
      define variable currentClass   as progress.Lang.Class  no-undo. 

      currentObject = session:first-object.
        
      do while(valid-object(currentObject)):
      
         currentClass = currentObject:GetClass().

         if currentClass:TypeName = pcClassName then do:
            objectInstance = currentObject. 
            leave.
         end. 

         currentObject = currentObject:next-sibling.
         
      end.
   
      return objectInstance.
   
   end method.   
end class.   
