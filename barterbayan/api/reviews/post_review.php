<?php
session_start();
require_once "../../config/cors.php";
require_once "../../config/db.php";
 
if (!isset($_SESSION["user_id"])) {
    http_response_code(401);
    echo json_encode(["success"=>false,"message"=>"Not authenticated."]);
    exit();
}
 
$data = json_decode(file_get_contents("php://input"), true);
 
if (empty($data["reviewee_id"]) || empty($data["rating"]) || empty($data["comment"])) {
    http_response_code(400);
    echo json_encode(["success"=>false,"message"=>"All fields required."]);
    exit();
}
 
$rating = (int)$data["rating"];
if ($rating < 1 || $rating > 5) {
    http_response_code(400);
    echo json_encode(["success"=>false,"message"=>"Rating must be 1-5."]);
    exit();
}
 
// Prevent reviewing yourself
if ((int)$data["reviewee_id"] === (int)$_SESSION["user_id"]) {
    http_response_code(400);
    echo json_encode(["success"=>false,"message"=>"You cannot review yourself."]);
    exit();
}
 
$db = new Database(); $conn = $db->getConnection();
 
// Duplicate check — per offer_id if provided
if (!empty($data["offer_id"])) {
    $dup = $conn->prepare(
        "SELECT review_id FROM reviews
         WHERE reviewer_id=:rid AND offer_id=:oid LIMIT 1"
    );
    $dup->execute([":rid"=>$_SESSION["user_id"],":oid"=>$data["offer_id"]]);
    if ($dup->fetch()) {
        http_response_code(409);
        echo json_encode(["success"=>false,"message"=>"You already reviewed this trade."]);
        exit();
    }
}
 
$stmt = $conn->prepare(
    "INSERT INTO reviews (reviewer_id,reviewee_id,offer_id,rating,comment)
     VALUES (:reviewer_id,:reviewee_id,:offer_id,:rating,:comment)"
);
$ok = $stmt->execute([
    ":reviewer_id" => $_SESSION["user_id"],
    ":reviewee_id" => $data["reviewee_id"],
    ":offer_id"    => $data["offer_id"] ?? null,
    ":rating"      => $rating,
    ":comment"     => trim($data["comment"]),
]);
 
if (!$ok) {
    http_response_code(500);
    echo json_encode(["success"=>false,"message"=>"Database error saving review."]);
    exit();
}
 
// Moderation check
$neg = $conn->prepare("SELECT COUNT(*) AS cnt FROM reviews WHERE reviewee_id=:uid AND rating<=2");
$neg->execute([":uid"=>$data["reviewee_id"]]);
$neg_count = (int)$neg->fetch(PDO::FETCH_ASSOC)["cnt"];
if ($neg_count >= 10) {
    $conn->prepare("UPDATE users SET is_banned=1 WHERE user_id=:uid")->execute([":uid"=>$data["reviewee_id"]]);
} elseif ($neg_count >= 5) {
    $conn->prepare("UPDATE users SET is_warned=1,neg_review_count=:cnt WHERE user_id=:uid")
         ->execute([":cnt"=>$neg_count,":uid"=>$data["reviewee_id"]]);
}
 
echo json_encode(["success"=>true,"review_id"=>$conn->lastInsertId()]);
?>
