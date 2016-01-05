/*
define input parameter icPaySelCode1 as character.
define output parameter oCHashString as longchar.
*/


{proxy/bpaymentselection/apigethashtotalbypayselcodedef.i}

icPaySelCode = "sel2100".
empty temp-table tFcMessages.     
opHashTotalString = "".

{proxy/bpaymentselection/apigethashtotalbypayselcoderun.i}


for each tFcMessages:
    message tFcMessages.tcFcMessage view-as alert-box.
end.

message string(opHashTotalString)  view-as alert-box.

