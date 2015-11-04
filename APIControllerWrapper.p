/* APIControllerWrapper.p - API Controller program for class methods         */
/* Copyright 1986 QAD Inc. All rights reserved.                              */
/* $Id:: APIControllerWrapper.p 17360 2012-05-04 16:35:23Z ddo            $: */
/*                                                                           */
/* Acts as the interface between the API and its controller class            */
/*                                                                           */

using com.qad.qra.api.IAPIController.

define variable hController as class IAPIController.

procedure setController:
/*-------------------------------------------------------------------------
   Purpose      : Sets the handle for the API Controller
                     
   Parameters   : [input]
                   phController - Handle to the API Controller
      
   Notes        : 
 ------------------------------------------------------------------------*/

   define input parameter phController as class IAPIController no-undo.
   
   hController = phController.
   
end procedure.
   
procedure getRequestDataset:
/*-------------------------------------------------------------------------
   Purpose      : Returns an instance of the request API dataset
                     
   Parameters   : [output]
                   phDataset - The handle to the dataset
      
   Notes        : This method is used by the MFG/PRO UI program to get the
                  instance of the request dataset. The UI program will have 
                  a static definition of the dataset defined as 
                  reference-only, and must call this method with the BIND
                  option. The API controller is responsible for maintaining
                  the context.
 ------------------------------------------------------------------------*/

   define output parameter dataset-handle phDataset bind.
   
   do on error undo, return error:
      hController:getRequestDataset(output dataset-handle phDataset bind).
   end.
   
end procedure.

procedure getResponseDataset:
/*-------------------------------------------------------------------------
   Purpose      : Returns an instance of the response API dataset
                     
   Parameters   : [output]
                   phDataset - The handle to the dataset
      
   Notes        : This method is used by the MFG/PRO UI program to get the
                  instance of the response dataset. The UI program will have 
                  a static definition of the dataset defined as 
                  reference-only, and must call this method with the BIND
                  option. The API controller is responsible for maintaining
                  the context.
 ------------------------------------------------------------------------*/

   define output parameter dataset-handle phDataset bind.
   
   do on error undo, return error:
      hController:getResponseDataset(output dataset-handle phDataset bind).
   end.
   
end procedure.

procedure getRequestBuffer:
/*-------------------------------------------------------------------------
   Purpose      : Returns the handle to the request dataset buffer
                     
   Parameters   : [input]
                   pcBufferName - The name of the buffer to get
      
   Returns      : handle to the buffer
      
 ------------------------------------------------------------------------*/
   define input  parameter pcBufferName as character no-undo.
   define output parameter phBuffer     as handle    no-undo.
   
   do on error undo, return error:
      phBuffer = hController:getRequestBuffer (input pcBufferName).
   end.   
end procedure.

procedure closeQuery:
/*-------------------------------------------------------------------------
   Purpose      : Closes the query on the buffer provided so no more records
                   are available based on the current parent record
                     
   Parameters   : [input]
                   pcBufferName - The name of the buffer to close query for
      
   Returns      :

 ------------------------------------------------------------------------*/

   define input parameter pcBufferName as character.
   
   do on error undo, return error:
   
   end.

end procedure.

procedure getNextRecord:
/*-------------------------------------------------------------------------
   Purpose      : Brings the next record for the supplied buffer into scope
                     
   Parameters   : [input]
                   pcBufferName - The name of the buffer to get the next
                                  record for

      
   Notes        : Uses the query on the buffer to get the next record. 
                  Does not return any data because the UI program already
                  has an instance of the dataset and the record that this
                  method finds will be moved into scope
------------------------------------------------------------------------*/

   define input parameter pcBufferName as character.
   
   do on error undo, return error:
      /*
      Bug fixing section
      */
      return hController:getNextRecord(input pcBufferName).
   end.
   
end procedure.

procedure getRecordCount:
/*-------------------------------------------------------------------------
   Purpose      : Counts the number of records in the current buffer with 
                   the same parent record
                     
   Parameters   : [input]
                   pcBufferName - The name of the buffer to get the record
                                   count
      
   Returns      : integer
      
 ------------------------------------------------------------------------*/
   define input parameter pcBufferName as character.
   define output parameter piCount as integer.
   
   do on error undo, return error:
      piCount = hController:getRecordCount(input pcBufferName).
   end.
   
end procedure.

procedure setCommonDataBuffer:
/*-------------------------------------------------------------------------
   Purpose      : Lets the controller know that the MFG/PRO program will
                  be getting its data from the buffer in the request but
                  will be put into a dataset shared by many controllers
                     
   Parameters   : [input]
                   pcBuffer - Buffer name in the request
      
   Notes        : 
------------------------------------------------------------------------*/

   define input parameter pcBuffer as character no-undo.
   
   do on error undo, return error:
      hController:setCommonDataBuffer(input pcBuffer).
   end.
   
end procedure.

procedure getBufferContext:
/*-------------------------------------------------------------------------
   Purpose      : Gets the current buffer name and key fields
                     
   Parameters   : [output]
                   pcBufferName - Current context buffer name
                   pcKey        - Field/Value pairs of key fields
      
   Notes        : Used by the error message infrastructure to put the 
                  current context into the exceptions
 ------------------------------------------------------------------------*/

   define output parameter pcBufferName as character.
   define output parameter pcKey        as character.
   
   do on error undo, return error:
      if valid-object(hController) then
         hController:getBufferContext (output pcBufferName,
                                       output pcKey).
   end.
   
end procedure.

procedure applyCustomizations:
/*-------------------------------------------------------------------------
   Purpose      : Applies the UI and ICT customizations for the buffer
                     
   Parameters   : [input]
                   pcBuffer - Dataset buffer to check for customizations
                   phBuffer - Database buffer currently in scope
                   pcFrame  - Name of the frame
      
   Notes        : 
 ------------------------------------------------------------------------*/

   define input  parameter pcBuffer   as character no-undo.
   define input  parameter phBuffer   as handle    no-undo.
   define input  parameter pcFrame    as character no-undo.
   define output parameter plContinue as logical   no-undo.
         
   do on error undo, return error:
      if valid-object(hController) then 
         plContinue = hController:applyCustomizations (input pcBuffer,
                                                       input phBuffer,
                                                       input pcFrame).
   end.
end procedure.

procedure callCustomization:
/*-------------------------------------------------------------------------
   Purpose      : Calls a customization directly to communicate required
                   information
                     
   Parameters   : [input]
                   pcCustomization - Name of the customization
                   phParameters    - Temp-table of parameters 
      
 ------------------------------------------------------------------------*/

   define input parameter pcCustomization as character no-undo.
   define input parameter table-handle phParameters.
            
   do on error undo, return error:
      if valid-object(hController) then 
         hController:callCustomization (input pcCustomization,
                                        input table-handle phParameters by-reference).
   end.
end procedure.
