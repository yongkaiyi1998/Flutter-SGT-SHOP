<?php
error_reporting(0);
include_once("dbconnect.php");
$prodid = $_POST['prodid'];

    $sqldelete = "DELETE FROM product WHERE pid = '$prodid'";
    if($conn->query($sqldelete)===true){
        echo "success";
    }else{
        echo "failed";
    }
?>