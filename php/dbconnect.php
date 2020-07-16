<?php
$servername = "localhost";
$username   = "yhkywyco_kaiyi";
$password   = "qw78e9as45d6zx12c3";
$dbname     = "yhkywyco_sgtshop";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>