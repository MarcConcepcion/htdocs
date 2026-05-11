<?php
session_start();
require_once "../config/cors.php";
require_once "../config/db.php";
 
if (!isset($_SESSION["user_id"])) { http_response_code(401); echo json_encode(["success"=>false]); exit(); }
 
$data    = json_decode(file_get_contents("php://input"), true);
$other   = (int)($data["other_user_id"] ?? 0);
$me      = (int)$_SESSION["user_id"];
$a       = min($me, $other);
$b       = max($me, $other);
 
$db = new Database(); $conn = $db->getConnection();
 
// Find existing
$s = $conn->prepare("SELECT convo_id FROM conversations WHERE user_a=:a AND user_b=:b LIMIT 1");
$s->execute([":a"=>$a,":b"=>$b]);
$row = $s->fetch(PDO::FETCH_ASSOC);
 
if ($row) {
    echo json_encode(["success"=>true,"convo_id"=>$row["convo_id"]]);
} else {
    $ins = $conn->prepare("INSERT INTO conversations (user_a,user_b) VALUES (:a,:b)");
    $ins->execute([":a"=>$a,":b"=>$b]);
    echo json_encode(["success"=>true,"convo_id"=>$conn->lastInsertId()]);
}
?>
