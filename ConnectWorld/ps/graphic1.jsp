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
<br><br>

<script type="text/javascript">  
$('#btnsearch').click(function () {
	var mysuppliers = new Array(23);
	var myopenamts = new Array(23);
	var mypaidamts = new Array(23);
	var myallocamts = new Array(23);
	var k =0;
	
	$('#a1').attr("href", "graphic1_1.jsp?payselcode=" + $("#payselcode")[0].value);
	$.ajaxSettings.async = false;
	$.getJSON("http://167.3.129.101:8980/PaymentSelectionApp/rest/PaymentSelectionAppService/PaymentSelectionLevelII?payselCode="  + $("#payselcode")[0].value,
	function (data) {	
		$.each(data.response.tpayselsuppliersubtotal.tPaySelSupplierSubTotal, 
		function (i, item) {
			
	        mysuppliers[k] = item.tcCreditorCode + "(" +  item.tcCurrencyCode  + ")" ;
			myopenamts[k] = item.tdPaySelTotalAmtBC;
			mypaidamts[k] = item.tdPaySelTotalAmtTC;
            k = k + 1;
	     }); 			
	});
	$.ajaxSettings.async = true;
	
    $('#container').highcharts({
        chart: {
            type: 'bar'
        },
        title: {
            text: 'Supplier Payment Selection:'+ $("#payselcode")[0].value
        },
        subtitle: {
            text: ''
        },
        xAxis: {
            categories: mysuppliers,
            title: {
                text: null
            }
        },
        yAxis: {
            min: 0,
            title: {
                text: 'Population (millions)',
                align: 'high'
            },
            labels: {
                overflow: 'justify'
            }
        },
        tooltip: {
            valueSuffix: ' millions'
        },
        plotOptions: {
            bar: {
                dataLabels: {
                    enabled: true
                }
            }
        },
        legend: {
            layout: 'vertical',
            align: 'right',
            verticalAlign: 'top',
            x: -40,
            y: 80,
            floating: true,
            borderWidth: 1,
            backgroundColor: ((Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF'),
            shadow: true
        },
        credits: {
            enabled: false
        },
        series: [
		{
            name: 'Payment Amount Total(BC)',
            data: myopenamts
                  },
		{
            name: 'Payment Amount Total(TC)',
            data: mypaidamts
                  },
				  
				  ]
    });
});

</script>
<table border="0" width="1600px">
<tr>
<td width="20px"><a href="#"><img src="left.jpg"  alt="Previous" /></a></td>
<td><div id="container" style="min-width: 310px; max-width: 1600px; height: 700px; margin: 0 auto"></div></td>
<td  width="20px"><a id="a1" href="graphic1_1.jsp"><img src="right.jpg"  alt="Next" /></a></td>
</table>
</body>
</html>