<?php
require_once "../config/cors.php";
require_once "../config/db.php";
 
$q = trim($_GET["q"] ?? "");
if (strlen($q) < 2) {
    echo json_encode(["success"=>true,"users"=>[]]);
    exit();
}
 
$db = new Database(); $conn = $db->getConnection();
$stmt = $conn->prepare(
    "SELECT user_id, username, location, profile_pic,
            is_verified, is_banned, is_warned
     FROM users
     WHERE username LIKE :q OR location LIKE :q2
     ORDER BY is_verified DESC, username ASC
     LIMIT 10"
);
$stmt->execute([":q"=>"%{$q}%", ":q2"=>"%{$q}%"]);
$users = $stmt->fetchAll(PDO::FETCH_ASSOC);
echo json_encode(["success"=>true,"users"=>$users]);
?>
