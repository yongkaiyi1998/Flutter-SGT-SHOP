<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$phone = $_POST['phone'];
$name = $_POST['name'];
$oldpassword = $_POST["oldpassword"];
$newpassword = $_POST["newpassword"];

$oldpass = sha1($oldpassword);
$newpass = sha1($newpassword);

if(isset($newpassword)){
    $sqlupdatepassword = "UPDATE user_info SET password = '$newpass' WHERE email = '$email' ";
    if($conn->query($sqlupdatepassword)){
        echo 'success';
    }else{
        echo 'failed';
    }
}

if (isset($name)){
    $bigname = ucwords($name);
    $sqlupdatename = "UPDATE user_info SET username = '$bigname' WHERE email = '$email' ";
    if ($conn->query($sqlupdatename)){
        echo 'success';    
    }else{
        echo 'failed';
    }
}

if (isset($oldpassword) && isset($newpassword)){
    $sql = "SELECT * FROM user_info WHERE email = '$email' AND password = '$oldpass' ";
    $result = $conn->query($sql);
    
    if ($result->num_rows > 0) {
        $sqlupdatepass = "UPDATE user_info SET password = '$newpass' WHERE email = '$email' ";
        $conn->query($sqlupdatepass);
        echo 'success';
        
    }else{
        echo 'failed';
    }
}


if (isset($phone)){
    $sqlupdatepass = "UPDATE user_info SET phonenumber = '$phone' WHERE EMAIL = '$email' ";
    if($conn->query($sqlupdatepass)){
        echo 'success';    
    }else{
        echo 'failed';
    }
}

$conn->close();
?>