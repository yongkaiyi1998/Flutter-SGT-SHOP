<?php
error_reporting(0);
include_once ("dbconnect.php");
$name = $_POST['name'];
$email = $_POST['email'];
$password = sha1($_POST['password']);
$phone = $_POST['phone'];

$sqlinsert = "INSERT INTO user_info(username,email,password,phonenumber,credit,verify) VALUES ('$name','$email','$password','$phone','0','1')";

if ($conn->query($sqlinsert) === true)
{
    sendEmail($email);
    echo "success";
    
}
else
{
    echo "failed";
}


function sendEmail($useremail) {
    $to      = $useremail; 
    $subject = 'Verification for SGT'; 
    $message = 'You are completed your register. WELCOME TO SGTSHOP!!!'; 
    $headers = 'From: noreply@sgtshop.com' . "\r\n" . 
    'Reply-To: '.$useremail . "\r\n" . 
    'X-Mailer: PHP/' . phpversion(); 
    mail($to, $subject, $message, $headers); 
}

?>
