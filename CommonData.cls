/* CommonData.cls - Common Data Instance                                     */
/* Copyright 1986-2011 QAD Inc., Santa Barbara, CA, USA.                     */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Id:: CommonData.cls 3191 2010-12-08 11:23:39Z ddo                     $: */
/*                                                                           */
/* Base class for an object of Common Data. Common Data is defined as an     */
/* object of data that can be shared between many APIs. The definition of    */
/* the data is always a sub-set of the data used by an API. A good example   */
/* is transaction comments                                                   */
/*                                                                           */

using com.qad.qra.api.map.IBufferMap.
using com.qad.qra.api.map.BufferMap.
using com.qad.qra.api.ICommonData.

class com.qad.qra.api.CommonData implements ICommonData: 

   /*
    * Buffer Map between the API Dataset and a Common Data Dataset
    */
   define public property pBufferMap as class IBufferMap
      get.
      protected set.

   /*
    * Store the static dataset handle
    */
   define protected variable ghDataset as handle no-undo.

   /*
    * Stack of source buffers to use for common datasets
    */
   define private temp-table ttChildCommonDataObjects
      field oChildCommonData as class Progress.Lang.Object.

   define private variable goChildCommonData as class ICommonData. 
         
   constructor CommonData ():
      
      pBufferMap = new BufferMap().
      
   end constructor.

   destructor CommonData ():

      for each ttChildCommonDataObjects:         
         delete object ttChildCommonDataObjects.oChildCommonData no-error.
      end.
      
   end destructor.
   
   method public void initialize ():
   /*-------------------------------------------------------------------------
      Purpose      : Resets this class for re-use 
                     
      Parameters   : none
      
      Notes        : Empties the dataset and initializes all the child 
                      objects of this class
    ------------------------------------------------------------------------*/
   
      define variable oCommonData as class ICommonData.
      
      if valid-handle(ghDataset) then
         ghDataset:empty-dataset().
         
      for each ttChildCommonDataObjects:
         oCommonData = cast (ttChildCommonDataObjects.oChildCommonData, "ICommonData").
         oCommonData:initialize().
      end.   
   end method.
   
   method protected void addCommonDataObject (input poCommonData as class ICommonData):
   /*-------------------------------------------------------------------------
      Purpose      : Allows a common data object to be known to this class 
                     
      Parameters   : [input]
                      poCommonData - Instance of an ICommonData class
      
      Notes        : 
    ------------------------------------------------------------------------*/
      
      create ttChildCommonDataObjects.
      assign
         ttChildCommonDataObjects.oChildCommonData = poCommonData.
         
   end method.

   method protected void setAPIDataset (input dataset-handle phDataset):
   /*-------------------------------------------------------------------------
      Purpose      : Sets the API Dataset handle
                     
      Parameters   : [input]
                      phDataset - Dataset-handle
                            
      Notes        : 
    ------------------------------------------------------------------------*/
      
      ghDataset = phDataset.

   end method.

   method public void getDataset (input pcDatasetName as character,
                                  output dataset-handle phDataset bind):
   /*-------------------------------------------------------------------------
      Purpose      : Returns the common dataset 
                     
      Parameters   : [output]
                      phDataset - The handle to the dataset
      
      Notes        : If the name of this dataset matches the parameter, 
                      return the dataset owned by this class. Otherwise go
                      to the current common data instance controlled by this
                      class 
    ------------------------------------------------------------------------*/
      
      if pcDatasetName = ghDataset:name then
         phDataset = ghDataset.
      else if valid-object(goChildCommonData) then do:
         goChildCommonData:getDataset (input pcDatasetName,
                                       output dataset-handle phDataset bind).
      end.
      
   end method.
   
   method public void setBufferMap (input pcBufferMap as character):
   /*-------------------------------------------------------------------------
      Purpose      : Sets the map between an API Dataset and the Common
                      Dataset
                     
      Parameters   : [input]
                      pcBufferMap - Comma-delimited list
                            
      Notes        : The format should be "<API buffer>,<common buffer>"
    ------------------------------------------------------------------------*/

      define variable i as integer no-undo.
         
      pBufferMap:clearMap().
         
      /*
       * Check for an even number of entries in the map
       */
      if num-entries(pcBufferMap) mod 2 = 0 then do:
         do i = 1 to num-entries(pcBufferMap) by 2:
            pBufferMap:setMap(input entry(i,pcBufferMap),
                              input entry(i + 1, pcBufferMap)).
         end.
      end.         
      
   end method.
   
   method public logical isCommonBuffer (input pcSourceBufferName as character,
                                         input pcCommonBufferName as character):
   /*-------------------------------------------------------------------------
      Purpose      : Determines if the buffer is common data, shared
                      between different datasets
                     
      Parameters   : [input]
                      pcSourceBufferName - Name of the source buffer
                      pcCommonBufferName - Name of the buffer shared between
                                        controllers
                      
      Returns      : logical
      
      Notes        : Checks first to see if there is a map in this class for
                      the two buffers, and if not, checks the current child
                      common data object controlled by this class for the
                      mapping in there. This allows for a recursive structure
                      of common data classes being children of other common
                      data classes
    ------------------------------------------------------------------------*/
      
      define variable lIsCommon as logical no-undo.
      
      lIsCommon = pBufferMap:containsMap (input pcSourceBufferName,
                                          input pcCommonBufferName).

      /*
       * Check to see if the parent of this common buffer is mapped to the
       * source buffer, and if so, it is also a common buffer
       */
      if not lIsCommon then 
         lIsCommon = hasParentCommonBuffer (input pcSourceBufferName,
                                            input pcCommonBufferName).

      /*
       * Finally check the child common data objects
       */
      if not lIsCommon and valid-object(goChildCommonData) then do:
         lIsCommon = goChildCommonData:isCommonBuffer (input pcSourceBufferName,
                                                       input pcCommonBufferName).
      end.
      
      return lIsCommon.
   end method.

   method public logical isMappedBuffer (input pcDatasetName as character,
                                         input pcSourceBufferName as character):
   /*-------------------------------------------------------------------------
      Purpose      : Checks to see if the source buffer provided is used by
                      a dataset defined in this class or any of its children
                     
      Parameters   : [input]
                      pcDatasetName      - Name of the common dataset
                      pcSourceBufferName - Name of the source buffer
                      
      Returns      : logical
      
      Notes        : First checks to see if this class holds the common 
                      dataset and the source buffer for that dataset. If not,
                      it checks every child common data object of this class
                      for the same. This allows a recursive structure for 
                      common data responsible for other common data
    ------------------------------------------------------------------------*/

      define variable oCommonData as class ICommonData.      
      define variable lMapped     as logical no-undo.
      
      /*
       * Check the name AND the source buffer, since for example there may be
       * multiple transaction comments in an object and one transaction comments
       * common data may not be mapped to the source buffer provided
       */
      lMapped = (ghDataset:name = pcDatasetName and
                 lookup(pcSourceBufferName, pBufferMap:getDatasetBuffers()) <> 0).

      /*
       * If its not this class, check any common data classes that are children
       * of this class
       */                 
      if not lMapped then do:
         for each ttChildCommonDataObjects:
            oCommonData = cast (ttChildCommonDataObjects.oChildCommonData, "ICommonData").
            lMapped = oCommonData:isMappedBuffer (input pcDatasetName,
                                                  input pcSourceBufferName).
            if lMapped then do:
               goChildCommonData = oCommonData.
               leave.
            end.
         end.
      
      end.
      
      return lMapped.
   end method.
   
   method public character getAPIBuffer (input pcSourceBufferName as character,
                                         input pcCommonBufferName as character):
   /*-------------------------------------------------------------------------
      Purpose      : Gets the buffer name of the API dataset related to the
                      common buffer name
                        
      Parameters   : [input]
                      pcSourceBufferName - Name of the source buffer 
                      pcCommonBufferName - Name of the common buffer 

      Returns      : character
      
      Notes        : Can be recursive                             
    ------------------------------------------------------------------------*/
      
      define variable cAPIBufferName    as character no-undo.
      define variable cSourceBufferName as character no-undo.
      
      /*
       * If there is a mapping defined for the two buffers, then the buffer
       * in the API dataset is the source buffer name
       */
      if pBufferMap:containsMap (input pcSourceBufferName,
                                 input pcCommonBufferName) then
         cAPIBufferName = pcSourceBufferName.
      
      /*
       * Next check the current child common data object and get the 
       * mapped name from there so we can use that to get the real source 
       * buffer
       */ 
      else if valid-object(goChildCommonData) then do:
         cSourceBufferName = goChildCommonData:getAPIBuffer (input pcSourceBufferName,
                                                             input pcCommonBufferName).
         cAPIBufferName = pBufferMap:getDatasetBuffer (input cSourceBufferName).
      end.      
      
      /*
       * If the buffer name returned is blank, it means that there is no
       * direct mapping between this source buffer name and the common buffer
       * name, so if this common buffer has a parent, get the direct mapping
       * from this common data object
       */
      if cAPIBufferName = "" and
         hasParentCommonBuffer (input pcSourceBufferName,
                                input pcCommonBufferName) then do:
      
         cAPIBufferName = pBufferMap:getDatasetBuffer (input pcCommonBufferName).
      end.
      
      return cAPIBufferName.
      
   end method.

   method public character getDatasetName (input pcSourceBufferName as character,
                                           input pcCommonBufferName as character):
   /*-------------------------------------------------------------------------
      Purpose      : Gets the name of the dataset for the mapped buffers
                     
      Parameters   : [input]
                      pcSourceBufferName - Source buffer name
                      pcCommonBufferName - Common buffer name
      
      Notes        : Checks the map in this class exists and if so the result
                      will be the dataset owned by this class. If not, check
                      the current child common data object for the same
    ------------------------------------------------------------------------*/
   
      define variable cDatasetName as character no-undo.
      
      if pBufferMap:containsMap (input pcSourceBufferName,
                                 input pcCommonBufferName) then
         cDatasetName = ghDataset:name.
      
      else if hasParentCommonBuffer (input pcSourceBufferName,
                                     input pcCommonBufferName) then
         cDatasetName = ghDataset:name.
         
      else if valid-object(goChildCommonData) then do:
         cDatasetName = goChildCommonData:getDatasetName (input pcSourceBufferName,
                                                          input pcCommonBufferName).
      end.
      
      return cDatasetName.    
   end.
      
   method public void copyRequestData (input pcCommonBufferName as character,
                                       input phRequestBuffer    as handle):
   /*-------------------------------------------------------------------------
      Purpose      : Copies the request data into the common dataset 
                     
      Parameters   : [input]
                      pcCommonBufferName - Name of the buffer to copy to
                      phRequestBuffer    - Handle to the request buffer
      
      Notes        : 
    ------------------------------------------------------------------------*/

      define variable hCommonBuffer as handle no-undo.
      
      /*
       * If the source buffer is not in the map for this class, recursively
       * call the current child common data class 
       */
      if lookup (pcCommonBufferName, pBufferMap:getSourceBuffers()) = 0 then do:
         if valid-object(goChildCommonData) then do:
            goChildCommonData:copyRequestData (input pcCommonBufferName,
                                               input phRequestBuffer).
         end.
      end.
      else do:
         /*
          * If this is the top level buffer, then we need to clear this 
          * dataset. This will prevent situations where this dataset is used
          * in multiple iterations in the main API dataset and the data is 
          * the same in both iterations, causing unique index violations
          */
         if isTopBuffer (input pcCommonBufferName) then
            ghDataset:empty-dataset().
         
         hCommonBuffer = ghDataset:get-buffer-handle(pcCommonBufferName).
      
         if valid-handle(phRequestBuffer) then do:
            hCommonBuffer:buffer-create().
            hCommonBuffer:buffer-copy(phRequestBuffer).
         end.
      end.                                      
   end method.
   
   method private logical hasParentCommonBuffer (input pcSourceBufferName as character,
                                                 input pcCommonBufferName as character):
   /*-------------------------------------------------------------------------
      Purpose      : Determines if the current source buffer name is the
                      parent of this common buffer
                     
      Parameters   : [input]
                      pcSourceBufferName - Name of the source buffer
                      pcCommonBufferName - Name of the buffer shared between
                                            controllers
                      
      Returns      : character
      
      Notes        : Used in the situation where the common data dataset has
                      multiple levels, and the API is only ever setting the
                      top-level source buffer name. When the common data API
                      requests for the next record for that buffer, we need 
                      to know if this dataset contains the parent buffer 
                      matching that source buffer. 
    ------------------------------------------------------------------------*/
      
      define variable hBuffer as handle no-undo.
      define variable hParent as handle no-undo.
      define variable lHasParent as logical no-undo.
      
      define variable i as integer no-undo.
      
      hBuffer = ghDataset:get-buffer-handle(pcCommonBufferName).
      if valid-handle(hBuffer) then do:
         if valid-handle(hBuffer:parent-relation) then do:
            hParent = hBuffer:parent-relation:parent-buffer.
            if valid-handle(hParent) then do:
               lHasParent = pBufferMap:containsMap (input pcSourceBufferName,
                                                    input hParent:name).
               if not lHasParent then
                  lHasParent = hasParentCommonBuffer (input pcSourceBufferName,
                                                      input hParent:name).
            end.
         end.
      end.
      
      return lHasParent.
   end method.
   
   method private logical isTopBuffer (input pcCommonBufferName as character):
   /*-------------------------------------------------------------------------
      Purpose      : Determines if the current common buffer name is the
                      top buffer in the dataset
                     
      Parameters   : [input]
                      pcCommonBufferName - Name of the buffer shared between
                                            controllers
                      
      Returns      : logical
      
      Notes        : Checks to see if there is a parent relation for this 
                      buffer 
    ------------------------------------------------------------------------*/
      
      define variable lTopBuffer as logical no-undo.
      define variable hBuffer    as handle  no-undo.
      
      hBuffer = ghDataset:get-buffer-handle(pcCommonBufferName).
      if valid-handle(hBuffer) then
         lTopBuffer = not valid-handle(hBuffer:parent-relation).
         
      return lTopBuffer.
      
   end method.
end class.
