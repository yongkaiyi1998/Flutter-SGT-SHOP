<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];

if (isset($email)){
   $sql = "SELECT * FROM payment WHERE useremail = '$email'";
}

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["payment"] = array();
    while ($row = $result->fetch_assoc())
    {
        $paymentlist = array();
        $paymentlist["orderid"] = $row["orderid"];
        $paymentlist["billid"] = $row["billid"];
        $paymentlist["total"] = $row["total"];
        $paymentlist["date"] = $row["date"];
        array_push($response["payment"], $paymentlist);
    }
    echo json_encode($response);
}
else
{
    echo "nodata";
}
?>
