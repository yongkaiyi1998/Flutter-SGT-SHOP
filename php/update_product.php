<?php
error_reporting(0);
include_once("dbconnect.php");
$prid = $_POST['prid'];
$prname = ucwords($_POST['prname']);
$quantity = $_POST['quantity'];
$price = $_POST['price'];
$type = $_POST['type'];
$weight = $_POST['weight'];
$encoded_string = base64_decode($encoded_string);
$path='../php/productimage/'.$prid.'.jpg';


        $sqlupdate = "UPDATE product SET pname = '$prname , pquantity = '$quantity' , pprice = '$price', pweight = '$weight', ptype = '$type' WHERE pid = '$prid'";
        if($conn->query($sqlupdate)===true){
            if(isset($encoded_string)){
                file_put_contents($path,$decoded_string);
            }
            
            echo "success";
        }else{
            echo "failed";
        }

$conn->close();
?>