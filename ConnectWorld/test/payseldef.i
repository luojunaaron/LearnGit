define temp-table tPaySelHeaderSummary no-undo
       field tcPaySelStatus as character
       field tcPaySelCode as character
       field tcGLCode as character
       field tcCompanyCode as character
       field tiGL_ID as int64
       field tcOwnBankNumber as character
       field tcPaySelCurrencyCode as character
       field tiCInvCnt as integer
       field tdBankBalanceBC as decimal
       field tcPayFormatTypeCode as character
       field tdPaySelTotalAmtBC as decimal.
   
define temp-table tPaySelCreditorSubTotal no-undo
       field tcBusinessRelationCode as character
       field tcBusinessRelationName1 as character
       field tcGLCode as character
       field tcCreditorCode as character
       field tcCurrencyCode as character
       field tcBankCurrencyCode as character
       field tdPaySelTotalAmtBC as decimal
       field tdPaySelTotalAmtTC as decimal
       field tcPaySelCode as character.