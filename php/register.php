<?php
error_reporting(0);
include_once ("dbconnect.php");
$name = $_POST['name'];
$email = $_POST['email'];
$password = sha1($_POST['password']);
$phone = $_POST['phone'];

$sqlinsert = "INSERT INTO user_info(username,email,password,phonenumber) VALUES ('$name','$email','$password','$phone')";

if ($conn->query($sqlinsert) === true)
{
    sendEmail($email);
    echo "success";
    
}
else
{
    echo "failed";
}

//http://yhkywy.com/sgtshop/php/register_user.php?name=yongkaiyi&email=cke0906@gmail.com&password=qw78e9as45d6zx12c3&phone=01112872896

function sendEmail($useremail) {
    $to      = $useremail; 
    $subject = 'Verification for SGT Shop'; 
    //$message = 'http://yhkywy.com/sgtshop/php/verify.php?email='.$useremail; 
    $message = 'You are complete register. Welcome to SGT Shop!'; 
    $headers = 'From: noreply@sgtshop.com' . "\r\n" . 
    'Reply-To: '.$useremail . "\r\n" . 
    'X-Mailer: PHP/' . phpversion(); 
    mail($to, $subject, $message, $headers); 
}
?>