<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Add Reservation</title>
</head>
<body>
<script src="https://apis.google.com/js/api.js"></script>
<script>
	window.onload = function(){
	   authenticate().then(loadClient).then(execute).then(homepage);
   }
	function homepage(){
		window.location.href = "HomePage.jsp";
	}
  function authenticate() {
    return gapi.auth2.getAuthInstance()
        .signIn({scope: "https://www.googleapis.com/auth/calendar https://www.googleapis.com/auth/calendar.events"})
        .then(function() { console.log("Sign-in successful"); },
              function(err) { console.error("Error signing in", err); });
  }
  function loadClient() {
    gapi.client.setApiKey("AIzaSyAcc-FoGTPO8ZS5lsojNF4NauFW2LuKlgE");
    return gapi.client.load("https://content.googleapis.com/discovery/v1/apis/calendar/v3/rest")
        .then(function() { console.log("GAPI client loaded for API"); },
              function(err) { console.error("Error loading GAPI client for API", err); });
  }
  // Make sure the client is loaded and sign-in is complete before calling this method.
  function execute() {
	 const queryString = window.location.search;
	 const urlParams = new URLSearchParams(queryString);
	 var date = urlParams.get('date');
	 var starttime = urlParams.get('time');
	 var notes = urlParams.get('notes');
	 
	 var timesplit = starttime.split(":");
	 var endhour = parseInt(timesplit[0], 10) + 2;	 
	 var endtime = endhour + ":" + timesplit[1];
    return gapi.client.calendar.events.insert({
       "calendarId": "primary",
      "resource": {
    	  "summary": "Restaurant Reservation",
    	  "description": notes,
    	  "start": {
    	    "dateTime": date + "T" + starttime + ":00",
    	    //"dateTime": "2020-04-27T16:00:00",
    	    "timeZone": "America/Los_Angeles"
    	  },
    	  "end": {
      	    "dateTime": date + "T" + endtime + ":00",
    	    //"dateTime": "2020-04-27T19:00:00",
    	    "timeZone": "America/Los_Angeles"
    	  }
    	}
    })
        .then(function(response) {
                // Handle the results here (response.result has the parsed body).
                console.log("Response", response);
              },
              function(err) { console.error("Execute error", err); });
  }
  gapi.load("client:auth2", function() {
    gapi.auth2.init({client_id: "650442592939-0hn6o4vfbkv7att0c9afsfo4dlp0tk98.apps.googleusercontent.com"});
  });
</script>
</body>
</html>