<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$password = sha1($_POST['password']);

$sql = "SELECT * FROM user_info WHERE email = '$email' AND password = '$password'";

$result = $conn->query($sql);
if ($result->num_rows > 0) {
    echo "success";
}else{
    echo "failed";
}