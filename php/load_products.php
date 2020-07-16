<?php
error_reporting(0);
include_once ("dbconnect.php");
$type = $_POST['type'];
$name = $_POST['name'];
$prid = $_POST['prid'];

if (isset($type)){
    if ($type == "Recent"){
        $sql = "SELECT * FROM product ORDER BY date DESC LIMIT 20";    
    }else{
        $sql = "SELECT * FROM product WHERE ptype = '$type'";    
    }
}else{
    $sql = "SELECT * FROM product ORDER BY date DESC LIMIT 20";    
}
if (isset($name)){
   $sql = "SELECT * FROM product WHERE pname LIKE  '%$name%'";
}

if (isset($prid)){
   $sql = "SELECT * FROM product WHERE pid = '$prid'";
}

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["products"] = array();
    while ($row = $result->fetch_assoc())
    {
        $productlist = array();
        $productlist["pid"] = $row["pid"];
        $productlist["pname"] = $row["pname"];
        $productlist["pprice"] = $row["pprice"];
        $productlist["pquantity"] = $row["pquantity"];
        $productlist["pweigth"] = $row["pweight"];
        $productlist["ptype"] = $row["ptype"];
        $productlist["date"] = $row["date"];
        $productlist["sold"] = $row["sold"];
        array_push($response["products"], $productlist);
    }
    echo json_encode($response);
}
else
{
    echo "nodata";
}
?>
