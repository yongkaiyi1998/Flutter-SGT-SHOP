<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$password = sha1($_POST['password']);

$sqlquantity = "SELECT * FROM cart WHERE email = '$email'";

$resultq = $conn->query($sqlquantity);
$quantity = 0;
if ($resultq->num_rows > 0) {
    while ($rowq = $resultq ->fetch_assoc()){
        $quantity = $rowq["cquantity"] + $quantity;
    }
}

$sql = "SELECT * FROM user_info WHERE email = '$email' AND password = '$password'";
$result = $conn->query($sql);
if ($result->num_rows > 0) {
    while ($row = $result ->fetch_assoc()){
        echo $data = "success,".$row["username"].",".$row["email"].",".$row["phonenumber"].",".$row["credit"].",".$row["datereg"].",".$quantity;
    }
}else{
    echo "failed";
}
