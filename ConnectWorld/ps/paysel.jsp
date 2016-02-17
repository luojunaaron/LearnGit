<html>
<link type="text/css"  rel="stylesheet" media="screen" />
<style type="text/css">
table {
	border: 0;
	font-family: arial;
	line-height: 20px;
	overflow: hidden;
	word-wrap: break-word;
	table-layout: fixed;
	font-size: 13px;
	margin-left:20px
}

tr:hover { background-color: #A4D3EE };
.aa {
	font-family: Verdana, Geneva, sans-serif;
	font-size: 12px;
	background-color: #ffffff;
}
</style>
<head>
<title>QAD Application</title>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7; IE=EmulateIE9">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1.0, user-scalable=no"/>
<link rel="stylesheet" type="text/css" href="styles.css" media="all" />
<link rel="stylesheet" type="text/css" href="demo.css" media="all" />
<script src="jquery.js"></script>
<!--  javaScript -->
<script>  


// show and hide sub menu
$(function(){
	$('nav ul li').hover(
		function () {
			//show its submenu
			$('ul', this).slideDown(150);
		}, 
		function () {
			//hide its submenu
			$('ul', this).slideUp(150);			
		}
	);
});
//end
</script>
<script type="text/javascript" src="jquery.js"></script>
<script src="http://code.jquery.com/ui/1.10.2/jquery-ui.js"></script>
<link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css" />
<script type="text/javascript">
			$(function() {
				$("#dialog").dialog({
					autoOpen: false,
                     					  show: {
        effect: "blind",
        duration: 2000
      },
     
					modal: true,
					height: 400,
					width:900,
					open: function(ev, ui){

					}
				})
			});


			function showinv(cc,sc)
			{
				$('#myIframe').attr('src','showinv.jsp?payselcode= ' + $("#payselcode")[0].value + '&suppliercode=' + sc) ;
				$('#dialog').dialog('open');

			}
		</script>
<div id="fdw">
  <nav>
    <ul>
      <li ><a href="#">Finance Approve<span class="arrow"></span></a>
        <ul style="display: none;" class="sub_menu">
          <li class="arrow_top"></li>
          <li><a class="subCurrent" href="paysel.jsp">Supplier Payment Selection Approve</a></li>
          <li><a href="tree.jsp">Supplier Payment Selection(Tree Mode)</a></li>
          <li><a href="graphic1.jsp">Supplier Payment Selection(Graphic Mode)</a></li>
          <li><a href="graphic2.jsp">Supplier Payment Selection(DrillDown)</a></li>
        </ul>
      </li>
      <li ><a href="index.html">Home<span class="arrow"></span></a>
        
      </li>
    </ul>
  </nav>
</div>
</head>

<body class="aa" background="bg1.bmp" >
<br>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Company Code:
<select name="companys">
  <option value="10usaco" selected="selected">10USACO</option>
  <option value="20">20USACO</option>
  <option value="30" >31NLCO</option>
  <option value="40">10Correction</option>
</select>
<br>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Selection Code:
<input id="payselcode" value="">
<button id="btnsearch">Search</button>
<button id="approveBtn">Approve</button>
<br>
<script type="text/javascript">
			$('#btnsearch').click(function () {
                $("#tab1").html("<table id=tab1 bgcolor=#F0F0F0>" 
				   + " <tr><td width=200 height=2 nowrap=nowrap ><strong>Supplier Code</strong></td> <td width=260 height=2 nowrap=nowrap><strong>Business Relation</strong></td>" 
					+ "<td width=460 height=2 nowrap=nowrap><strong>Business Relation Name</strong></td>"
					+ "<td width=260 height=2 nowrap=nowrap><strong>Bank Currency</strong></td><td width=260 height=2 nowrap=nowrap><strong>Subtotal of Amount BC</strong></td><td width=260 height=2 nowrap=nowrap>" 
					+ "<strong>Subtotal of Amount TC</strong></td></tr><table>");
					
				$.getJSON("http://167.3.129.101:8980/PaymentSelectionApp/rest/PaymentSelectionAppService/PaymentSelectionLevelII?payselCode=" + $("#payselcode")[0].value,
				function (data) {
					var k = 0;
					
					$.each(data.response.tpayselsuppliersubtotal.tPaySelSupplierSubTotal, function (i, item) {
						var c = "#ffffff";
                        k = k + 1;
						if (k % 2 == 0)
						{
						  c="#F0F0F0";
						}

						$("#tab1").append("<tr bgcolor=" + c +"><td> <img src=click.jpg width=11 height=11 id=img1" + item.tcCreditorCode + "_" + item.tcBankCurrencyCode + " onclick=showinv('"+item.tcBankCurrencyCode+"','" +                                          item.tcCreditorCode+ "')> "+ item.tcCreditorCode + " </td>  <td>" + item.tcBusinessRelationCode + " </td> <td>" +
						                  item.tcBusinessRelationName1 + " </td><td>"   + item.tcBankCurrencyCode + " </td> <td>" + item.tdPaySelTotalAmtBC + " </td> <td>" + item.tdPaySelTotalAmtTC +
						                  " </td></tr>");


					});
				});
			});
		</script> 
<script>	
		$('#approveBtn').click(function (data) {
			
		 $.ajax({
             type: "POST",
             url: "http://167.3.129.101:8980/PaymentSelectionApp/rest/PaymentSelectionAppService/PaymentSelection?toStatus=APPROVED&payselCode=" + $("#payselcode")[0].value,
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
<br>
<br>
<table id="tab1" bgcolor="#F0F0F0">
<tr>
  <td width="200" height="2" nowrap="nowrap" ><strong>Supplier Code</strong></td>
  <td width="260" height="2" nowrap="nowrap"><strong>Business Relation</strong></td>
  <td width="460" height="2" nowrap="nowrap"><strong>Business Relation Name</strong></td>
  <td width="260" height="2" nowrap="nowrap"><strong>Bank Currency</strong></td>
  <td width="260" height="2" nowrap="nowrap"><strong>Subtotal of Amount BC</strong></td>
  <td width="260" height="2" nowrap="nowrap"><strong>Subtotal of Amount TC</strong></td>
</tr>
<table>
</div>
<div id="invlist" z-index="90"> </div>
<div id="dialog">
  <iframe id="myIframe" src="" width = "900" height="400"></iframe>
</div>
</body>
</html>