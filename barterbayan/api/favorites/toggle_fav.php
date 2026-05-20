<?php
session_start();
require_once "../config/cors.php";
require_once "../config/db.php";
 
if (!isset($_SESSION["user_id"])) {
    http_response_code(401); echo json_encode(["success"=>false]); exit();
}
 
$data    = json_decode(file_get_contents("php://input"), true);
$item_id = (int)($data["item_id"] ?? 0);
$uid     = (int)$_SESSION["user_id"];
 
$db = new Database(); $conn = $db->getConnection();
 
// Check if already favorited
$check = $conn->prepare("SELECT fav_id FROM favorites WHERE user_id=:uid AND item_id=:iid");
$check->execute([":uid"=>$uid, ":iid"=>$item_id]);
 
if ($check->fetch()) {
    // Remove
    $conn->prepare("DELETE FROM favorites WHERE user_id=:uid AND item_id=:iid")
         ->execute([":uid"=>$uid, ":iid"=>$item_id]);
    echo json_encode(["success"=>true, "favorited"=>false]);
} else {
    // Add
    $conn->prepare("INSERT INTO favorites (user_id,item_id) VALUES (:uid,:iid)")
         ->execute([":uid"=>$uid, ":iid"=>$item_id]);
    echo json_encode(["success"=>true, "favorited"=>true]);
}
?>
