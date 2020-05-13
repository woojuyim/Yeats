<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page import="java.util.ArrayList"%>
<%@page import="saffron.Restaurant"%>
<%@page import="saffron.User"%>
<%@page import="saffron.Database"%>
<%@page import="saffron.YelpAPI"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Restaurant Details</title>
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
	function makeReservation() {
		var error = false;
		document.getElementById("dateError").innerHTML = "";
		document.getElementById("timeError").innerHTML = "";
		document.getElementById("noteError").innerHTML = "";
		if (document.getElementById("date").value.length <= 0) {
			document.getElementById("dateError").innerHTML = "<font color=\"red\">Please enter a date.</font>";
			error = true;
		}
		if (document.reservationform.time.value.length <= 0) {
			document.getElementById("timeError").innerHTML = "<font color=\"red\">Please enter a time</font>";
			error = true;
		}
		if (document.reservationform.notes.value.length <= 0) {
			document.getElementById("noteError").innerHTML = "<font color=\"red\">Please enter notes.</font>";
			error = true;
		}
		var splittime = document.reservationform.time.value.split(":");
		var hour = parseInt(splittime[0],10);
		if(hour <= 8 || hour >= 21){
			document.getElementById("timeError").innerHTML = "<font color=\"red\">Enter a time between 9am and 9pm</font>";
			error = true;
		}
		return !error;
	}
	function reveal(){
		document.getElementById("hideReservation").style.display = "block"; 
	}
	function validate() {
        var xhttp = new XMLHttpRequest();
        xhttp.open("GET", "validate.jsp?fname=" + document.myform.fname.value + "&lname=" + document.myform.lname.value, false);
        xhttp.send();
  	  	if (xhttp.responseText.trim().length > 0) {
          document.getElementById("formerror").innerHTML = xhttp.responseText;
          return false;
        }
        return true;
    }
	function favorite(){
		<%User user = (User) request.getSession().getAttribute("logged");
		String id = request.getParameter("id");
		Restaurant rest = YelpAPI.toAPI(id);
		request.getSession().setAttribute("restaurant", rest);
		
		//Logged in
		if (user != null) {%>
		var btn = document.getElementById("addFav");
		var xhttp = new XMLHttpRequest();
	    xhttp.open("GET", "FavoriteServlet?username=<%=user.getUsername()%>&favorite=<%=rest.getId()%>", true);
	    xhttp.send();
	    //Found
	    if(btn.innerHTML.indexOf("Add") != -1){
			btn.innerHTML = "<i class='fa fa-star'></i> Remove from Favorites";

		}
		else{
			btn.innerHTML = "<i class='fa fa-star'></i> Add to Favorites";
		}
		<%} else{ %>
		document.getElementById("favoriteError").innerHTML = "<font color=\"red\">You can only add to favorites while signed in</font>";
		<% }%>
		
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
	function reservationError(){
		document.getElementById("reservationError").innerHTML = "<font color=\"red\">You can only make reservations with an Google Account</font>";
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

::placeholder {
	padding-left: 10px;
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

.box {
	width: 50em;
	float: left;
}

.box2 {
	width: 20em;
	float: left;
}

#clear {
	clear: both;
}

.each {
	width: 70em;
	height: 20em;
}

#pic {
	padding-left: 3em;
	width: 20em;
	height: 20em;
	border-radius: 15px;
	float: left;
}

#text {
	padding-left: 3em;
	font-size: 1.2em;
	color: gray;
	width: 30em;
	float: left;
	word-break: break-all;
}

#addFav {
	text-align: center;
	line-height: 3em;
	width: 80em;
	color: black;
	background-color: #FFC72C;
	border: 1px;
	margin-bottom: 1em;
	font-size: 14px;
}

#addRes {
	text-align: center;
	line-height: 3em;
	width: 80em;
	color: white;
	background-color: #990000;
	border: 1px;
	margin-bottom: 3em;
	font-size: 14px;

}

#date {
	width: 38.75em;
	line-height: 3em;
}

#time {
	width: 38.75em;
	line-height: 3em;
}

#notes {
	width: 79.5em;
	height: 8em;
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
		<div style="clear: both"></div>
	</div>
	<br>
	<hr>
	<br>
	<div id="body">
		<form name="rest" action="SearchServlet" method="GET"
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
			</div>
		</form>
		<div id="clear"></div>

		<h1>
			<%=rest.getName()%>
		</h1>
		<br>
		<hr>
		<br>
		<div class="each">
			<div id="pic">
				<a href=<%=rest.getUrl()%>> <img src=<%=rest.getImage_url()%>
					height=90% width=90% /></a>
			</div>
			<div id="text">
				<p>
					Address:
					<%=rest.getLocation()%>
				</p>
				<p>
					Phone No:
					<%=rest.getPhone()%>
				</p>
				<p>
					Cuisine:
					<%=rest.getCategories().get(0).getTitle()%>
				</p>
				<p>
					Price:
					<%=rest.getPrice()%>
				</p>
				<p>
					Rating:
					<%
					for (int i = 0; i < (int) rest.getRating(); ++i) {
				%>
					<span class="fa fa-star checked"></span>
					<%
						}
					//Extra star
					if (rest.getRating() - (int) rest.getRating() != 0) {
					%>
					<span class="fa fa-star-half-o"></span>
					<%
						}
					for (int i = 4; i >= rest.getRating(); --i) {
					%>
					<span class="fa fa-star-o"></span>
					<%
						}
					%>



				</p>
			</div>

			<div id="clear"></div>
		</div>
		<button type="submit" id="addFav" onclick=favorite()>
			<%
				if (user != null) {
				if (!Database.isInDatabase(user.getUsername(), rest.getId())) {
			%>
			<i class='fa fa-star'></i> Add to Favorites
			<%
				}
			//Add to favorites
			else {
			%>
			<i class='fa fa-star'></i> Remove from Favorites
			<%
				}
			} else {
			%>
			<i class='fa fa-star'></i> Add to Favorites
			<%
				}
			%>
		</button>
		<span id= favoriteError> </span>
		<button type="submit" id="addRes" 
		<% 
		if(user!=null && user.getGoogleUser()){ %>
			onclick=reveal()>
		<% } else{ %>
			onclick=reservationError()>
		<%} %>
		
			<i class="fa fa-calendar-plus-o"></i> Add Reservation
		</button>
		<span id = "reservationError"> </span>
		<div id="hideReservation" style="display: none">

			<form name="reservationform" action="Calendar.jsp" method="GET">
				<div>
					<input type="date" placeholder="Date" id="date" name="date">
					&emsp; <input type="time" placeholder="Time" id="time" name="time">
					<br> <span id="dateError"></span> &emsp;&emsp; &emsp; &emsp;<span
						id="timeError"></span>
				</div>
				<textarea id="notes" placeholder="Reservation Notes" name="notes"></textarea>
				<br> <span id="noteError"></span>
				<button type="submit" id="addRes" onclick="return makeReservation();">
					<i class="fa fa-calendar-plus-o"></i> Submit Reservation
				</button>				
			</form>
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
		<script async defer src="https://apis.google.com/js/api.js"></script>

</body>
</html>