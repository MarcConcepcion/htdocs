<?php
session_start();
require_once "../config/cors.php";
require_once "../config/db.php";
 
if (!isset($_SESSION["user_id"])) { http_response_code(401); echo json_encode(["success"=>false]); exit(); }
 
$data = json_decode(file_get_contents("php://input"), true);
$db = new Database(); $conn = $db->getConnection();
 
$stmt = $conn->prepare(
    "INSERT INTO trade_comments (offer_id, user_id, content)
     VALUES (:offer_id, :user_id, :content)"
);
$stmt->execute([
    ":offer_id" => $data["offer_id"],
    ":user_id"  => $_SESSION["user_id"],
    ":content"  => trim($data["content"]),
]);
 
echo json_encode(["success"=>true,"comment_id"=>$conn->lastInsertId()]);
?>
