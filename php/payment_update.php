<?php
error_reporting(0);
include_once("dbconnect.php");
$userid = $_GET['userid'];
$mobile = $_GET['mobile'];
$amount = $_GET['amount'];
$orderid = $_GET['orderid'];

$data = array(
    'id' =>  $_GET['billplz']['id'],
    'paid_at' => $_GET['billplz']['paid_at'] ,
    'paid' => $_GET['billplz']['paid'],
    'x_signature' => $_GET['billplz']['x_signature']
);

$paidstatus = $_GET['billplz']['paid'];
if ($paidstatus=="true"){
    $paidstatus = "Success";
}else{
    $paidstatus = "Failed";
}
$receiptid = $_GET['billplz']['id'];
$signing = '';
foreach ($data as $key => $value) {
    $signing.= 'billplz'.$key . $value;
    if ($key === 'paid') {
        break;
    } else {
        $signing .= '|';
    }
}
 
 
$signed= hash_hmac('sha256', $signing, 'S-3K-Ipcr4jjFwIXakbk9vDQ');
if ($signed === $data['x_signature']) {

    if ($paidstatus == "Success"){ //payment success
        
        $sqlcart = "SELECT cart.prodid, cart.cquantity, product.pprice FROM cart INNER JOIN product ON cart.prodid = product.pid WHERE cart.email = '$userid'";
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
                    $newquantity = $prquantity - $cq; //quantity in store - quantity ordered by user
                    $newsold = $prevsold + $cq;
                    $sqlupdatequantity = "UPDATE product SET pquantity = '$newquantity', sold = '$newsold' WHERE pid = '$prodid'";
                    $conn->query($sqlupdatequantity);
                  }
             }
        }
        
       $sqldeletecart = "DELETE FROM cart WHERE email = '$userid'";
       $sqlinsert = "INSERT INTO payment(orderid,billid,useremail,total) VALUES ('$orderid','$receiptid','$userid','$amount')";
       
       $conn->query($sqldeletecart);
       $conn->query($sqlinsert);
    }
        echo '<br><br><body><div><h2><br><br><center>-Receipt-</center></h1><table border=1 width=80% align=center><tr><td>Order id</td><td>'.$orderid.'</td></tr><tr><td>Receipt ID</td><td>'.$receiptid.'</td></tr><tr><td>Email to </td><td>'.$userid. ' </td></tr><td>Amount </td><td>RM '.$amount.'</td></tr><tr><td>Payment Status </td><td>'.$paidstatus.'</td></tr><tr><td>Date </td><td>'.date("d/m/Y").'</td></tr><tr><td>Time </td><td>'.date("h:i a").'</td></tr></table><br><p><center>Press back button to return to SGT Shop</center></p></div></body>';
    } 
        else 
    {
    echo 'Payment Failed!';
    }
}

?>