<?php
session_start();
require_once "../config/cors.php";
require_once "../config/db.php";
 
if (!isset($_SESSION["user_id"])) {
    http_response_code(401); echo json_encode(["success"=>false]); exit();
}
 
$data = json_decode(file_get_contents("php://input"), true);
 
if (empty($data["reported_id"]) || empty($data["reason"])) {
    http_response_code(400);
    echo json_encode(["success"=>false,"message"=>"reported_id and reason required."]);
    exit();
}
 
$db=$new Database(); $conn=$db->getConnection();
 
// Prevent self-report
if ((int)$data["reported_id"]===(int)$_SESSION["user_id"]) {
    http_response_code(400);
    echo json_encode(["success"=>false,"message"=>"Cannot report yourself."]);
    exit();
}
 
$stmt=$conn->prepare(
    "INSERT INTO reports(reporter_id,reported_id,item_id,offer_id,reason,details)
     VALUES(:reporter,:reported,:item,:offer,:reason,:details)"
);
$stmt->execute([
    ":reporter"=>$_SESSION["user_id"],
    ":reported"=>$data["reported_id"],
    ":item"    =>$data["item_id"]   ?? null,
    ":offer"   =>$data["offer_id"]  ?? null,
    ":reason"  =>$data["reason"],
    ":details" =>$data["details"]   ?? null,
]);
 
echo json_encode(["success"=>true,"report_id"=>$conn->lastInsertId()]);
?>
