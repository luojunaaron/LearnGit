
/*------------------------------------------------------------------------
    File        : custom1.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : 
    Created     : Tue Jan 05 11:14:38 CST 2016
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */

{proxy/bpaymentselection/apigetcinvoicebypayselandsupdef.i}
icPaySelCode = "zalps3".
icSupplierCode = ?.
{proxy/bpaymentselection/apigetcinvoicebypayselandsuprun.i}
define variable str1 as character format "x(44)".
for each tCInvoiceList:
   str1 =  tcCinvoiceType + "  " + tcDescription.
   message str1.
end.
//change in master
//change in release branch
//change in release branch 2.
//change in release branch 3.