 
 /*------------------------------------------------------------------------
    File        : GetCInvoiceBySupplierAndPaySelCode.p 
    Syntax      : 
    Author(s)   : zal
    Created     : Tue Jan 05 11:00:38 CST 2016
    Notes       : 
  ----------------------------------------------------------------------*/


USING Progress.Lang.*.
USING Progress.Lang.*.
USING OpenEdge.Core.Assert.
      
BLOCK-LEVEL ON ERROR UNDO, THROW.

 {proxy/bpaymentselection/apigetcinvoicebypayselandsupdef.i}
@Before.
PROCEDURE setUpBeforeProcedure:
/*------------------------------------------------------------------------------
        Purpose:                                                                      
        Notes:                                                                        
------------------------------------------------------------------------------*/

END PROCEDURE. 

@Setup.
PROCEDURE setUp:
/*------------------------------------------------------------------------------
        Purpose:                                                                      
        Notes:                                                                        
------------------------------------------------------------------------------*/

END PROCEDURE.  

@TearDown.
PROCEDURE tearDown:
/*------------------------------------------------------------------------------
        Purpose:                                                                      
        Notes:                                                                        
------------------------------------------------------------------------------*/

END PROCEDURE. 

@After.
PROCEDURE tearDownAfterProcedure: 
/*------------------------------------------------------------------------------
        Purpose:                                                                      
        Notes:                                                                        
------------------------------------------------------------------------------*/

END PROCEDURE. 

@Test.
PROCEDURE TestTotalCountOfInvoices:

    RUN facade/GetCInvoiceByPaySelCodeAndSuppFacade.p(INPUT "sel4-s4", input ? ,output table tCInvoiceList).
    define variable cnt as integer.
    for each tCInvoiceList:
        cnt = cnt + 1.      
    end.
    Assert:Equals(8,cnt).  
END PROCEDURE.

@Test.
PROCEDURE TestCountOfInvoicesFor10S1001:

    RUN facade/GetCInvoiceByPaySelCodeAndSuppFacade.p(INPUT "sel4-s4", input "10S1001" ,output table tCInvoiceList).
    define variable cnt as integer.
    for each tCInvoiceList :
        cnt = cnt + 1.      
    end.
    Assert:Equals(2,cnt).  
END PROCEDURE.

@Test.
PROCEDURE TestCountOfInvoicesFor10S1002:

    RUN facade/GetCInvoiceByPaySelCodeAndSuppFacade.p(INPUT "sel4-s4", input "10S1002" ,output table tCInvoiceList).
    define variable cnt as integer.
    for each tCInvoiceList :
        cnt = cnt + 1.      
    end.
    Assert:Equals(2,cnt).  
END PROCEDURE.


@Test.
PROCEDURE TestCountOfInvoicesFor10S1003:

    RUN facade/GetCInvoiceByPaySelCodeAndSuppFacade.p(INPUT "sel4-s4", input "10S1003" ,output table tCInvoiceList).
    define variable cnt as integer.
    for each tCInvoiceList :
        cnt = cnt + 1.      
    end.
    Assert:Equals(2,cnt).  
END PROCEDURE.


@Test.
PROCEDURE TestCountOfInvoicesFor10S1004:

    RUN facade/GetCInvoiceByPaySelCodeAndSuppFacade.p(INPUT "sel4-s4", input "10S1004" ,output table tCInvoiceList).
    define variable cnt as integer.
    for each tCInvoiceList :
        cnt = cnt + 1.      
    end.
    Assert:Equals(2,cnt).  
END PROCEDURE.


@Test.
PROCEDURE TestTotalPaymentAmountTC:

    RUN facade/GetCInvoiceByPaySelCodeAndSuppFacade.p(INPUT "sel4-s4", input ? ,output table tCInvoiceList).
    define variable cnt as decimal.
    for each tCInvoiceList :
        cnt = tdPaymentAmountTC + cnt.      
    end.
    Assert:Equals(86,cnt).  
END PROCEDURE.

@Test.
PROCEDURE TestTotalPaymentAmountBC:

    RUN facade/GetCInvoiceByPaySelCodeAndSuppFacade.p(INPUT "sel4-s4", input ? ,output table tCInvoiceList).
    define variable cnt as decimal.
    for each tCInvoiceList where :
        cnt = tdPaymentAmountBC + cnt.      
    end.
    Assert:Equals(95.48,cnt).  
END PROCEDURE.

@Test.
PROCEDURE TestTotalPaymentAmountBankCurr:

    RUN facade/GetCInvoiceByPaySelCodeAndSuppFacade.p(INPUT "sel4-s4", input ? ,output table tCInvoiceList).
    define variable cnt as decimal.
    for each tCInvoiceList :
        cnt = tdPaymentAmountBank + cnt.      
    end.
    Assert:Equals(95.48,cnt).  
END PROCEDURE.

@Test.
PROCEDURE TestTotalWHTTC:

    RUN facade/GetCInvoiceByPaySelCodeAndSuppFacade.p(INPUT "sel4-s4", input ? ,output table tCInvoiceList).
    define variable cnt as decimal.
    for each tCInvoiceList :
        cnt = tdCInvoiceWHTAmtTC + cnt.      
    end.
    Assert:Equals(0,cnt).  
END PROCEDURE.

@Test.
PROCEDURE TestTotalPaymentAmountBCFor10S1001:

    RUN facade/GetCInvoiceByPaySelCodeAndSuppFacade.p(INPUT "sel4-s4", input ? ,output table tCInvoiceList).
    define variable cnt as decimal.
    for each tCInvoiceList :
        cnt = tdPaymentAmountBC + cnt.      
    end.
    Assert:Equals(95.48,cnt).  
END PROCEDURE.

@Test.
PROCEDURE TestTotalPaymentAmountBCFor10S1002:

    RUN facade/GetCInvoiceByPaySelCodeAndSuppFacade.p(INPUT "sel4-s4", input "10S1002" ,output table tCInvoiceList).
    define variable cnt as decimal.
    for each tCInvoiceList :
        cnt = tdPaymentAmountBC + cnt.      
    end.
    Assert:Equals(95.48,cnt).  
END PROCEDURE.

@Test.
PROCEDURE TestTotalPaymentAmountBCFor10S1003:

    RUN facade/GetCInvoiceByPaySelCodeAndSuppFacade.p(INPUT "sel4-s4", input "10S1003" ,output table tCInvoiceList).
    define variable cnt as decimal.
    for each tCInvoiceList :
        cnt = tdPaymentAmountBC + cnt.      
    end.
    Assert:Equals(95.48,cnt).  
END PROCEDURE.



@Test.
PROCEDURE TestTotalPaymentAmountBCFor10S1004:

    RUN facade/GetCInvoiceByPaySelCodeAndSuppFacade.p(INPUT "sel4-s4", input "10S1004" ,output table tCInvoiceList).
    define variable cnt as decimal.
    for each tCInvoiceList :
        cnt = tdPaymentAmountBC + cnt.      
    end.
    Assert:Equals(95.48,cnt).  
END PROCEDURE.
