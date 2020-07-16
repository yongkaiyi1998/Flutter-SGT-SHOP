<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];
//$status = "notpaid";

if (isset($email)){
   $sql = "SELECT product.pid, product.pname, product.pprice, product.pquantity, product.pweight, cart.cquantity FROM product INNER JOIN cart ON cart.prodid = product.pid WHERE cart.email = '$email'";
}

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["cart"] = array();
    while ($row = $result->fetch_assoc())
    {
        $cartlist = array();
        $cartlist["pid"] = $row["pid"];
        $cartlist["pname"] = $row["pname"];
        $cartlist["pprice"] = $row["pprice"];
        $cartlist["pquantity"] = $row["pquantity"];
        $cartlist["cquantity"] = $row["cquantity"];
         $cartlist["pweight"] = $row["pweight"];
        $cartlist["yourprice"] = round(doubleval($row["pprice"])*(doubleval($row["cquantity"])),2)."";
        array_push($response["cart"], $cartlist);
    }
    echo json_encode($response);
}
else
{
    echo "Cart Empty";
}
?>
