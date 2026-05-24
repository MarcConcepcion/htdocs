<?php
session_start();
require_once "../config/cors.php";
require_once "../config/db.php";
 
if (!isset($_SESSION["user_id"])) {
    http_response_code(401); echo json_encode(["success"=>false]); exit();
}
 
$db=$new Database(); $conn=$db->getConnection();
$uid=$_SESSION["user_id"];
 
$u=$conn->prepare("SELECT * FROM users WHERE user_id=:uid");
$u->execute([":uid"=>$uid]);
$user=$u->fetch(PDO::FETCH_ASSOC);
 
$checks = [
    "email_verified"    => (bool)$user["email_verified"],
    "has_name"          => !empty($user["first_name"]) && !empty($user["last_name"]),
    "has_phone"         => !empty($user["phone"]),
    "has_location"      => !empty($user["city"]),
    "has_profile_pic"   => !empty($user["profile_pic"]),
    "has_completed_trade"=> false,
];
 
$t=$conn->prepare(
    "SELECT COUNT(*) AS cnt FROM trade_offers
     WHERE (sender_id=:uid OR receiver_id=:uid2) AND status='accepted'"
);
$t->execute([":uid"=>$uid,":uid2"=>$uid]);
$checks["has_completed_trade"] = $t->fetch(PDO::FETCH_ASSOC)["cnt"] > 0;
 
$all_verified = !in_array(false,$checks,true);
 
// Auto-grant verified if all checks pass
if ($all_verified && !$user["is_verified"]) {
    $conn->prepare("UPDATE users SET is_verified=1 WHERE user_id=:uid")
         ->execute([":uid"=>$uid]);
}
 
echo json_encode(["success"=>true,"checks"=>$checks,"fully_verified"=>$all_verified]);
?>
