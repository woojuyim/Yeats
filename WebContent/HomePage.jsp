<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page import="java.util.ArrayList"%>
<%@page import="saffron.User"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Yeats HomePage</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" type="text/css"
	href="//fonts.googleapis.com/css?family=Lobster" />

<script>
	function isCorrect() {
		var error = false;
		document.getElementById("restError").innerHTML = "";
		document.getElementById("latError").innerHTML = "";
		document.getElementById("lonError").innerHTML = "";
		document.getElementById("opError").innerHTML = "";
		if (document.rest.latitude.value.length <= 0) {
			document.getElementById("latError").innerHTML = "<font color=\"red\">Please enter a latitude</font>";
			error = true;
		}
		if (document.rest.longitude.value.length <= 0) {
			document.getElementById("lonError").innerHTML = "<font color=\"red\">Please enter a longitude.</font>";
			error = true;
		}
		if (document.rest.options.value.length <= 0) {
			document.getElementById("opError").innerHTML = "<font color=\"red\">Please click an option.</font>";
			error = true;
		}
		return !error;
	}
	function initMap() {
		var coordinates = {
			lat : 34.02116,
			lng : -118.287132
		};
		var map = new google.maps.Map(document.getElementById('maps'), {
			zoom : 13,
			center : coordinates
		});
		var infoWindow = new google.maps.InfoWindow({
			content : 'Click the map to get coordinates',
			position : coordinates
		});
		infoWindow.open(map);

		//Click to get coordinates
		map.addListener('click', function(mapsMouseEvent) {
			infoWindow.close();

			var lat = mapsMouseEvent.latLng.lat();
			var lng = mapsMouseEvent.latLng.lng();
			document.getElementById("latitude").value = lat.toFixed(5);
			document.getElementById("longitude").value = lng.toFixed(5);

			infoWindow = new google.maps.InfoWindow({
				position : mapsMouseEvent.latLng
			});
			infoWindow.setContent(mapsMouseEvent.latLng.toString());
			infoWindow.open(map);
		});
	}
</script>
<style>
.topheaderleft {
	text-align: left;
	font-size: 3em;
	color: red;
	font-family: Lobster;
}

.topheaderright {
	float: right;
	font-size: 1.2em;
}

.margins {
	margin-top: 3em;
	margin-left: 3em;
	margin-right: 3em;
	margin-bottom: 3em;
	line-height: 150%;
	font-family: Helvetica;
}

img {
	border-radius: 15px;
	height: 95%;
	width: 95%;
}

#search {
	color: white;
	border: 1px;
	padding: 0.9rem 1.8rem;
	border-radius: 5px;
	background-color: #990000;
	cursor: pointer;
}

#restaurant {
	width: 34.5em;
	line-height: 2em;
	font-size: 1.2em;
}

.location {
	width: 19em;
	line-height: 2em;
	font-size: 1.2em;
}

#map {
	width: 20em;
	color: white;
	background-color: #6495ED;
	border: 1px;
	padding: 0.8rem 1.8rem;
	border-radius: 5px;
	cursor: pointer;
}

a, a:visited, a:hover, a:focus {
	text-decoration: none;
	color: #000;
}

::placeholder {
	padding-left: 10px;
}

.box {
	width: 50em;
	float: left;
	height: 20em;
}

.box2 {
	width: 20em;
	float: left;
	height: 20em;
}

#clear {
	clear: both;
}

.modal {
	display: none;
	position: fixed;
	padding-top: 100px;
	left: 0;
	top: 0;
	width: 100%;
	height: 100%;
	overflow: auto;
	background-color: rgba(0, 0, 0, 0.6);
}

.boxcontent {
	margin: auto;
	padding: 20px;
	width: 50em;
	height: 25em;
}
</style>
</head>
<body class="margins">
	<div>
		<span class="topheaderleft"><a href="HomePage.jsp"
			style="color: #990000">Yeats! </a></span>			
		<%
			User user = (User) request.getSession().getAttribute("logged");
		if (user == null) {
		%>
		<span class="topheaderright"> <a href="HomePage.jsp">Home</a>
			&emsp; <a href="Account.jsp">Login/Sign Up</a></span>
		<%
			} else {
		%>
		<span class="topheaderright"> <a href="HomePage.jsp">Home</a>
			&emsp; <a href="Favorites.jsp">Favorites</a> &emsp; <a
			href="LogoutServlet">Log Out</a>
		</span>
		<%
			}
		%>
		<div style="clear: both;"></div>
	</div>
	<br>
	<hr>
	<p>
		<img src="food.jpg" />
	</p>
	<div id="body">
		<form name="rest" action="SearchServlet" method="GET" onsubmit = "return isCorrect();">
			<div class="box">
				<input type="text" placeholder="Restaurant Name" id="restaurant"
					name="restaurant"> &emsp;
				<button type="submit" id="search">
					<i class="fa fa-search"></i>
				</button>
				<br> <span id="restError"></span> <br> <input
					type="number" placeholder="Latitude" step="0.00001"
					class="location" name="latitude" id="latitude"> &emsp; <input
					type="number" placeholder="Longitude" step="0.00001"
					class="location" name="longitude" id="longitude"> <br>
				<span id="latError"></span> <br> <span id="lonError"></span>
			</div>
			<div class="box2">
				<input type="radio" name="options" value="best_match" checked> Best
				Match &emsp; &emsp; &emsp;<input type="radio" name="options"
					value="review_count">Review Count <br> &emsp; <input
					type="radio" name="options" value="rating"> Rating &emsp;
				&emsp; &emsp; &emsp;<input type="radio" name="options"
					value="distance">Distance <br> <span id="opError"></span>
				<br>
				<button type="button" id="map">
					<i class="fa fa-map-marker"></i> Google Maps (Drop a pin!)
				</button>
				<div id="clear"></div>
			</div>
		</form>

		<div id="modalbox" class="modal">
			<div class="boxcontent" id="maps"></div>
		</div>

		<script>
			var modalbox = document.getElementById("modalbox");
			var mapbtn = document.getElementById("map");

			mapbtn.onclick = function() {
				modalbox.style.display = "block";
			}

			window.onclick = function(event) {
				if (event.target == modalbox) {
					modalbox.style.display = "none";
				}
			}
		</script>
	</div>
	<script
		src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAcc-FoGTPO8ZS5lsojNF4NauFW2LuKlgE&callback=initMap"
		type="text/javascript"></script>
</body>
</html>