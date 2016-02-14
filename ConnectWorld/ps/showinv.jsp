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

	</head>

	<body class="aa">



		<br>

		<!--  ?payselCode=0111&supplierCode=&currCode=-->

		<script type="text/javascript">
			$('document').ready(function () {

  $.getJSON("http://localhost:8980/PaymentSelectionApp/rest/PaymentSelectionAppService/PaymentSelection?payselCode=" + <%=request.getParameter("payselcode")%> + "&supplierCode=" + '<%=request.getParameter("suppliercode")%>',
				function (data) {
					$.each(data.response.tCInvoiceList.tCInvoiceList, 
					function (i, item) {
						$("#tab11").append("<tr><td>" + item.tcInvoiceCurrencyCode + "</td>  <td>" + item.tcDescription + " </td> <td>" +
						item.ttPostingDate + " </td><td>"   + item.ttDueDate + " </td> <td>" + item.tcCInvoiceCrDrAbbr + " </td> <td>" + item.tdPaymentAmountTC +
						" </td></tr>");
					});
				});
			});

		</script>
		<div id = "list">
			<table id="tab11">
				<tr>
					<td width="130" height="2" nowrap="nowrap" ><strong>Currency Code</strong></td>
					<td width="300" height="2" nowrap="nowrap"><strong>Invoice Description</strong></td>
					<td width="120" height="2" nowrap="nowrap"><strong>Posting Date</strong></td>
					<td width="120" height="2" nowrap="nowrap"><strong>Due Date</strong></td>
				    <td width="100" height="2" nowrap="nowrap"><strong>CR/DR</strong></strong></td>
					<td width="200" height="2" nowrap="nowrap"><strong>Payment Amount TC</strong></td>
				</tr>
				<table>
				</div>

				<div id="invlist1">

				</div>


			</body>

		</html>