<?php
session_start();
require_once "../config/cors.php";
require_once "../config/db.php";

if (!isset($_SESSION["user_id"])) {
    http_response_code(401);
    echo json_encode(["success" => false, "message" => "Not authenticated."]);
    exit();
}

$data = json_decode(file_get_contents("php://input"), true);
$database = new Database();
$conn     = $database->getConnection();

// Build SQL with optional profile_pic field
$sql = "UPDATE users SET username = :username, location = :location";
if (!empty($data["profile_pic"])) {
    $sql .= ", profile_pic = :profile_pic";
}
$sql .= " WHERE user_id = :user_id";

$stmt = $conn->prepare($sql);

$params = [
    ":username" => trim($data["username"]),
    ":location" => $data["location"] ?? null,
    ":user_id"  => $_SESSION["user_id"],
];
if (!empty($data["profile_pic"])) {
    $params[":profile_pic"] = $data["profile_pic"];
}

$stmt->execute($params);

echo json_encode(["success" => true, "message" => "Profile updated."]);
?>