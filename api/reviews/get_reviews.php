<?php
session_start();
require_once "../config/cors.php";
require_once "../config/db.php";

$reviewee_id = $_GET['reviewee_id'] ?? null;
if (!$reviewee_id) {
    echo json_encode(["success" => false, "message" => "reviewee_id required"]);
    exit();
}

$db = new Database();
$conn = $db->getConnection();

// Fetch all reviews for this user
$stmt = $conn->prepare("
    SELECT r.*, u.username as reviewer_name, u.profile_pic as reviewer_avatar
    FROM reviews r
    JOIN users u ON r.reviewer_id = u.user_id
    WHERE r.reviewee_id = ?
    ORDER BY r.created_at DESC
");
$stmt->execute([$reviewee_id]);
$reviews = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Calculate average rating
$avg_stmt = $conn->prepare("SELECT AVG(rating) as avg FROM reviews WHERE reviewee_id = ?");
$avg_stmt->execute([$reviewee_id]);
$avg = round($avg_stmt->fetch(PDO::FETCH_ASSOC)['avg'], 1);

echo json_encode([
    "success" => true,
    "reviews" => $reviews,
    "avg_rating" => $avg ?: 0
]);
?>