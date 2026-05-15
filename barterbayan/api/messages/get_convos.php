<?php
session_start();
require_once "../config/cors.php";
require_once "../config/db.php";
 
if (!isset($_SESSION["user_id"])) {
    http_response_code(401);
    echo json_encode(["success"=>false]);
    exit();
}
 
$uid = (int)$_SESSION["user_id"];
$db = new Database(); $conn = $db->getConnection();
 
// Get all conversations for this user
$stmt = $conn->prepare(
    "SELECT c.convo_id,
            IF(c.user_a = :uid, c.user_b, c.user_a) AS other_id
     FROM conversations c
     WHERE c.user_a = :uid2 OR c.user_b = :uid3"
);
$stmt->execute([":uid"=>$uid, ":uid2"=>$uid, ":uid3"=>$uid]);
$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
 
$convos = [];
foreach ($rows as $row) {
    $other_id = $row["other_id"];
 
    // Get other user info
    $u = $conn->prepare("SELECT username, profile_pic FROM users WHERE user_id=:uid");
    $u->execute([":uid"=>$other_id]);
    $other = $u->fetch(PDO::FETCH_ASSOC);
 
    // Get last message
    $lm = $conn->prepare(
        "SELECT content FROM direct_messages WHERE convo_id=:cid ORDER BY sent_at DESC LIMIT 1"
    );
    $lm->execute([":cid"=>$row["convo_id"]]);
    $last = $lm->fetch(PDO::FETCH_ASSOC);
 
    // Count unread
    $ur = $conn->prepare(
        "SELECT COUNT(*) AS cnt FROM direct_messages
         WHERE convo_id=:cid AND sender_id!=:uid AND is_read=0"
    );
    $ur->execute([":cid"=>$row["convo_id"], ":uid"=>$uid]);
    $unread = $ur->fetch(PDO::FETCH_ASSOC)["cnt"];
 
    $convos[] = [
        "convo_id"   => $row["convo_id"],
        "other_id"   => $other_id,
        "other_name" => $other["username"] ?? "Unknown",
        "other_pic"  => $other["profile_pic"] ?? null,
        "last_msg"   => $last["content"] ?? null,
        "unread"     => (int)$unread,
    ];
}
 
echo json_encode(["success"=>true, "conversations"=>$convos]);
?>
