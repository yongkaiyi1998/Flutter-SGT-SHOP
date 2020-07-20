<?php
error_reporting(0);
include_once ("dbconnect.php");
$prid = $_POST['prid'];
$prname  = ucwords($_POST['prname']);
$quantity  = $_POST['quantity'];
$price  = $_POST['price'];
$type  = $_POST['type'];
$weight  = $_POST['weight'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);
$sold = '0';
$path = '../php/productimage/'.$prid.'.jpg';

$sqlinsert = "INSERT INTO product(pid,pname,pprice,pquantity,ptype,pweight,sold) VALUES ('$prid','$prname','$price','$quantity','$type','$weight','$sold')";
$sqlsearch = "SELECT * FROM product WHERE pid='$prid'";
$resultsearch = $conn->query($sqlsearch);
if ($resultsearch->num_rows > 0)
{
    echo 'found';
}else{
if ($conn->query($sqlinsert) === true)
{
    if (file_put_contents($path, $decoded_string)){
        echo 'success';
    }else{
        echo 'failed';
    }
}
else
{
    echo "failed";
}    
}


?>