<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page import="java.util.ArrayList"%>
<%@page import="saffron.User"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Login/SignUp Page</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" type="text/css"
	href="//fonts.googleapis.com/css?family=Lobster" />
<meta name="google-signin-client_id"
	content="650442592939-0hn6o4vfbkv7att0c9afsfo4dlp0tk98.apps.googleusercontent.com">
<script src="https://apis.google.com/js/platform.js" async defer></script>

<script>
	function loginCorrect() {
		var error = false;
		document.getElementById("userError").innerHTML = "";
		document.getElementById("passError").innerHTML = "";
		if (document.loginform.loginusername.value.length <= 0) {
			document.getElementById("userError").innerHTML = "<font color=\"red\">Please enter a username.</font>";
			error = true;
		}
		if (document.loginform.loginpassword.value.length <= 0) {
			document.getElementById("passError").innerHTML = "<font color=\"red\">Please enter a password</font>";
			error = true;
		}
		return !error;
	}
	function createCorrect() {
		var error = false;
		document.getElementById("userError").innerHTML = "";
		document.getElementById("passError").innerHTML = "";
		document.getElementById("emailError").innerHTML = "";
		document.getElementById("confirmError").innerHTML = "";
		if (document.createform.signupusername.value.length <= 0) {
			document.getElementById("usercreateError").innerHTML = "<font color=\"red\">Please enter a username.</font>";
			error = true;
		}
		if (document.createform.signuppassword.value.length <= 0) {
			document.getElementById("passcreateError").innerHTML = "<font color=\"red\">Please enter a password</font>";
			error = true;
		}
		if (document.createform.email.value.length <= 0) {
			document.getElementById("emailError").innerHTML = "<font color=\"red\">Please enter an email.</font>";
			error = true;
		}
		if (!document.createform.email.value.includes("@")
				|| !document.createform.email.value.includes(".")) {
			document.getElementById("emailError").innerHTML = "<font color=\"red\">Please enter an email.</font>";
			error = true;
		}
		if (document.getElementById("checkbox").checked == false) {
			document.getElementById("checkError").innerHTML = "<font color=\"red\">Please check the box.</font>";
			error = true;
		}
		if (document.createform.confirmpassword.value.length <= 0) {
			document.getElementById("confirmError").innerHTML = "<font color=\"red\">Please confirm the password.</font>";
			error = true;
		}
		//Not the same confirm and password
		if (document.createform.confirmpassword.value != document.createform.signuppassword.value) {
			document.getElementById("confirmError").innerHTML = "<font color=\"red\">Password does not match</font>";
			error = true;
		}
		return !error;
	}
</script>

<style>
.topheaderleft {
	text-align: left;
	font-size: 3em;
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
	padding-bottom: 1px;
	line-height: 150%;
	font-family: Helvetica;
}

input[type=text], input[type=password], input[type=email] {
	width: 38em;
	line-height: 2em;
}

.login {
	width: 35em;
	float: left;
	height: 20em;
	font-family: Arial;
	color: gray;
}

.create {
	width: 30em;
	float: left;
	height: 20em;
	font-family: Arial;
	color: gray;
}

#sign {
	line-height: 3em;
	width: 38em;
	color: white;
	background-color: #990000;
	border: 1px;
	cursor: pointer;
}

.google {
	line-height: 3em;
	height: 2em;
	width: 38em;
	color: white;
	background-color: #6495ED;
	border: 1px;
}

a, a:visited, a:hover, a:focus {
	text-decoration: none;
	color: #000;
}

#create {
	line-height: 3em;
	color: white;
	background-color: #990000;
	border: 1px;
	width: 38em;
	margin-bottom: 10em;
	cursor: pointer;
}

#restaurant {
	width: 34.5em;
	line-height: 2em;
	font-size: 1.2em;
}

#location {
	width: 19em;
	line-height: 2em;
	font-size: 1.2em;
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
	<br>
	<br>
	<br>
	<form name="loginform" method="GET" action="LoginServlet"
		onsubmit="return loginCorrect();">
		<div class="login">
			<h1>Login</h1>
			<p>
				Username <br> <input type="text" name="loginusername">
				<span id="userError"></span>
			</p>
			<p>
				Password <br> <input type="password" name="loginpassword">
				<span id="passError"></span>
			</p>
			<%
				if (request.getAttribute("loginFailed") != null) {
			%>
			<p>
				<font color="red">Wrong username or password</font>
			</p>
			<%
				}
			%>
			<button type="submit" id="sign" onclick="">
				<i class="fa fa-sign-in"></i> Sign in
			</button>
			<hr
				style="width: 20em; margin-left: 6em; margin-top: 1em; margin-bottom: 1em; opacity: 0.3">
			<button type="button" id="my-signin2" style=""></button>
			<!--  <i class="fa fa-google"></i> Sign in with Google</button> -->
			<!-- 
			<div class="g-signin2" data-onsuccess="onSignIn"></div>-->


		</div>
	</form>
	<form name="createform" method="GET" action="CreateServlet"
		onsubmit="return createCorrect();">
		<div class="create">
			<h1>Sign Up</h1>
			<p>
				Email <br> <input type="email" name="email"> <span
					id="emailError"></span>
			</p>
			<p>
				Username <br> <input type="text" name="signupusername">
				<span id="usercreateError"></span>
			</p>
			<p>
				Password <br> <input type="password" name="signuppassword">
				<span id="passcreateError"></span>
			</p>
			<p>
				Confirm Password <br> <input type="password"
					name="confirmpassword"> <span id="confirmError"></span>
			</p>
			<p>
				<input type="checkbox" id="checkbox" name="checkbox"> I have
				read and agree to all terms and conditions of SalEats <span
					id="checkError"></span>
			</p>
			<%
				if (request.getAttribute("createFailed") != null) {
			%>
			<p>
				<font color="red">There is an account with that email or
					username</font>
			</p>
			<%
				}
			%>
			<button type="submit" id="create" onclick="">
				<i class="fa fa-user-plus"></i> Create Account
			</button>


		</div>
	</form>
	<br>
	<br>
	<br>

	<script>
		function onSuccess(googleUser) {
			var profile = googleUser.getBasicProfile();
			var name = profile.getName();
			var email = profile.getEmail();
			var id = profile.getId();
			console.log(id);
			var xhttp = new XMLHttpRequest();
			xhttp.open("GET", "GoogleServlet?name=" + name + "&id=" + id
					+ "&email=" + email, true);

			//Send to homepage after signed in
			xhttp.onreadystatechange = function() {
				if (this.readyState == 4 && this.status == 200) {
					window.location.href = "HomePage.jsp";
				}
			}
			xhttp.send();
		}
		function onFailure(error) {
			console.log(error);
		}
		function renderButton() {
			gapi.signin2.render('my-signin2', {
				'scope' : 'profile email',
				'width' : 500,
				'height' : 40,
				'longtitle' : true,
				'theme' : 'dark',
				'onsuccess' : onSuccess,
				'onfailure' : onFailure
			});
		}
	</script>

	<script async defer
		src="https://apis.google.com/js/platform.js?onload=renderButton"></script>

</body>
</html>