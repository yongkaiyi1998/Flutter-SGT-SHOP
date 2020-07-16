<?php
error_reporting(0);
include_once ("dbconnect.php");
$orderid = $_POST['orderid'];

$sql = "SELECT product.pid, product.pname, carthistory.price, product.pquantity, carthistory.cquantity FROM product INNER JOIN carthistory ON carthistory.prodid = product.pid WHERE carthistory.orderid = '$orderid'";

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["carthistory"] = array();
    while ($row = $result->fetch_assoc())
    {
        $cartlist = array();
        $cartlist["id"] = $row["pid"];
        $cartlist["name"] = $row["pname"];
        $cartlist["price"] = $row["price"];
        $cartlist["cquantity"] = $row["cquantity"];
        array_push($response["carthistory"], $cartlist);
    }
    echo json_encode($response);
}
else
{
    echo "Cart Empty";
}
?>
