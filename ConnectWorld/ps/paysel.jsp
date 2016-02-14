<html>
	<link type="text/css"  rel="stylesheet" media="screen" />


	<style type="text/css">
		table {
			border: 0;
			font-family: arial;
			font-size:12px;
		}
		.aa {
			font-family: Verdana, Geneva, sans-serif;
			font-size: 13px;
			background-color: #ffffff;

		}
	</style>


	<head>
		<script type="text/javascript" src="jquery.js"></script>
		<script src="http://code.jquery.com/ui/1.10.2/jquery-ui.js"></script>
		<link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css" />

		<script type="text/javascript">
			$(function() {
				$("#dialog").dialog({
					autoOpen: false,
					modal: true,
					height: 600,
					width:1000,
					open: function(ev, ui){

					}
				})
			});


			function showinv(cc,sc)
			{
				/*
				$.getJSON("http://localhost:8980/PaymentSelectionApp/rest/PaymentSelectionAppService/PaymentSelection?currCode=" + cc + "&supplierCode="+ sc +"&payselCode=" + $("#payselcode")[0].value,
				function (data) {
				/*
				$.each(data.response.tCInvoiceList.tCInvoiceList, function (i, item) {

				$("#invlist").append("<div>" + item.tcDescription +  item.tcCinvoiceType + item.tcInvoiceCompanyCode
				+ item.tcCInvoiceCrDrAbbr + item.tdPaymentAmountBank +"</div>");



				});
				});
				*/
				
				$('#myIframe').attr('src','showinv.jsp?payselcode= ' + $("#payselcode")[0].value + '&suppliercode=' + sc) ;
				$('#dialog').dialog('open');

			}
		</script>
	</head>

	<body class="aa">
		<br>
		Company:
		<select name="companys">
			<option value="10usaco" selected="selected">10USACO</option>
			<option value="20">20USACO</option>
			<option value="30" >31NLCO</option>
			<option value="40">10Correction</option>
		</select>
		<br>
		Supplier Payment Selection Code:
		<input id="payselcode" value="113">
		<button id="btnsearch">Search</button>
        <button id="approveBtn">Approve</button>
        
		<br>
		<script type="text/javascript">
			$('#btnsearch').click(function () {

				$.getJSON("http://localhost:8980/PaymentSelectionApp/rest/PaymentSelectionAppService/PaymentSelectionLevelII?payselCode=" + $("#payselcode")[0].value,
				function (data) {
					$.each(data.response.tpayselsuppliersubtotal.tPaySelSupplierSubTotal, function (i, item) {

						$("#tab1").append("<tr><td> <img src=click.jpg width=11 height=11 id=img1" + item.tcCreditorCode + "_" + item.tcBankCurrencyCode + " onclick=showinv('"+item.tcBankCurrencyCode+"','" +                                          item.tcCreditorCode+ "')> "+ item.tcCreditorCode + " </td>  <td>" + item.tcBusinessRelationCode + " </td> <td>" +
						                  item.tcBusinessRelationName1 + " </td><td>"   + item.tcBankCurrencyCode + " </td> <td>" + item.tdPaySelTotalAmtBC + " </td> <td>" + item.tdPaySelTotalAmtTC +
						                  " </td></tr>");


					});
				});
			});
		</script>
        
        
        <script>	
		$('#approveBtn').click(function (data) {
			alert("start");
		 $.ajax({
             type: "POST",
             url: "http://localhost:8980/PaymentSelectionApp/rest/PaymentSelectionAppService/PaymentSelection?toStatus=APPROVED&payselCode=" + $("#payselcode")[0].value,
             data: "",
             contentType: "application/json; charset=utf-8",
             crossDomain: true,
             dataType: "json",
             success: function (data, status, jqXHR) {

                 alert($("#payselcode")[0].value + " has been approved successfully");// write success in " "
             },

             error: function (jqXHR, status) {
                 // error handler
                 console.log(jqXHR);
                 alert('fail' + status.code);
             }
          });
		});
		</script>
		<div id = "list"  z-index="1">
        <br><br>
			<table id="tab1" bgcolor="#F0F0F0">
				<tr>
					<td width="160" height="2" nowrap="nowrap" ><strong>Supplier Code</strong></td>
					<td width="260" height="2" nowrap="nowrap"><strong>Business Relation</strong></td>
					<td width="360" height="2" nowrap="nowrap"><strong>Business Relation Name</strong></td>
					<td width="160" height="2" nowrap="nowrap"><strong>Bank Currency</strong></td>
					<td width="260" height="2" nowrap="nowrap"><strong>Subtotal of Amount BC</strong></td>
					<td width="260" height="2" nowrap="nowrap"><strong>Subtotal of Amount TC</strong></td>
				</tr>
				<table>
				</div>

				<div id="invlist" z-index="90">

				</div>

				<div id="dialog">
					<iframe id="myIframe" src="" width = "1100" height="650"></iframe>
				</div>


			</body>

		</html>