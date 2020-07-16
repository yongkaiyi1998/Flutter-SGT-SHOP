<?php
error_reporting(0);
//include_once("dbconnect.php");

$email = $_GET['email']; //email from app
$mobile = $_GET['mobile']; //moblie from app
$name = $_GET['name']; //name from app
$amount = $_GET['amount']; //amount of credit from user
$csc = $_GET['csc'];//amount of credit user want buy

$newcr = $amount +  $csc;

$api_key = '266f47c4-8ee1-4c10-af71-1d3b94940d7b';
$collection_id = '4ewluhxl';
$host = 'https://billplz-staging.herokuapp.com/api/v3/bills';


    $data = array(
            'collection_id' => $collection_id,
            'email' => $email,
            'mobile' => $mobile,
            'name' => $name,
            'amount' => $amount * 100, // RM20
		    'description' => 'Payment for store credit ',
            'callback_url' => "http://yhkywy.com/sgtshop/return_url",
            'redirect_url' => "http://yhkywy.com/sgtshop/php/buycreditupdate.php?userid=$email&mobile=$mobile&amount=$amount&newcredit=$newcr" 
);


    $process = curl_init($host );
        curl_setopt($process, CURLOPT_HEADER, 0);
        curl_setopt($process, CURLOPT_USERPWD, $api_key . ":");
        curl_setopt($process, CURLOPT_TIMEOUT, 30);
        curl_setopt($process, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($process, CURLOPT_SSL_VERIFYHOST, 0);
        curl_setopt($process, CURLOPT_SSL_VERIFYPEER, 0);
        curl_setopt($process, CURLOPT_POSTFIELDS, http_build_query($data) ); 

$return = curl_exec($process);
curl_close($process);

$bill = json_decode($return, true);

//echo "<pre>".print_r($bill, true)."</pre>";
header("Location: {$bill['url']}");
?>