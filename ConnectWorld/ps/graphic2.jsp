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
<script src="https://code.highcharts.com/modules/data.js"></script>
<script src="https://code.highcharts.com/modules/drilldown.js"></script>

<script src="http://code.jquery.com/ui/1.10.2/jquery-ui.js"></script>
<link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css" />
<link rel="stylesheet" type="text/css" href="styles.css" media="all" />
<link rel="stylesheet" type="text/css" href="demo.css" media="all" />
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
<table border="0" width="1600px">
<tr>
<td width="20px"></td>
<td><div id="container" style="min-width: 1410px; height: 700px; margin: 0 auto"></div></div></td>
<td  width="20px"></td>
</table>
<script>
$(function () {
    // Create the chart
    $('#container').highcharts({
        chart: {
            type: 'column'
        },
        title: {
            text: 'Supplier Payment Selection:zaltest_2'
        },
        subtitle: {
            text: ''
        },
        xAxis: {
            type: 'category'
        },
        yAxis: {
            title: {
                text: 'Total percent Payment Amount'
            }

        },
        legend: {
            enabled: false
        },
        plotOptions: {
            series: {
                borderWidth: 0,
                dataLabels: {
                    enabled: true,
                    format: '{point.y:.1f}%'
                }
            }
        },

        tooltip: {
            headerFormat: '<span style="font-size:11px">{series.name}</span><br>',
            pointFormat: '<span style="color:{point.color}">{point.name}</span>: <b>{point.y:.2f}%</b> of total<br/>'
        },

        series: [{
            name: 'Brands',
            colorByPoint: true,
            data: [{
                name: '10S1001/USD',
                y: 56.33,
                drilldown: '10S1001/USD'
            }, {
                name: '10S1002/USD',
                y: 24.03,
                drilldown: '10S1002/USD'
            }, {
                name: '10S1003/USD',
                y: 10.38,
                drilldown: '10S1003/USD'
            }, {
                name: '10S1004/USD',
                y: 4.77,
                drilldown: '10S1004/USD'
            }, {
                name: '20S1001/USD',
                y: 0.91,
                drilldown: '20S1001/USD'
            }, {
                name: '30S1001/USD',
                y: 0.2,
                drilldown: null
            }]
        }],
        drilldown: {
            series: [{
                name: '10S1001/USD',
                id: '10S1001/USD',
                data: [
                    [
                        '2016/SINV/000000001',
                        24.13
                    ],
                    [
                        '2016/SINV/000000005',
                        17.2
                    ],
                    [
                        '2016/SINV/000000012',
                        8.11
                    ],
                    [
                        '2016/SINV/000000023',
                        5.33
                    ],
                    [
                        '2016/SINV/000000007',
                        1.06
                    ],
                    [
                        '2016/SINV/000000005',
                        0.5
                    ]
                ]
            }, {
                name: '10S1002/USD',
                id: '10S1002/USD',
                data: [
                    [
                        '2016/SINV/000000032',
                        12
                    ],
                    [
                        '2016/SINV/000000036',
                        6
                    ],
                    [
                        '2016/SINV/000000039',
                        4
                    ],
                    [
                        '2016/SINV/000000042',
                        2
                    ]
                ]
            }, {
                name: '10S1003/USD',
                id: '10S1003/USD',
                data: [
                    [
                        '2016/SINV/000000051',
                        5.76
                    ],
                    [
                        '2016/SINV/000000052',
                        2.32
                    ],
                    [
                        '2016/SINV/000000055',
                        1.31
                    ],
                    [
                        '2016/SINV/000000059',
                        1.01
                    ]
                ]
            }, {
                name: '10S1004/USD',
                id: '10S1004/USD',
                data: [
                    [
                        '2016/SINV/000000072',
                        3.40
                    ],
                    [
                        '2016/SINV/000000073',
                        0.77
                    ],
                    [
                        '2016/SINV/000000076',
                        0.42
                    ],
                    [
                        '2016/SINV/000000079',
                        0.17
                    ]
                ]
            }, {
                name: '30S1001/USD',
                id: '30S1001/USD',
                data: [
                    [
                        '2016/SINV/000000087',
                        0.34
                    ],
                    [
                        '2016/SINV/000000085',
                        0.24
                    ],
                    [
                        '2016/SINV/000000083',
                        0.17
                    ],
                    [
                        '2016/SINV/000000088',
                        0.16
                    ]
                ]
            }]
        }
    });
});
</script>
</body>
</html>