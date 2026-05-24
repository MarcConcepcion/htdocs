<?php
require_once "../config/cors.php";
require_once "../config/db.php";

$data = json_decode(file_get_contents("php://input"), true);

$title       = trim($data["title"] ?? "");
$description = trim($data["description"] ?? "");
$swap_for    = trim($data["swap_for"] ?? "");

$response = [
    "blocked"   => false,
    "warnings"  => [],
    "message"   => ""
];

if (empty($title) && empty($description) && empty($swap_for)) {
    $response["message"] = "No content to check.";
    echo json_encode($response);
    exit();
}

$database = new Database();
$conn = $database->getConnection();

// Fetch all banned keywords
$stmt = $conn->query("SELECT keyword, severity FROM banned_keywords");
$keywords = $stmt->fetchAll(PDO::FETCH_ASSOC);

$textToCheck = strtolower($title . " " . $description . " " . $swap_for);
$blocked = false;
$warnings = [];

foreach ($keywords as $kw) {
    $keyword = strtolower($kw["keyword"]);
    if (strpos($textToCheck, $keyword) !== false) {
        if ($kw["severity"] === "block") {
            $blocked = true;
            $response["message"] = "Your listing contains blocked content: " . $kw["keyword"];
            break;
        } else {
            $warnings[] = ["keyword" => $kw["keyword"], "severity" => "warn"];
        }
    }
}

$response["blocked"] = $blocked;
$response["warnings"] = $warnings;

echo json_encode($response);
?>