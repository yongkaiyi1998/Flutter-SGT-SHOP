<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$prodid = $_POST['prodid'];


if (isset($_POST['prodid'])){
    $sqldelete = "DELETE FROM cart WHERE email = '$email' AND prodid='$prodid'";
}else{
    $sqldelete = "DELETE FROM cart WHERE email = '$email'";
}
    
    if ($conn->query($sqldelete) === TRUE){
       echo "success";
    }else {
        echo "failed";
    }
?>