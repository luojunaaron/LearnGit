 
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
/*------------------------------------------------------------------------------
        Purpose: Test the paysel code with same currency and supplier                                                                  
                 Also test the performance for loading 700 paysellines, 
                 it should be around 6 seconds.
        Notes:                                                                        
------------------------------------------------------------------------------*/
PROCEDURE TestPerformanceFor700Invs:
       DEFINE VARIABLE hashString AS CHAR.
       define variable st1 as integer.
       st1 = mtime.
       define variable exeTime as integer.
       RUN facade/GetPaySelHashByCodeFacade.p(INPUT "sel701", OUTPUT hashString). 
       exeTime = (mtime - st1) / 1000.
       Assert:Equals("7010_SUPBank1_1_701",hashString).
       Assert:isTrue(exeTime < 8).
END PROCEDURE. 


@Test.
/*------------------------------------------------------------------------------
        Purpose: Test the paysel code with same currency and supplier                                                                  
                 Also test the performance for loading 2100 paysellines, 
                 it should be around 13 seconds.
        Notes:                                                                        
------------------------------------------------------------------------------*/
PROCEDURE TestPerformanceFor2100Invs:
       DEFINE VARIABLE hashString AS CHAR.
       define variable st1 as integer.
       st1 = mtime.
       define variable exeTime as integer.
       RUN facade/GetPaySelHashByCodeFacade.p(INPUT "sel2100", OUTPUT hashString). 
       exeTime = (mtime - st1) / 1000.
       Assert:Equals("21000_SUPBank1_1_2100",hashString).
       Assert:isTrue(exeTime < 13).
END PROCEDURE. 

@Test.
/*Same Currency and Supplier*/
PROCEDURE TestGetHashStringSameCurrSupplier:
       DEFINE VARIABLE hashString AS CHAR.
       RUN facade/GetPaySelHashByCodeFacade.p(INPUT "sel701", OUTPUT hashString). 
       Assert:Equals("7010_SUPBank1_1_701",hashString).
END PROCEDURE. 


@Test.
PROCEDURE TestGetHashStringSameCurrSupplierWithInvCorr:
       DEFINE VARIABLE hashString AS CHAR.
       RUN facade/GetPaySelHashByCodeFacade.p(INPUT "zalps3", OUTPUT hashString). 
       Assert:Equals("9988.89_AU556509_1_2",hashString).
END PROCEDURE. 

@Test.
PROCEDURE TestGetHashStringDiffCurrDiffSupplier:
       DEFINE VARIABLE hashString AS CHAR.
       RUN facade/GetPaySelHashByCodeFacade.p(INPUT "sel4-s4", OUTPUT hashString). 
       Assert:Equals("95.48_SUPBank1_4_8",hashString).
END PROCEDURE. 

@Test.
PROCEDURE TestGetHashStringDiffCurrDiffSupplierDiffBankNumber:
       DEFINE VARIABLE hashString AS CHAR.
       RUN facade/GetPaySelHashByCodeFacade.p(INPUT "zalps10", OUTPUT hashString). 
       Assert:Equals("3758.07_9599,CA454509,L343523909,L445345789_4_4",hashString).
END PROCEDURE. 

@Test.
PROCEDURE TestGetHashStringSameCurrDiffInvType:
       DEFINE VARIABLE hashString AS CHAR.
       RUN facade/GetPaySelHashByCodeFacade.p(INPUT "sel2801", OUTPUT hashString). 
       Assert:Equals("672_AU556509_1_91",hashString).
END PROCEDURE. 


@Test.
PROCEDURE TestGetHashStringDiffCurrDiffInvType:
       DEFINE VARIABLE hashString AS CHAR.
       RUN facade/GetPaySelHashByCodeFacade.p(INPUT "sel2304", OUTPUT hashString). 
       Assert:Equals("120_TestBank01S_1_12",hashString).
END PROCEDURE. 


@Test.
PROCEDURE TestGetHashStringDiffCurr:
       DEFINE VARIABLE hashString AS CHAR.
       RUN facade/GetPaySelHashByCodeFacade.p(INPUT "sel24-01", OUTPUT hashString). 
       Assert:Equals("29_AU556509_1_3",hashString).
END PROCEDURE. 




