<?php
$Fahrenheit = $_POST['Fahrenheit'];
$Celsius = $_POST['Celsius'];
$Fahrenheit_Celsius = ($Fahrenheit-32)/(5/9);
$Celsius_Fahrenheit = $Celsius*(5/9)+32;
?>

<!DOCTYPE html>
<html>
<head>
    <title>Temp conversion</title>
    <link rel="stylesheet" type="text/css" href="main.css" />
</head>
<body>
    <div id="content">
        <h1>Convert Fahrenheit and Celsius</h1>
		<label>Celsius:</label>
        <span><?php echo $Celsius; ?></span><br />

        <label>Fahrenheit:</label>
        <span><?php echo $Fahrenheit; ?></span><br />

        

        

        <label>Celsius to Fahrenheit:</label>
        <span><?php echo $Celsius_Fahrenheit; ?></span><br />
		
		<label>Fahrenheit to Celsius:</label>
        <span><?php echo $Fahrenheit_Celsius; ?></span><br />
        <p>&nbsp;</p>
    </div>
</body>
</html>