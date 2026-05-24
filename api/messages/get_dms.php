<?php
session_start();
require_once "../config/cors.php";
require_once "../config/db.php";
 
if (!isset($_SESSION["user_id"])) { http_response_code(401); echo json_encode(["success"=>false]); exit(); }
 
$convo_id = $_GET["convo_id"] ?? null;
$db = new Database(); $conn = $db->getConnection();
 
$stmt = $conn->prepare(
    "SELECT d.*, u.username AS sender_name, u.profile_pic AS sender_pic
     FROM direct_messages d
     JOIN users u ON d.sender_id = u.user_id
     WHERE d.convo_id = :convo_id
     ORDER BY d.sent_at ASC"
);
$stmt->execute([":convo_id"=>$convo_id]);
$dms = $stmt->fetchAll(PDO::FETCH_ASSOC);
 
// Mark messages as read
$mark = $conn->prepare(
    "UPDATE direct_messages SET is_read=1
     WHERE convo_id=:convo_id AND sender_id != :uid"
);
$mark->execute([":convo_id"=>$convo_id,":uid"=>$_SESSION["user_id"]]);
 
echo json_encode(["success"=>true,"messages"=>$dms]);
?>
