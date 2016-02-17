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
}
tr:hover {
	background-color: #A4D3EE
}
;
.aa {
	font-family: Verdana, Geneva, sans-serif;
	font-size: 12px;
	background-color: #ffffff;
}
</style>
<head>
<title>QAD Application</title>
<script src="jquery.js"></script>
<!--  javaScript -->
<script src="https://code.highcharts.com/highcharts.js"></script>
<script src="https://code.highcharts.com/modules/exporting.js"></script>
<script src="http://code.jquery.com/ui/1.10.2/jquery-ui.js"></script>
<link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css" />
<link rel="stylesheet" type="text/css" href="styles.css" media="all" />
<link rel="stylesheet" type="text/css" href="demo.css" media="all" />
</head>

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
<body class="aa" background="bg1.bmp" >
<br>
<br>
<script>  
<!--  // building select nav for mobile width only -->
$(function(){
	// building select menu
	$('<select />').appendTo('nav');

	// building an option for select menu
	$('<option />', {
		'selected': 'selected',
		'value' : '',
		'text': 'Choise Page...'
	}).appendTo('nav select');

	$('nav ul li a').each(function(){
		var target = $(this);

		$('<option />', {
			'value' : target.attr('href'),
			'text': target.text()
		}).appendTo('nav select');

	});

	// on clicking on link
	$('nav select').on('change',function(){
		window.location = $(this).find('option:selected').val();
	});
});

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
<table border="0" width="1600px">
<tr>
<td width="20px"><a href="#"><img src="left.jpg"  alt="Previous" /></a></td>
<td><div id="container" style="min-width: 310px; max-width: 1600px; height: 700px; margin: 0 auto"></div></td>
<td  width="20px"><a href="graphic2.jsp"><img src="right.jpg"  alt="Next" /></a></td>
</table>
<script type="text/javascript">  
$('document').ready(function () {
	var myinvs = new Array(23);
	var myopenamts = new Array(23);
	var mypaidamts = new Array(23);
	var myallocamts = new Array(23);
	
	var k =0;
	$.ajaxSettings.async = false;
	
	$.getJSON("http://167.3.129.101:8980/PaymentSelectionApp/rest/PaymentSelectionAppService/PaymentSelection?payselCode=<%=request.getParameter("payselcode")%>" ,
	function (data) {	
		$.each(data.response.tCInvoiceList.tCInvoiceList, 
		function (i, item) {
			var d =  new Date(item.ttPostingDate);		
	        myinvs[k] = d.getFullYear() + "/SINV/" +  item.tiInvoiceSeq ;
			myopenamts[k] = item.tdPaymentAmountTC;
			mypaidamts[k] = Math.abs(item.tdOpenInvoiceAmountTC) - item.tdPaymentAmountTC;
            k = k + 1;
	     }); 			
	});
	$.ajaxSettings.async = true;
	

    $('#container').highcharts({
        chart: {
            type: 'column'
        },
        title: {
            text: 'Open Balance(TC) VS Payment Amount(TC)'
        },
        xAxis: {
            categories: myinvs
        },
        yAxis: {
            min: 0,
            title: {
                text: 'test1'
            },
            stackLabels: {
                enabled: true,
                style: {
                    fontWeight: 'bold',
                    color: (Highcharts.theme && Highcharts.theme.textColor) || 'gray'
                }
            }
        },
        legend: {
            align: 'right',
            x: -30,
            verticalAlign: 'top',
            y: 25,
            floating: true,
            backgroundColor: (Highcharts.theme && Highcharts.theme.background2) || 'white',
            borderColor: '#CCC',
            borderWidth: 1,
            shadow: false
        },
        tooltip: {
            headerFormat: '<b>{point.x}</b><br/>',
            pointFormat: '{series.name}: {point.y}<br/>Open Balance(TC): {point.stackTotal}'
        },
        plotOptions: {
            column: {
                stacking: 'normal',
                dataLabels: {
                    enabled: true,
                    color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'white',
                    style: {
                        textShadow: '0 0 3px black'
                    }
                }
            }
        },
        series: [
		{
            name: 'Payment Amount(TC)',
            data: myopenamts
        },  
		{
            name: 'Open Balance(TC)',
            data: mypaidamts
        }]
    });	
	
	
});

	
	
</script>
</body>
</html>