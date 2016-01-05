USING OpenEdge.Core.Assert.
{test/payseldef.i}    

define input parameter payselcode as character no-undo.
define input parameter currencycode as character no-undo.
define input parameter creditorcode as character no-undo.
define output parameter table for tPaySelCreditorSubTotal.

define variable hPaySelBuffer as handle no-undo.
define variable hPaySelSupplierSubTotal as handle no-undo.
define variable hQry as handle no-undo.

{proxy/bpaymentselection/apigetpayselsuppliersubtotaldef.i}
assign icPaySelCode = payselcode
       icCurrencyCode = currencycode
       icCreditorCode = creditorcode.

{proxy/bpaymentselection/apigetpayselsuppliersubtotalrun.i}

hPaySelBuffer = dataset tPaySelSupplierSubTotal:handle.
hPaySelSupplierSubTotal = dataset tPaySelSupplierSubTotal:get-buffer-handle(1).
define variable vhInputQuery as handle.
define variable vhLocalBuffer as handle.

create buffer vhLocalBuffer for table "tPaySelCreditorSubTotal".
create query vhInputQuery.
vhInputQuery:forward-only = yes.
vhInputQuery:set-buffers(hPaySelSupplierSubTotal).
vhInputQuery:query-prepare ("for each " + hPaySelSupplierSubTotal:name).
vhInputQuery:query-open().
vhInputQuery:get-first().
   
do while not vhInputQuery:query-off-end:
    vhLocalBuffer:buffer-create().
    vhLocalBuffer:buffer-copy(hPaySelSupplierSubTotal).
    vhLocalBuffer:buffer-release().
    vhInputQuery:get-next().
end. /* do while not vhInputQuery:query-off-end: */
   
vhInputQuery:query-close().
delete object vhInputQuery.