<?php
session_start();
require_once "../config/cors.php";
require_once "../config/db.php";
 
if (!isset($_SESSION["user_id"])) { http_response_code(401); echo json_encode(["success"=>false]); exit(); }
 
$data    = json_decode(file_get_contents("php://input"), true);
$db = new Database(); $conn = $db->getConnection();
 
$stmt = $conn->prepare(
    "INSERT INTO direct_messages (convo_id, sender_id, content)
     VALUES (:convo_id, :sender_id, :content)"
);
$stmt->execute([
    ":convo_id"  => $data["convo_id"],
    ":sender_id" => $_SESSION["user_id"],
    ":content"   => trim($data["content"]),
]);
 
echo json_encode(["success"=>true,"dm_id"=>$conn->lastInsertId()]);
?>
