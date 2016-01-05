define input  parameter payselcode as character no-undo.  
define output parameter hashString as character no-undo.

{proxy/bpaymentselection/apigethashtotalbypayselcodedef.i}
icPaySelCode = payselcode.
{proxy/bpaymentselection/apigethashtotalbypayselcoderun.i}
hashString  = opHashTotalString.