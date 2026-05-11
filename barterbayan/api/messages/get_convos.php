<?php
session_start();
require_once "../config/cors.php";
require_once "../config/db.php";
 
if (!isset($_SESSION["user_id"])) { http_response_code(401); echo json_encode(["success"=>false]); exit(); }
 
$uid = $_SESSION["user_id"];
$db = new Database(); $conn = $db->getConnection();
 
$stmt = $conn->prepare(
    "SELECT c.convo_id,
            CASE WHEN c.user_a=:uid THEN c.user_b ELSE c.user_a END AS other_id,
            u.username AS other_name, u.profile_pic AS other_pic,
            (SELECT content FROM direct_messages WHERE convo_id=c.convo_id ORDER BY sent_at DESC LIMIT 1) AS last_msg,
            (SELECT COUNT(*) FROM direct_messages WHERE convo_id=c.convo_id AND sender_id!=:uid2 AND is_read=0) AS unread
     FROM conversations c
     JOIN users u ON u.user_id = CASE WHEN c.user_a=:uid3 THEN c.user_b ELSE c.user_a END
     WHERE c.user_a=:uid4 OR c.user_b=:uid5
     ORDER BY c.created_at DESC"
);
$stmt->execute([":uid"=>$uid,":uid2"=>$uid,":uid3"=>$uid,":uid4"=>$uid,":uid5"=>$uid]);
$convos = $stmt->fetchAll(PDO::FETCH_ASSOC);
 
echo json_encode(["success"=>true,"conversations"=>$convos]);
?>
