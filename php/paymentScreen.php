<?php
error_reporting(0);
include_once("dbconnect.php");
$userid = $_POST['userid'];
$amount = $_POST['amount'];
$orderid = $_POST['orderid'];
$newcr = $_POST['newcr'];
$receiptid ="storecredit";

 $sqlcart ="SELECT cart.prodid, cart.cquantity, product.pprice FROM cart INNER JOIN product ON cart.prodid = product.pid WHERE cart.email = '$userid'";
        $cartresult = $conn->query($sqlcart);
        if ($cartresult->num_rows > 0)
        {
        while ($row = $cartresult->fetch_assoc())
        {
            $prodid = $row["prodid"];
            $cq = $row["cquantity"]; //cart qty
            $pr = $row["pprice"];
            $sqlinsertcarthistory = "INSERT INTO carthistory(email,orderid,billid,prodid,cquantity,price) VALUES ('$userid','$orderid','$receiptid','$prodid','$cq','$pr')";
            $conn->query($sqlinsertcarthistory);
            
            $selectproduct = "SELECT * FROM product WHERE pid = '$prodid'";
            $productresult = $conn->query($selectproduct);
             if ($productresult->num_rows > 0){
                  while ($rowp = $productresult->fetch_assoc()){
                    $prquantity = $rowp["pquantity"];
                    $prevsold = $rowp["sold"];
                    $newquantity = $prquantity - $cq; 
                    $newsold = $prevsold + $cq;
                    $sqlupdatequantity = "UPDATE product SET pquantity = '$newquantity', sold = '$newsold' WHERE pid = '$prodid'";
                    $conn->query($sqlupdatequantity);
                  }
             }
        }
        
       $sqldeletecart = "DELETE FROM cart WHERE email = '$userid'";
       $sqlinsert = "INSERT INTO payment(orderid,billid,useremail,total) VALUES ('$orderid','$receiptid','$userid','$amount')";
        $sqlupdatecredit = "UPDATE user_info SET credit = '$newcr' WHERE email = '$userid'";
        
       $conn->query($sqldeletecart);
       $conn->query($sqlinsert);
       $conn->query($sqlupdatecredit);
       echo "success";
        }else{
            echo "failed";
        }

?>