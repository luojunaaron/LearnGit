<html>
<link type="text/css"  rel="stylesheet" media="screen" />
<link rel="stylesheet" type="text/css" href="tree.css" media="screen" />
<head>
<link type="text/css"  rel="stylesheet" media="screen" />
<link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css" />
<script type="text/javascript" src="jquery.js"></script>
<script type="text/javascript" src="tree.js"></script>
<title>QAD Application</title>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7; IE=EmulateIE9">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1.0, user-scalable=no"/>
<link rel="stylesheet" type="text/css" href="styles.css" media="all" />
<link rel="stylesheet" type="text/css" href="demo.css" media="all" />
<!-- jQuery lib from google server ===================== -->

<!--  javaScript -->
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
  <!--nav-->
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
<br>
<br>
</head>

<body class="aa" background="bg2.bmp" >
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Company Code:
<select name="companys">
  <option value="10usaco" selected="selected">10USACO</option>
  <option value="20">20USACO</option>
  <option value="30" >31NLCO</option>
  <option value="40">10Correction</option>
</select>
<br><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Supplier Payment Selection Code:
<input id="payselcode" value="">
<button id="btnsearch">Search</button>
<button id="approveBtn">Approve</button>
<br>
<br>
<div id="nestable">
  <ul class="dd-list">
  </ul>
</div>
<script>

function buildItem(item) {

  var html = "<li class='dd-item' data-id='" + item.id + "' id='" + item.id + "'>";
  html += "<div class='dd-handle'>" + item.id + "</div>";

  if (item.children) {

    html += "<ol class='dd-list'>";
    $.each(item.children, function(index, sub) {
      html += buildItem(sub);
    });
    html += "</ol>";

  }

  html += "</li>";

  return html;
}

$('#btnsearch').click(function () {
var obj = "";

$.ajaxSettings.async = false;
$.getJSON("http://167.3.129.101:8980/PaymentSelectionApp/rest/PaymentSelectionAppService/PaymentSelectionTree?payselCode=" + $("#payselcode")[0].value ,
				function (data) {
  $.each(data.response, function(i, item) {
    obj = item.replace("/","");
		
  });
});
$.ajaxSettings.async = true;

$.each(JSON.parse(obj), function(index, item) {

  $('#nestable ul').append(buildItem(item));

});

$('#nestable').nestable('collapseAll');
 $('.dd').nestable('collapseAll');
});
	
	</script> 
<br>
</body>
</html>