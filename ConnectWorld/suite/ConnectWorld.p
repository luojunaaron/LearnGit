 
 
 /*------------------------------------------------------------------------
    File        : ConnectWorld.p 
    Syntax      : 
    Author(s)   : zal
    Created     : Tue Jan 05 13:48:57 CST 2016
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
BLOCK-LEVEL ON ERROR UNDO, THROW.
@TestSuite(procedures="test/GetCInvoiceBySupplierAndPaySelCode.p,test/GetHashTotalByPaySelCodeTestCase.p,test/PaySelTestCase.p").
  