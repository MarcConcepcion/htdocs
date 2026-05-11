<?php
require_once "../../config/cors.php";
require_once "../../config/db.php";
 
$user_id = $_GET["user_id"] ?? null;
if (!$user_id) { echo json_encode(["success"=>false]); exit(); }
 
$db = new Database(); $conn = $db->getConnection();
 
// Count reviews with rating <= 2
$neg = $conn->prepare("SELECT COUNT(*) AS cnt FROM reviews WHERE reviewee_id=:uid AND rating <= 2");
$neg->execute([":uid"=>$user_id]);
$count = (int)$neg->fetch(PDO::FETCH_ASSOC)["cnt"];
 
if ($count >= 10) {
    // BAN: mark as banned
    $conn->prepare("UPDATE users SET is_banned=1 WHERE user_id=:uid")->execute([":uid"=>$user_id]);
    echo json_encode(["success"=>true,"action"=>"banned","neg_count"=>$count]);
} elseif ($count >= 5) {
    // WARN
    $conn->prepare("UPDATE users SET is_warned=1, neg_review_count=:cnt WHERE user_id=:uid")
         ->execute([":cnt"=>$count,":uid"=>$user_id]);
    echo json_encode(["success"=>true,"action"=>"warned","neg_count"=>$count]);
} else {
    $conn->prepare("UPDATE users SET neg_review_count=:cnt WHERE user_id=:uid")
         ->execute([":cnt"=>$count,":uid"=>$user_id]);
    echo json_encode(["success"=>true,"action"=>"none","neg_count"=>$count]);
}
?>
