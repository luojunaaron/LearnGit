USING OpenEdge.Core.Assert.
{test/payseldef.i}   

define input parameter payselcode as character no-undo.
define output parameter table for tPaySelHeaderSummary.

define variable hPaySelBuffer as handle no-undo.
define variable hPaySelHeader as handle no-undo.
define variable hQry as handle no-undo.

{proxy/bpaymentselection/apigetpayselheadersummarydef.i}
icPaySelCode = payselcode.
{proxy/bpaymentselection/apigetpayselheadersummaryrun.i}

hPaySelBuffer = dataset tPaySelHeader:handle.
hPaySelHeader = dataset tPaySelHeader:get-buffer-handle(1).
define variable vhInputQuery as handle.
define variable vhLocalBuffer as handle.

create buffer vhLocalBuffer for table "tPaySelHeaderSummary".
create query vhInputQuery.
vhInputQuery:forward-only = yes.
vhInputQuery:set-buffers(hPaySelHeader).
vhInputQuery:query-prepare ("for each " + hPaySelHeader:name).
vhInputQuery:query-open().
vhInputQuery:get-first().

   
do while not vhInputQuery:query-off-end:
    vhLocalBuffer:buffer-create().
    vhLocalBuffer:buffer-copy(hPaySelHeader).
    vhLocalBuffer:buffer-release().
    vhInputQuery:get-next().
end. /* do while not vhInputQuery:query-off-end: */
   
vhInputQuery:query-close().
delete object vhInputQuery.






