<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];
$prodid = $_POST['proid'];
$userquantity = $_POST['quantity'];


$sqlsearch = "SELECT * FROM cart WHERE email = '$email' AND prodid= '$prodid'";

$result = $conn->query($sqlsearch);//load database information to $result

if ($result->num_rows > 0) {
    while ($row = $result ->fetch_assoc()){
        $prquantity = $row["cquantity"];
    }
    $prquantity = $prquantity + $userquantity;
    $sqlinsert = "UPDATE cart SET cquantity = '$prquantity' WHERE prodid = '$prodid' AND email = '$email'";
    
}else{
    $sqlinsert = "INSERT INTO cart(email,prodid,cquantity,status) VALUES ('$email','$prodid',$userquantity,'nopaid')";
}

if ($conn->query($sqlinsert) === true)
{
    $sqlquantity = "SELECT * FROM cart WHERE email = '$email'";

    $resultq = $conn->query($sqlquantity);
    if ($resultq->num_rows > 0) {
        $quantity = 0;
        while ($row = $resultq ->fetch_assoc()){
            $quantity = $row["cquantity"] + $quantity;
        }
    }

    $quantity = $quantity;
    echo "success,".$quantity;
}
else
{
    echo "failed";
}

?>