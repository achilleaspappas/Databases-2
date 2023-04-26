<?php

$servername = "localhost";
$username = "user";
$password = "user";
$dbname = "travel_packets";

// Attempt to connect to SQL Database
$conn = new mysqli($servername, $username, $password, $dbname);

// Display error if connection is not established
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

// Set charset to UTF-8
mysqli_set_charset($conn, "utf8");

?>