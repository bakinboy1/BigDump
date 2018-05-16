<!DOCTYPE html >
<html lang="en" >
	<head>
	<title>login</title>
	<link rel="stylesheet" href="https://sslab-seren888.c9users.io/WEBDEV/event.css" type="text/css" />
  	</head>
	<body>
	<div id="wrapper">
	
	<main>
	
	<h2>Here is the information you entered:</h2><br>
<br>
<br>
<table>
<?php 


    foreach ($_POST as $key => $value) {
        echo "<tr>";
        echo "<td>";
        echo $key;
        echo "</td>";
        echo "<td>";
        echo $value;
        echo "</td>";
        echo "</tr>";
    }


?>
</table>
<br>
<br>
<br>
<form action="#">
<input type="button" value = "Back" onclick="javascript:history.go(-1)" />
</form>
</main>
</div>
</body>
</html>