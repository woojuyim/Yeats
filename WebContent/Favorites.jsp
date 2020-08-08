<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page import="java.util.ArrayList"%>
<%@page import="saffron.Restaurant"%>
<%@page import="saffron.User"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Favorites</title>
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
	function sort() {

		var xhttp = new XMLHttpRequest();
		if (document.getElementById("AZ").selected) {
			xhttp.open("GET", "SortServlet?sort=AZ", true);
		} else if (document.getElementById("ZA").selected) {
			xhttp.open("GET", "SortServlet?sort=ZA", true);
		} else if (document.getElementById("highest").selected) {
			xhttp.open("GET", "SortServlet?sort=highest", true);
		} else if (document.getElementById("lowest").selected) {
			xhttp.open("GET", "SortServlet?sort=lowest", true);
		} else if (document.getElementById("mostrecent").selected) {
			xhttp.open("GET", "SortServlet?sort=mostrecent", true);
		} else if (document.getElementById("leastrecent").selected) {
			xhttp.open("GET", "SortServlet?sort=leastrecent", true);
		}

		//Output
		xhttp.onreadystatechange = function() {
			if (this.readyState == 4 && this.status == 200) {
				var text = this.responseText;
				var lines = text.split("\n");
				var index = 0;
				document.getElementById("done").innerHTML =
<%User user = (User) request.getSession().getAttribute("logged");
ArrayList<Restaurant> rest = user.getRestaurants();
if (rest != null) {
	for (int i = 0; i < rest.size(); ++i) {%>
	'<div class="each">' + '<div>'
						+ '<a id="pic" href="Details.jsp?id=' + lines[index++]
						+ '">' + '<img src=' + lines[index++]
						+ 'height=90% width=90% /></a>' + '</div>'
						+ '<div id="text">' + '<h1>' + lines[index++] + '</h1>'
						+ '<p>' + lines[index++] + '</p>' + '<p> '
						+ lines[index++] + '</p>' + '</div>'
						+ '<div id="clear"></div>' + '	</div>' +
<%}
				}%>
	'';
			}
		};
		xhttp.send();
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
	function signOut() {
		var auth2 = gapi.auth2.getAuthInstance();
		auth2.signOut().then(function() {
			console.log('User signed out.');
		});
	}
</script>
<style>
img {
	border-radius: 15px;
}

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
	width: 22em;
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
}

.box2 {
	width: 20em;
	float: left;
}

#results {
	float: left;
	padding-top: 3em;
}

#clear {
	clear: both;
}

.each {
	width: 70em;
	height: 30em;
}

#pic {
	padding-left: 3em;
	width: 25em;
	height: 25em;
	border-radius: 15px;
	float: left;
}

#text {
	padding-left: 2em;
	font-size: 1.2em;
	color: gray;
	width: 30em;
	float: left;
	height: 20em;
	word-break: break-all;
}

#sort {
	float: left;
	width: 8em;
	height: 3em;
	background-color: #990000;
	color: white;
	border-radius: 5px;
	font-size: 1em;
	cursor: pointer;
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

#icon {
	font-size: 1.3em;
	padding-top: 10px;
}
</style>
</head>
<body class="margins">
	<div>
		<span class="topheaderleft"><a href="HomePage.jsp"
			style="color: #990000">Yeats! </a></span>
		<%
			user = (User) request.getSession().getAttribute("logged");
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
	<br>
	<div id="body">
		<form name="rest" action="SearchServlet" method="get"
			onsubmit="return isCorrect();">
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
				<input type="radio" name="options" value="best_match" checked>
				Best Match &emsp; &emsp; &emsp;<input type="radio" name="options"
					value="review_count">Review Count <br> &emsp; <input
					type="radio" name="options" value="rating"> Rating &emsp;
				&emsp; &emsp; &emsp;<input type="radio" name="options"
					value="distance">Distance <br> <span id="opError"></span>
				<br>
				<button type="button" id="map"
					onclick="window.open('Maps.jsp', 'name', 'width:100,height=50');">
					<i class="fa fa-map-marker"></i> Google Maps (Drop a pin!)
				</button>
			</div>
			<div id="clear"></div>
		</form>
		<div style="width: 70em; height: 3em;">
			<h1 style="color: gray; float: left; width: 30em;"><%=user.getUsername()%>'s
				Favorite List
			</h1>
			<select id="sort" name="sort" onchange="sort()">
				<option value="" selected="selected" hidden="hidden">Sort
					by</option>
				<option id="AZ" value="AZ">A to Z</option>
				<option id="ZA" value="ZA">Z to A</option>
				<option id="highest" value="highest">Highest Rating</option>
				<option id="lowest" value="lowest">Lowest Rating</option>
				<option id="mostrecent" value="mostrecent">Most Recent</option>
				<option id="leastrecent" value="leastrecent">Least Recent</option>
			</select> <i class="fa fa-sort-amount-desc" id="icon" aria-hidden="true"></i>
		</div>
		<br>
		<hr>
		<br>
		<div id="done">
			<%
				rest = user.getRestaurants();
			if (rest != null) {
				for (Restaurant r : rest) {
			%>
			<div class="each">
				<div>
					<a id="pic" href="Details.jsp?id=<%=r.getId()%>"> <img
						src=<%=r.getImage_url()%> height=90% width=90% /></a>
				</div>
				<div id="text">
					<h1>
						<%=r.getName()%>
					</h1>
					<p>
						<%=r.getLocation()%>
					</p>
					<p>
						<%
							String url = r.getUrl();
						int index = url.indexOf("?");
						//Has ?
						if (index != -1) {
							String substring = url.substring(0, index);
							r.setUrl(substring);
						}
						%>
						<%=r.getUrl()%>
					</p>
				</div>

				<div id="clear"></div>
			</div>
			<%
				}
			}
			%>
		</div>
	</div>
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
	<script
		src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAcc-FoGTPO8ZS5lsojNF4NauFW2LuKlgE&callback=initMap"
		type="text/javascript"></script>
</body>
</html>