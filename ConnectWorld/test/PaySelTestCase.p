 
 /*------------------------------------------------------------------------
    File        : PaySelTestCase.p 
    Syntax      : 
    Author(s)   : zal
    Created     : Fri Dec 25 16:13:14 CST 2015
    Notes       : Hash Total=Payment Amt + Supplier Bank No.+ No. of suppliers 
                             + No. of invoices in total
Total of several fields in a file, including fields not normally used in calculations, 
such as account number.
Recalculated and compared with the original at various stages in the processing        
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING Progress.Lang.*.
USING OpenEdge.Core.Assert.
BLOCK-LEVEL ON ERROR UNDO, THROW.

{test/payseldef.i}

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
PROCEDURE TestGetPaySelHeaderSummary:
    empty temp-table tPaySelHeaderSummary.
    run facade/GetPaySelHeaderSummaryFacade.p(input "d6l1225a", output table tPaySelHeaderSummary).
    find first tPaySelHeaderSummary no-error.
    Assert:Equals("d6l1225a", tPaySelHeaderSummary.tcPaySelCode).
    Assert:Equals(1, tPaySelHeaderSummary.tiCInvCnt).
    Assert:Equals("CHECK-AP", tPaySelHeaderSummary.tcPayFormatTypeCode).
    Assert:Equals("CLOSED", tPaySelHeaderSummary.tcPaySelStatus).
    Assert:Equals("10USACO", tPaySelHeaderSummary.tcCompanyCode).
    Assert:Equals("FTD0001", tPaySelHeaderSummary.tcOwnBankNumber).
    Assert:Equals("1100FTD", tPaySelHeaderSummary.tcGLCode).
    Assert:Equals(-19, tPaySelHeaderSummary.tdBankBalanceBC).
    Assert:Equals("USD", tPaySelHeaderSummary.tcPaySelCurrencyCode).
    Assert:Equals(19, tPaySelHeaderSummary.tdPaySelTotalAmtBC).
END PROCEDURE.

@Test.
PROCEDURE TestGetPaySelHeaderSummaryDiffCurr:
    empty temp-table tPaySelHeaderSummary.
    run facade/GetPaySelHeaderSummaryFacade.p(input "sel4-s4", output table tPaySelHeaderSummary).
    find first tPaySelHeaderSummary no-error.
    Assert:Equals("sel4-s4", tPaySelHeaderSummary.tcPaySelCode).
    Assert:Equals(8, tPaySelHeaderSummary.tiCInvCnt).
    Assert:Equals("CHECK-AP", tPaySelHeaderSummary.tcPayFormatTypeCode).
    Assert:Equals("INITIAL", tPaySelHeaderSummary.tcPaySelStatus).
    Assert:Equals("10USACO", tPaySelHeaderSummary.tcCompanyCode).
    Assert:Equals("9933552a", tPaySelHeaderSummary.tcOwnBankNumber).
    Assert:Equals("bank01", tPaySelHeaderSummary.tcGLCode).
    Assert:Equals(42775.31, tPaySelHeaderSummary.tdBankBalanceBC).
    Assert:Equals("USD", tPaySelHeaderSummary.tcPaySelCurrencyCode).
    Assert:Equals(95.48, tPaySelHeaderSummary.tdPaySelTotalAmtBC).
END PROCEDURE.

@Test.
PROCEDURE TestGetPaySelHeaderSummaryLocalCurr:
    empty temp-table tPaySelHeaderSummary.
    run facade/GetPaySelHeaderSummaryFacade.p(input "sel0401", output table tPaySelHeaderSummary).
    find first tPaySelHeaderSummary no-error.
    Assert:Equals("sel0401", tPaySelHeaderSummary.tcPaySelCode).
    Assert:Equals(1, tPaySelHeaderSummary.tiCInvCnt).
    Assert:Equals("CHECK-AP", tPaySelHeaderSummary.tcPayFormatTypeCode).
    Assert:Equals("INITIAL", tPaySelHeaderSummary.tcPaySelStatus).
    Assert:Equals("10USACO", tPaySelHeaderSummary.tcCompanyCode).
    Assert:Equals("12345678", tPaySelHeaderSummary.tcOwnBankNumber).
    Assert:Equals("1190", tPaySelHeaderSummary.tcGLCode).
    Assert:Equals(-17247.7, tPaySelHeaderSummary.tdBankBalanceBC).
    Assert:Equals("USD", tPaySelHeaderSummary.tcPaySelCurrencyCode).
    Assert:Equals(100, tPaySelHeaderSummary.tdPaySelTotalAmtBC).
END PROCEDURE.


 
 
@Test.   
PROCEDURE TestGetPaySelSupplierSubTotalAllFor10S1001:
    empty temp-table tPaySelCreditorSubTotal.
    run facade/GetPaySelSupplierSubTotalFacade.p(input "sel4-s4", 
                                    input "",
                                    input "",
                                    output table tPaySelCreditorSubTotal).
                                       
    for each tPaySelCreditorSubTotal:
        if tPaySelCreditorSubTotal.tcCreditorCode = "10s1001"
        then do:
            Assert:Equals("sel4-s4", tPaySelCreditorSubTotal.tcPaySelCode).
            Assert:Equals("USD", tPaySelCreditorSubTotal.tcCurrencyCode).
            Assert:Equals("USD", tPaySelCreditorSubTotal.tcBankCurrencyCode).
            Assert:Equals("10s1001", tPaySelCreditorSubTotal.tcCreditorCode).
            Assert:Equals(20, tPaySelCreditorSubTotal.tdPaySelTotalAmtBC).
            Assert:Equals(20, tPaySelCreditorSubTotal.tdPaySelTotalAmtTC).
            Assert:Equals("10-s1001", tPaySelCreditorSubTotal.tcBusinessRelationCode).
            Assert:Equals("Taylor & Fulton Fruit Co.", tPaySelCreditorSubTotal.tcBusinessRelationName1).
            Assert:Equals("bank01", tPaySelCreditorSubTotal.tcGLCode).
        end.
        else if tPaySelCreditorSubTotal.tcCreditorCode = "10s1002"
        then do:
            if tPaySelCreditorSubTotal.tcCurrencyCode = "USD"
            then do:
                Assert:Equals("sel4-s4", tPaySelCreditorSubTotal.tcPaySelCode).
                Assert:Equals("USD", tPaySelCreditorSubTotal.tcCurrencyCode).
                Assert:Equals("USD", tPaySelCreditorSubTotal.tcBankCurrencyCode).
                Assert:Equals("10s1002", tPaySelCreditorSubTotal.tcCreditorCode).
                Assert:Equals(10, tPaySelCreditorSubTotal.tdPaySelTotalAmtBC).
                Assert:Equals(10, tPaySelCreditorSubTotal.tdPaySelTotalAmtTC).
                Assert:Equals("10-s1002", tPaySelCreditorSubTotal.tcBusinessRelationCode).
                Assert:Equals("Bridgeville Industries", tPaySelCreditorSubTotal.tcBusinessRelationName1).
                Assert:Equals("bank01", tPaySelCreditorSubTotal.tcGLCode).
            end.
            else if tPaySelCreditorSubTotal.tcCurrencyCode = "EUR"
            then do:
                Assert:Equals("sel4-s4", tPaySelCreditorSubTotal.tcPaySelCode).
                Assert:Equals("EUR", tPaySelCreditorSubTotal.tcCurrencyCode).
                Assert:Equals("USD", tPaySelCreditorSubTotal.tcBankCurrencyCode).
                Assert:Equals("10s1002", tPaySelCreditorSubTotal.tcCreditorCode).
                Assert:Equals(13.75, tPaySelCreditorSubTotal.tdPaySelTotalAmtBC).
                Assert:Equals(11, tPaySelCreditorSubTotal.tdPaySelTotalAmtTC).
                Assert:Equals("10-s1002", tPaySelCreditorSubTotal.tcBusinessRelationCode).
                Assert:Equals("Bridgeville Industries", tPaySelCreditorSubTotal.tcBusinessRelationName1).
                Assert:Equals("bank01", tPaySelCreditorSubTotal.tcGLCode).
            end.
        end.
        else if tPaySelCreditorSubTotal.tcCreditorCode = "10s1003"
        then do:
            if tPaySelCreditorSubTotal.tcCurrencyCode = "USD"
            then do:
                Assert:Equals("sel4-s4", tPaySelCreditorSubTotal.tcPaySelCode).
                Assert:Equals("USD", tPaySelCreditorSubTotal.tcCurrencyCode).
                Assert:Equals("USD", tPaySelCreditorSubTotal.tcBankCurrencyCode).
                Assert:Equals("10s1003", tPaySelCreditorSubTotal.tcCreditorCode).
                Assert:Equals(10, tPaySelCreditorSubTotal.tdPaySelTotalAmtBC).
                Assert:Equals(10, tPaySelCreditorSubTotal.tdPaySelTotalAmtTC).
                Assert:Equals("10-s1003", tPaySelCreditorSubTotal.tcBusinessRelationCode).
                Assert:Equals("Heron Surgical Supply", tPaySelCreditorSubTotal.tcBusinessRelationName1).
                Assert:Equals("bank01", tPaySelCreditorSubTotal.tcGLCode).
            end.
            else if tPaySelCreditorSubTotal.tcCurrencyCode = "GBP"
            
            then do:
                Assert:Equals("sel4-s4", tPaySelCreditorSubTotal.tcPaySelCode).
                Assert:Equals("GBP", tPaySelCreditorSubTotal.tcCurrencyCode).
                Assert:Equals("USD", tPaySelCreditorSubTotal.tcBankCurrencyCode).
                Assert:Equals("10s1003", tPaySelCreditorSubTotal.tcCreditorCode).
                Assert:Equals(18.73, tPaySelCreditorSubTotal.tdPaySelTotalAmtBC).
                Assert:Equals(12, tPaySelCreditorSubTotal.tdPaySelTotalAmtTC).
                Assert:Equals("10-s1003", tPaySelCreditorSubTotal.tcBusinessRelationCode).
                Assert:Equals("Heron Surgical Supply", tPaySelCreditorSubTotal.tcBusinessRelationName1).
                Assert:Equals("bank01", tPaySelCreditorSubTotal.tcGLCode).
            end.
        end.
        else if tPaySelCreditorSubTotal.tcCreditorCode = "10s1004"
        then do:
            Assert:Equals("sel4-s4", tPaySelCreditorSubTotal.tcPaySelCode).
            Assert:Equals("USD", tPaySelCreditorSubTotal.tcCurrencyCode).
            Assert:Equals("USD", tPaySelCreditorSubTotal.tcBankCurrencyCode).
            Assert:Equals("10s1004", tPaySelCreditorSubTotal.tcCreditorCode).
            Assert:Equals(23, tPaySelCreditorSubTotal.tdPaySelTotalAmtBC).
            Assert:Equals(23, tPaySelCreditorSubTotal.tdPaySelTotalAmtTC).
            Assert:Equals("10-s1004", tPaySelCreditorSubTotal.tcBusinessRelationCode).
            Assert:Equals("Sungro Chemicals", tPaySelCreditorSubTotal.tcBusinessRelationName1).
            Assert:Equals("bank01", tPaySelCreditorSubTotal.tcGLCode).
        end.
    end.
       
END PROCEDURE.


 
@Test.   
PROCEDURE TestGetPaySelSupplierSubTotalAllFor10S1002:
    empty temp-table tPaySelCreditorSubTotal.
    run facade/GetPaySelSupplierSubTotalFacade.p(input "sel4-s4", 
                                    input "",
                                    input "",
                                    output table tPaySelCreditorSubTotal).
                                       
    for each tPaySelCreditorSubTotal:
        if tPaySelCreditorSubTotal.tcCreditorCode = "10s1001"
        then do:
            Assert:Equals("sel4-s4", tPaySelCreditorSubTotal.tcPaySelCode).
            Assert:Equals("USD", tPaySelCreditorSubTotal.tcCurrencyCode).
            Assert:Equals("USD", tPaySelCreditorSubTotal.tcBankCurrencyCode).
            Assert:Equals("10s1001", tPaySelCreditorSubTotal.tcCreditorCode).
            Assert:Equals(20, tPaySelCreditorSubTotal.tdPaySelTotalAmtBC).
            Assert:Equals(20, tPaySelCreditorSubTotal.tdPaySelTotalAmtTC).
            Assert:Equals("10-s1001", tPaySelCreditorSubTotal.tcBusinessRelationCode).
            Assert:Equals("Taylor & Fulton Fruit Co.", tPaySelCreditorSubTotal.tcBusinessRelationName1).
            Assert:Equals("bank01", tPaySelCreditorSubTotal.tcGLCode).
        end.
        else if tPaySelCreditorSubTotal.tcCreditorCode = "10s1002"
        then do:
            if tPaySelCreditorSubTotal.tcCurrencyCode = "USD"
            then do:
                Assert:Equals("sel4-s4", tPaySelCreditorSubTotal.tcPaySelCode).
                Assert:Equals("USD", tPaySelCreditorSubTotal.tcCurrencyCode).
                Assert:Equals("USD", tPaySelCreditorSubTotal.tcBankCurrencyCode).
                Assert:Equals("10s1002", tPaySelCreditorSubTotal.tcCreditorCode).
                Assert:Equals(10, tPaySelCreditorSubTotal.tdPaySelTotalAmtBC).
                Assert:Equals(10, tPaySelCreditorSubTotal.tdPaySelTotalAmtTC).
                Assert:Equals("10-s1002", tPaySelCreditorSubTotal.tcBusinessRelationCode).
                Assert:Equals("Bridgeville Industries", tPaySelCreditorSubTotal.tcBusinessRelationName1).
                Assert:Equals("bank01", tPaySelCreditorSubTotal.tcGLCode).
            end.
            else if tPaySelCreditorSubTotal.tcCurrencyCode = "EUR"
            then do:
                Assert:Equals("sel4-s4", tPaySelCreditorSubTotal.tcPaySelCode).
                Assert:Equals("EUR", tPaySelCreditorSubTotal.tcCurrencyCode).
                Assert:Equals("USD", tPaySelCreditorSubTotal.tcBankCurrencyCode).
                Assert:Equals("10s1002", tPaySelCreditorSubTotal.tcCreditorCode).
                Assert:Equals(13.75, tPaySelCreditorSubTotal.tdPaySelTotalAmtBC).
                Assert:Equals(11, tPaySelCreditorSubTotal.tdPaySelTotalAmtTC).
                Assert:Equals("10-s1002", tPaySelCreditorSubTotal.tcBusinessRelationCode).
                Assert:Equals("Bridgeville Industries", tPaySelCreditorSubTotal.tcBusinessRelationName1).
                Assert:Equals("bank01", tPaySelCreditorSubTotal.tcGLCode).
            end.
        end.
        else if tPaySelCreditorSubTotal.tcCreditorCode = "10s1003"
        then do:
            if tPaySelCreditorSubTotal.tcCurrencyCode = "USD"
            then do:
                Assert:Equals("sel4-s4", tPaySelCreditorSubTotal.tcPaySelCode).
                Assert:Equals("USD", tPaySelCreditorSubTotal.tcCurrencyCode).
                Assert:Equals("USD", tPaySelCreditorSubTotal.tcBankCurrencyCode).
                Assert:Equals("10s1003", tPaySelCreditorSubTotal.tcCreditorCode).
                Assert:Equals(10, tPaySelCreditorSubTotal.tdPaySelTotalAmtBC).
                Assert:Equals(10, tPaySelCreditorSubTotal.tdPaySelTotalAmtTC).
                Assert:Equals("10-s1003", tPaySelCreditorSubTotal.tcBusinessRelationCode).
                Assert:Equals("Heron Surgical Supply", tPaySelCreditorSubTotal.tcBusinessRelationName1).
                Assert:Equals("bank01", tPaySelCreditorSubTotal.tcGLCode).
            end.
            else if tPaySelCreditorSubTotal.tcCurrencyCode = "GBP"
            
            then do:
                Assert:Equals("sel4-s4", tPaySelCreditorSubTotal.tcPaySelCode).
                Assert:Equals("GBP", tPaySelCreditorSubTotal.tcCurrencyCode).
                Assert:Equals("USD", tPaySelCreditorSubTotal.tcBankCurrencyCode).
                Assert:Equals("10s1003", tPaySelCreditorSubTotal.tcCreditorCode).
                Assert:Equals(18.73, tPaySelCreditorSubTotal.tdPaySelTotalAmtBC).
                Assert:Equals(12, tPaySelCreditorSubTotal.tdPaySelTotalAmtTC).
                Assert:Equals("10-s1003", tPaySelCreditorSubTotal.tcBusinessRelationCode).
                Assert:Equals("Heron Surgical Supply", tPaySelCreditorSubTotal.tcBusinessRelationName1).
                Assert:Equals("bank01", tPaySelCreditorSubTotal.tcGLCode).
            end.
        end.
        else if tPaySelCreditorSubTotal.tcCreditorCode = "10s1004"
        then do:
            Assert:Equals("sel4-s4", tPaySelCreditorSubTotal.tcPaySelCode).
            Assert:Equals("USD", tPaySelCreditorSubTotal.tcCurrencyCode).
            Assert:Equals("USD", tPaySelCreditorSubTotal.tcBankCurrencyCode).
            Assert:Equals("10s1004", tPaySelCreditorSubTotal.tcCreditorCode).
            Assert:Equals(23, tPaySelCreditorSubTotal.tdPaySelTotalAmtBC).
            Assert:Equals(23, tPaySelCreditorSubTotal.tdPaySelTotalAmtTC).
            Assert:Equals("10-s1004", tPaySelCreditorSubTotal.tcBusinessRelationCode).
            Assert:Equals("Sungro Chemicals", tPaySelCreditorSubTotal.tcBusinessRelationName1).
            Assert:Equals("bank01", tPaySelCreditorSubTotal.tcGLCode).
        end.
    end.
       
END PROCEDURE.

 
@Test.   
PROCEDURE TestGetPaySelSupplierSubTotalAllFor10S1003:
    empty temp-table tPaySelCreditorSubTotal.
    run facade/GetPaySelSupplierSubTotalFacade.p(input "sel4-s4", 
                                    input "",
                                    input "",
                                    output table tPaySelCreditorSubTotal).
                                       
    for each tPaySelCreditorSubTotal:
        if tPaySelCreditorSubTotal.tcCreditorCode = "10s1001"
        then do:
            Assert:Equals("sel4-s4", tPaySelCreditorSubTotal.tcPaySelCode).
            Assert:Equals("USD", tPaySelCreditorSubTotal.tcCurrencyCode).
            Assert:Equals("USD", tPaySelCreditorSubTotal.tcBankCurrencyCode).
            Assert:Equals("10s1001", tPaySelCreditorSubTotal.tcCreditorCode).
            Assert:Equals(20, tPaySelCreditorSubTotal.tdPaySelTotalAmtBC).
            Assert:Equals(20, tPaySelCreditorSubTotal.tdPaySelTotalAmtTC).
            Assert:Equals("10-s1001", tPaySelCreditorSubTotal.tcBusinessRelationCode).
            Assert:Equals("Taylor & Fulton Fruit Co.", tPaySelCreditorSubTotal.tcBusinessRelationName1).
            Assert:Equals("bank01", tPaySelCreditorSubTotal.tcGLCode).
        end.
        else if tPaySelCreditorSubTotal.tcCreditorCode = "10s1002"
        then do:
            if tPaySelCreditorSubTotal.tcCurrencyCode = "USD"
            then do:
                Assert:Equals("sel4-s4", tPaySelCreditorSubTotal.tcPaySelCode).
                Assert:Equals("USD", tPaySelCreditorSubTotal.tcCurrencyCode).
                Assert:Equals("USD", tPaySelCreditorSubTotal.tcBankCurrencyCode).
                Assert:Equals("10s1002", tPaySelCreditorSubTotal.tcCreditorCode).
                Assert:Equals(10, tPaySelCreditorSubTotal.tdPaySelTotalAmtBC).
                Assert:Equals(10, tPaySelCreditorSubTotal.tdPaySelTotalAmtTC).
                Assert:Equals("10-s1002", tPaySelCreditorSubTotal.tcBusinessRelationCode).
                Assert:Equals("Bridgeville Industries", tPaySelCreditorSubTotal.tcBusinessRelationName1).
                Assert:Equals("bank01", tPaySelCreditorSubTotal.tcGLCode).
            end.
            else if tPaySelCreditorSubTotal.tcCurrencyCode = "EUR"
            then do:
                Assert:Equals("sel4-s4", tPaySelCreditorSubTotal.tcPaySelCode).
                Assert:Equals("EUR", tPaySelCreditorSubTotal.tcCurrencyCode).
                Assert:Equals("USD", tPaySelCreditorSubTotal.tcBankCurrencyCode).
                Assert:Equals("10s1002", tPaySelCreditorSubTotal.tcCreditorCode).
                Assert:Equals(13.75, tPaySelCreditorSubTotal.tdPaySelTotalAmtBC).
                Assert:Equals(11, tPaySelCreditorSubTotal.tdPaySelTotalAmtTC).
                Assert:Equals("10-s1002", tPaySelCreditorSubTotal.tcBusinessRelationCode).
                Assert:Equals("Bridgeville Industries", tPaySelCreditorSubTotal.tcBusinessRelationName1).
                Assert:Equals("bank01", tPaySelCreditorSubTotal.tcGLCode).
            end.
        end.
        else if tPaySelCreditorSubTotal.tcCreditorCode = "10s1003"
        then do:
            if tPaySelCreditorSubTotal.tcCurrencyCode = "USD"
            then do:
                Assert:Equals("sel4-s4", tPaySelCreditorSubTotal.tcPaySelCode).
                Assert:Equals("USD", tPaySelCreditorSubTotal.tcCurrencyCode).
                Assert:Equals("USD", tPaySelCreditorSubTotal.tcBankCurrencyCode).
                Assert:Equals("10s1003", tPaySelCreditorSubTotal.tcCreditorCode).
                Assert:Equals(10, tPaySelCreditorSubTotal.tdPaySelTotalAmtBC).
                Assert:Equals(10, tPaySelCreditorSubTotal.tdPaySelTotalAmtTC).
                Assert:Equals("10-s1003", tPaySelCreditorSubTotal.tcBusinessRelationCode).
                Assert:Equals("Heron Surgical Supply", tPaySelCreditorSubTotal.tcBusinessRelationName1).
                Assert:Equals("bank01", tPaySelCreditorSubTotal.tcGLCode).
            end.
            else if tPaySelCreditorSubTotal.tcCurrencyCode = "GBP"
            
            then do:
                Assert:Equals("sel4-s4", tPaySelCreditorSubTotal.tcPaySelCode).
                Assert:Equals("GBP", tPaySelCreditorSubTotal.tcCurrencyCode).
                Assert:Equals("USD", tPaySelCreditorSubTotal.tcBankCurrencyCode).
                Assert:Equals("10s1003", tPaySelCreditorSubTotal.tcCreditorCode).
                Assert:Equals(18.73, tPaySelCreditorSubTotal.tdPaySelTotalAmtBC).
                Assert:Equals(12, tPaySelCreditorSubTotal.tdPaySelTotalAmtTC).
                Assert:Equals("10-s1003", tPaySelCreditorSubTotal.tcBusinessRelationCode).
                Assert:Equals("Heron Surgical Supply", tPaySelCreditorSubTotal.tcBusinessRelationName1).
                Assert:Equals("bank01", tPaySelCreditorSubTotal.tcGLCode).
            end.
        end.
        else if tPaySelCreditorSubTotal.tcCreditorCode = "10s1004"
        then do:
            Assert:Equals("sel4-s4", tPaySelCreditorSubTotal.tcPaySelCode).
            Assert:Equals("USD", tPaySelCreditorSubTotal.tcCurrencyCode).
            Assert:Equals("USD", tPaySelCreditorSubTotal.tcBankCurrencyCode).
            Assert:Equals("10s1004", tPaySelCreditorSubTotal.tcCreditorCode).
            Assert:Equals(23, tPaySelCreditorSubTotal.tdPaySelTotalAmtBC).
            Assert:Equals(23, tPaySelCreditorSubTotal.tdPaySelTotalAmtTC).
            Assert:Equals("10-s1004", tPaySelCreditorSubTotal.tcBusinessRelationCode).
            Assert:Equals("Sungro Chemicals", tPaySelCreditorSubTotal.tcBusinessRelationName1).
            Assert:Equals("bank01", tPaySelCreditorSubTotal.tcGLCode).
        end.
    end.
       
END PROCEDURE.

 
@Test.   
PROCEDURE TestGetPaySelSupplierSubTotalAllFor10S1004:
    empty temp-table tPaySelCreditorSubTotal.
    run facade/GetPaySelSupplierSubTotalFacade.p(input "sel4-s4", 
                                    input "",
                                    input "",
                                    output table tPaySelCreditorSubTotal).
                                       
    for each tPaySelCreditorSubTotal:
        if tPaySelCreditorSubTotal.tcCreditorCode = "10s1001"
        then do:
            Assert:Equals("sel4-s4", tPaySelCreditorSubTotal.tcPaySelCode).
            Assert:Equals("USD", tPaySelCreditorSubTotal.tcCurrencyCode).
            Assert:Equals("USD", tPaySelCreditorSubTotal.tcBankCurrencyCode).
            Assert:Equals("10s1001", tPaySelCreditorSubTotal.tcCreditorCode).
            Assert:Equals(20, tPaySelCreditorSubTotal.tdPaySelTotalAmtBC).
            Assert:Equals(20, tPaySelCreditorSubTotal.tdPaySelTotalAmtTC).
            Assert:Equals("10-s1001", tPaySelCreditorSubTotal.tcBusinessRelationCode).
            Assert:Equals("Taylor & Fulton Fruit Co.", tPaySelCreditorSubTotal.tcBusinessRelationName1).
            Assert:Equals("bank01", tPaySelCreditorSubTotal.tcGLCode).
        end.
        else if tPaySelCreditorSubTotal.tcCreditorCode = "10s1002"
        then do:
            if tPaySelCreditorSubTotal.tcCurrencyCode = "USD"
            then do:
                Assert:Equals("sel4-s4", tPaySelCreditorSubTotal.tcPaySelCode).
                Assert:Equals("USD", tPaySelCreditorSubTotal.tcCurrencyCode).
                Assert:Equals("USD", tPaySelCreditorSubTotal.tcBankCurrencyCode).
                Assert:Equals("10s1002", tPaySelCreditorSubTotal.tcCreditorCode).
                Assert:Equals(10, tPaySelCreditorSubTotal.tdPaySelTotalAmtBC).
                Assert:Equals(10, tPaySelCreditorSubTotal.tdPaySelTotalAmtTC).
                Assert:Equals("10-s1002", tPaySelCreditorSubTotal.tcBusinessRelationCode).
                Assert:Equals("Bridgeville Industries", tPaySelCreditorSubTotal.tcBusinessRelationName1).
                Assert:Equals("bank01", tPaySelCreditorSubTotal.tcGLCode).
            end.
            else if tPaySelCreditorSubTotal.tcCurrencyCode = "EUR"
            then do:
                Assert:Equals("sel4-s4", tPaySelCreditorSubTotal.tcPaySelCode).
                Assert:Equals("EUR", tPaySelCreditorSubTotal.tcCurrencyCode).
                Assert:Equals("USD", tPaySelCreditorSubTotal.tcBankCurrencyCode).
                Assert:Equals("10s1002", tPaySelCreditorSubTotal.tcCreditorCode).
                Assert:Equals(13.75, tPaySelCreditorSubTotal.tdPaySelTotalAmtBC).
                Assert:Equals(11, tPaySelCreditorSubTotal.tdPaySelTotalAmtTC).
                Assert:Equals("10-s1002", tPaySelCreditorSubTotal.tcBusinessRelationCode).
                Assert:Equals("Bridgeville Industries", tPaySelCreditorSubTotal.tcBusinessRelationName1).
                Assert:Equals("bank01", tPaySelCreditorSubTotal.tcGLCode).
            end.
        end.
        else if tPaySelCreditorSubTotal.tcCreditorCode = "10s1003"
        then do:
            if tPaySelCreditorSubTotal.tcCurrencyCode = "USD"
            then do:
                Assert:Equals("sel4-s4", tPaySelCreditorSubTotal.tcPaySelCode).
                Assert:Equals("USD", tPaySelCreditorSubTotal.tcCurrencyCode).
                Assert:Equals("USD", tPaySelCreditorSubTotal.tcBankCurrencyCode).
                Assert:Equals("10s1003", tPaySelCreditorSubTotal.tcCreditorCode).
                Assert:Equals(10, tPaySelCreditorSubTotal.tdPaySelTotalAmtBC).
                Assert:Equals(10, tPaySelCreditorSubTotal.tdPaySelTotalAmtTC).
                Assert:Equals("10-s1003", tPaySelCreditorSubTotal.tcBusinessRelationCode).
                Assert:Equals("Heron Surgical Supply", tPaySelCreditorSubTotal.tcBusinessRelationName1).
                Assert:Equals("bank01", tPaySelCreditorSubTotal.tcGLCode).
            end.
            else if tPaySelCreditorSubTotal.tcCurrencyCode = "GBP"
            
            then do:
                Assert:Equals("sel4-s4", tPaySelCreditorSubTotal.tcPaySelCode).
                Assert:Equals("GBP", tPaySelCreditorSubTotal.tcCurrencyCode).
                Assert:Equals("USD", tPaySelCreditorSubTotal.tcBankCurrencyCode).
                Assert:Equals("10s1003", tPaySelCreditorSubTotal.tcCreditorCode).
                Assert:Equals(18.73, tPaySelCreditorSubTotal.tdPaySelTotalAmtBC).
                Assert:Equals(12, tPaySelCreditorSubTotal.tdPaySelTotalAmtTC).
                Assert:Equals("10-s1003", tPaySelCreditorSubTotal.tcBusinessRelationCode).
                Assert:Equals("Heron Surgical Supply", tPaySelCreditorSubTotal.tcBusinessRelationName1).
                Assert:Equals("bank01", tPaySelCreditorSubTotal.tcGLCode).
            end.
        end.
        else if tPaySelCreditorSubTotal.tcCreditorCode = "10s1004"
        then do:
            Assert:Equals("sel4-s4", tPaySelCreditorSubTotal.tcPaySelCode).
            Assert:Equals("USD", tPaySelCreditorSubTotal.tcCurrencyCode).
            Assert:Equals("USD", tPaySelCreditorSubTotal.tcBankCurrencyCode).
            Assert:Equals("10s1004", tPaySelCreditorSubTotal.tcCreditorCode).
            Assert:Equals(23, tPaySelCreditorSubTotal.tdPaySelTotalAmtBC).
            Assert:Equals(23, tPaySelCreditorSubTotal.tdPaySelTotalAmtTC).
            Assert:Equals("10-s1004", tPaySelCreditorSubTotal.tcBusinessRelationCode).
            Assert:Equals("Sungro Chemicals", tPaySelCreditorSubTotal.tcBusinessRelationName1).
            Assert:Equals("bank01", tPaySelCreditorSubTotal.tcGLCode).
        end.
    end.
       
END PROCEDURE.

@Test.   
PROCEDURE TestGetPaySelSupplierSubTotalWithSupplier:
    empty temp-table tPaySelCreditorSubTotal.
    run facade/GetPaySelSupplierSubTotalFacade.p(input "sel4-s4", 
                                    input "",
                                    input "10s1001",
                                    output table tPaySelCreditorSubTotal).
    find first tPaySelCreditorSubTotal no-error.
    Assert:Equals("sel4-s4", tPaySelCreditorSubTotal.tcPaySelCode).
    Assert:Equals("USD", tPaySelCreditorSubTotal.tcCurrencyCode).
    Assert:Equals("USD", tPaySelCreditorSubTotal.tcBankCurrencyCode).
    Assert:Equals("10s1001", tPaySelCreditorSubTotal.tcCreditorCode).
    Assert:Equals(20, tPaySelCreditorSubTotal.tdPaySelTotalAmtBC).
    Assert:Equals(20, tPaySelCreditorSubTotal.tdPaySelTotalAmtTC).
    Assert:Equals("10-s1001", tPaySelCreditorSubTotal.tcBusinessRelationCode).
    Assert:Equals("Taylor & Fulton Fruit Co.", tPaySelCreditorSubTotal.tcBusinessRelationName1).
    Assert:Equals("bank01", tPaySelCreditorSubTotal.tcGLCode).                                 
END PROCEDURE.

@Test.   
PROCEDURE TestGetPaySelSupplierSubTotalWithSupplierExchEUR:
    empty temp-table tPaySelCreditorSubTotal.
    run facade/GetPaySelSupplierSubTotalFacade.p(input "sel4-s4", 
                                    input "",
                                    input "10s1002",
                                    output table tPaySelCreditorSubTotal).
    for each tPaySelCreditorSubTotal:
        if tPaySelCreditorSubTotal.tcCurrencyCode = "USD"
        then do:
            Assert:Equals("sel4-s4", tPaySelCreditorSubTotal.tcPaySelCode).
            Assert:Equals("USD", tPaySelCreditorSubTotal.tcCurrencyCode).
            Assert:Equals("USD", tPaySelCreditorSubTotal.tcBankCurrencyCode).
            Assert:Equals("10s1002", tPaySelCreditorSubTotal.tcCreditorCode).
            Assert:Equals(10, tPaySelCreditorSubTotal.tdPaySelTotalAmtBC).
            Assert:Equals(10, tPaySelCreditorSubTotal.tdPaySelTotalAmtTC).
            Assert:Equals("10-s1002", tPaySelCreditorSubTotal.tcBusinessRelationCode).
            Assert:Equals("Bridgeville Industries", tPaySelCreditorSubTotal.tcBusinessRelationName1).
            Assert:Equals("bank01", tPaySelCreditorSubTotal.tcGLCode).
        end.
        else if tPaySelCreditorSubTotal.tcCurrencyCode = "EUR"
        then do:
            Assert:Equals("sel4-s4", tPaySelCreditorSubTotal.tcPaySelCode).
            Assert:Equals("EUR", tPaySelCreditorSubTotal.tcCurrencyCode).
            Assert:Equals("USD", tPaySelCreditorSubTotal.tcBankCurrencyCode).
            Assert:Equals("10s1002", tPaySelCreditorSubTotal.tcCreditorCode).
            Assert:Equals(13.75, tPaySelCreditorSubTotal.tdPaySelTotalAmtBC).
            Assert:Equals(11, tPaySelCreditorSubTotal.tdPaySelTotalAmtTC).
            Assert:Equals("10-s1002", tPaySelCreditorSubTotal.tcBusinessRelationCode).
            Assert:Equals("Bridgeville Industries", tPaySelCreditorSubTotal.tcBusinessRelationName1).
            Assert:Equals("bank01", tPaySelCreditorSubTotal.tcGLCode).
        end.
     end.                            
END PROCEDURE.

@Test.   
PROCEDURE TestGetPaySelSupplierSubTotalWithSupplierExchUSD:
    empty temp-table tPaySelCreditorSubTotal.
    run facade/GetPaySelSupplierSubTotalFacade.p(input "sel4-s4", 
                                    input "",
                                    input "10s1002",
                                    output table tPaySelCreditorSubTotal).
    for each tPaySelCreditorSubTotal:
        if tPaySelCreditorSubTotal.tcCurrencyCode = "USD"
        then do:
            Assert:Equals("sel4-s4", tPaySelCreditorSubTotal.tcPaySelCode).
            Assert:Equals("USD", tPaySelCreditorSubTotal.tcCurrencyCode).
            Assert:Equals("USD", tPaySelCreditorSubTotal.tcBankCurrencyCode).
            Assert:Equals("10s1002", tPaySelCreditorSubTotal.tcCreditorCode).
            Assert:Equals(10, tPaySelCreditorSubTotal.tdPaySelTotalAmtBC).
            Assert:Equals(10, tPaySelCreditorSubTotal.tdPaySelTotalAmtTC).
            Assert:Equals("10-s1002", tPaySelCreditorSubTotal.tcBusinessRelationCode).
            Assert:Equals("Bridgeville Industries", tPaySelCreditorSubTotal.tcBusinessRelationName1).
            Assert:Equals("bank01", tPaySelCreditorSubTotal.tcGLCode).
        end.
        else if tPaySelCreditorSubTotal.tcCurrencyCode = "EUR"
        then do:
            Assert:Equals("sel4-s4", tPaySelCreditorSubTotal.tcPaySelCode).
            Assert:Equals("EUR", tPaySelCreditorSubTotal.tcCurrencyCode).
            Assert:Equals("USD", tPaySelCreditorSubTotal.tcBankCurrencyCode).
            Assert:Equals("10s1002", tPaySelCreditorSubTotal.tcCreditorCode).
            Assert:Equals(13.75, tPaySelCreditorSubTotal.tdPaySelTotalAmtBC).
            Assert:Equals(11, tPaySelCreditorSubTotal.tdPaySelTotalAmtTC).
            Assert:Equals("10-s1002", tPaySelCreditorSubTotal.tcBusinessRelationCode).
            Assert:Equals("Bridgeville Industries", tPaySelCreditorSubTotal.tcBusinessRelationName1).
            Assert:Equals("bank01", tPaySelCreditorSubTotal.tcGLCode).
        end.
     end.                            
END PROCEDURE.

@Test.   
PROCEDURE TestGetPaySelSupplierSubTotalWithCurrency:
    empty temp-table tPaySelCreditorSubTotal.
    run facade/GetPaySelSupplierSubTotalFacade.p(input "sel4-s4", 
                                    input "USD",
                                    input "",
                                    output table tPaySelCreditorSubTotal).
    for each tPaySelCreditorSubTotal:
        if tPaySelCreditorSubTotal.tcCreditorCode = "10s1001"
        then do:
            Assert:Equals("sel4-s4", tPaySelCreditorSubTotal.tcPaySelCode).
            Assert:Equals("USD", tPaySelCreditorSubTotal.tcCurrencyCode).
            Assert:Equals("USD", tPaySelCreditorSubTotal.tcBankCurrencyCode).
            Assert:Equals("10s1001", tPaySelCreditorSubTotal.tcCreditorCode).
            Assert:Equals(20, tPaySelCreditorSubTotal.tdPaySelTotalAmtBC).
            Assert:Equals(20, tPaySelCreditorSubTotal.tdPaySelTotalAmtTC).
            Assert:Equals("10-s1001", tPaySelCreditorSubTotal.tcBusinessRelationCode).
            Assert:Equals("Taylor & Fulton Fruit Co.", tPaySelCreditorSubTotal.tcBusinessRelationName1).
            Assert:Equals("bank01", tPaySelCreditorSubTotal.tcGLCode).
        end.
        else if tPaySelCreditorSubTotal.tcCreditor = "10s1002"
        then do:
            Assert:Equals("sel4-s4", tPaySelCreditorSubTotal.tcPaySelCode).
            Assert:Equals("USD", tPaySelCreditorSubTotal.tcCurrencyCode).
            Assert:Equals("USD", tPaySelCreditorSubTotal.tcBankCurrencyCode).
            Assert:Equals("10s1002", tPaySelCreditorSubTotal.tcCreditorCode).
            Assert:Equals(10, tPaySelCreditorSubTotal.tdPaySelTotalAmtBC).
            Assert:Equals(10, tPaySelCreditorSubTotal.tdPaySelTotalAmtTC).
            Assert:Equals("10-s1002", tPaySelCreditorSubTotal.tcBusinessRelationCode).
            Assert:Equals("Bridgeville Industries", tPaySelCreditorSubTotal.tcBusinessRelationName1).
            Assert:Equals("bank01", tPaySelCreditorSubTotal.tcGLCode).
        end.
        else if tPaySelCreditorSubTotal.tcCreditor = "10s1003"
        then do:
            Assert:Equals("sel4-s4", tPaySelCreditorSubTotal.tcPaySelCode).
            Assert:Equals("USD", tPaySelCreditorSubTotal.tcCurrencyCode).
            Assert:Equals("USD", tPaySelCreditorSubTotal.tcBankCurrencyCode).
            Assert:Equals("10s1003", tPaySelCreditorSubTotal.tcCreditorCode).
            Assert:Equals(10, tPaySelCreditorSubTotal.tdPaySelTotalAmtBC).
            Assert:Equals(10, tPaySelCreditorSubTotal.tdPaySelTotalAmtTC).
            Assert:Equals("10-s1003", tPaySelCreditorSubTotal.tcBusinessRelationCode).
            Assert:Equals("Heron Surgical Supply", tPaySelCreditorSubTotal.tcBusinessRelationName1).
            Assert:Equals("bank01", tPaySelCreditorSubTotal.tcGLCode).
        end.
        else if tPaySelCreditorSubTotal.tcCreditor = "10s1004"
        then do:
            Assert:Equals("sel4-s4", tPaySelCreditorSubTotal.tcPaySelCode).
            Assert:Equals("USD", tPaySelCreditorSubTotal.tcCurrencyCode).
            Assert:Equals("USD", tPaySelCreditorSubTotal.tcBankCurrencyCode).
            Assert:Equals("10s1004", tPaySelCreditorSubTotal.tcCreditorCode).
            Assert:Equals(23, tPaySelCreditorSubTotal.tdPaySelTotalAmtBC).
            Assert:Equals(23, tPaySelCreditorSubTotal.tdPaySelTotalAmtTC).
            Assert:Equals("10-s1004", tPaySelCreditorSubTotal.tcBusinessRelationCode).
            Assert:Equals("Sungro Chemicals", tPaySelCreditorSubTotal.tcBusinessRelationName1).
            Assert:Equals("bank01", tPaySelCreditorSubTotal.tcGLCode).
        end.
     end.             
 END PROCEDURE.    
 
 @Test. 
 PROCEDURE TestGetPaySelSupplierSubTotalLocalCurr:
    empty temp-table tPaySelCreditorSubTotal.
    run facade/GetPaySelSupplierSubTotalFacade.p(input "sel0401", 
                                    input "USD",
                                    input "10s1001",
                                    output table tPaySelCreditorSubTotal).
    find first tPaySelCreditorSubTotal no-error.
    Assert:Equals("sel0401", tPaySelCreditorSubTotal.tcPaySelCode).
    Assert:Equals("USD", tPaySelCreditorSubTotal.tcCurrencyCode).
    Assert:Equals("USD", tPaySelCreditorSubTotal.tcBankCurrencyCode).
    Assert:Equals("10s1001", tPaySelCreditorSubTotal.tcCreditorCode).
    Assert:Equals(100, tPaySelCreditorSubTotal.tdPaySelTotalAmtBC).
    Assert:Equals(100, tPaySelCreditorSubTotal.tdPaySelTotalAmtTC).
    Assert:Equals("10-s1001", tPaySelCreditorSubTotal.tcBusinessRelationCode).
    Assert:Equals("Taylor & Fulton Fruit Co.", tPaySelCreditorSubTotal.tcBusinessRelationName1).
    Assert:Equals("1190", tPaySelCreditorSubTotal.tcGLCode).                                
END PROCEDURE.   