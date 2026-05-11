<?php
require_once "../config/cors.php";
require_once "../config/db.php";
 
$offer_id = $_GET["offer_id"] ?? null;
$db = new Database(); $conn = $db->getConnection();
 
$stmt = $conn->prepare(
    "SELECT tc.*, u.username, u.profile_pic
     FROM trade_comments tc
     JOIN users u ON tc.user_id = u.user_id
     WHERE tc.offer_id = :offer_id
     ORDER BY tc.created_at ASC"
);
$stmt->execute([":offer_id"=>$offer_id]);
$comments = $stmt->fetchAll(PDO::FETCH_ASSOC);
 
echo json_encode(["success"=>true,"comments"=>$comments]);
?>
