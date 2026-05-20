<?php
session_start();
require_once "../config/cors.php";
require_once "../config/db.php";
 
if (!isset($_SESSION["user_id"])) {
    http_response_code(401); echo json_encode(["success"=>false]); exit();
}
 
$item_id = $_GET["item_id"] ?? null;
$uid     = $_SESSION["user_id"];
$db = new Database(); $conn = $db->getConnection();
 
if ($item_id) {
    // Check if specific item is favorited
    $s = $conn->prepare("SELECT fav_id FROM favorites WHERE user_id=:uid AND item_id=:iid");
    $s->execute([":uid"=>$uid,":iid"=>$item_id]);
    echo json_encode(["success"=>true,"favorited"=>!!$s->fetch()]);
} else {
    // Return all favorited items for this user
    $s = $conn->prepare(
        "SELECT i.*, u.username, u.location FROM favorites f
         JOIN items i ON f.item_id=i.item_id
         JOIN users u ON i.user_id=u.user_id
         WHERE f.user_id=:uid ORDER BY f.created_at DESC"
    );
    $s->execute([":uid"=>$uid]);
    $items = $s->fetchAll(PDO::FETCH_ASSOC);
    foreach ($items as &$item) $item["images"] = json_decode($item["images"],true) ?? [];
    echo json_encode(["success"=>true,"items"=>$items]);
}
?>
