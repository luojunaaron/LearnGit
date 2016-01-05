
/*------------------------------------------------------------------------
    File        : GetCInvoiceByPaySelCodeAndSuppFacade.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : 
    Created     : Tue Jan 05 11:02:40 CST 2016
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */

{proxy/bpaymentselection/apigetcinvoicebypayselandsupdef.i}

define input  parameter payselcode as character no-undo.
define input  parameter supplierCode as character no-undo.
define output parameter table for tCInvoiceList.

icPaySelCode = payselcode.
icSupplierCode = supplierCode.
{proxy/bpaymentselection/apigetcinvoicebypayselandsuprun.i}

