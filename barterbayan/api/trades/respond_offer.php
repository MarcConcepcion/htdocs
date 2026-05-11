<?php
session_start();
require_once "../config/cors.php";
require_once "../config/db.php";
 
if (!isset($_SESSION["user_id"])) {
    http_response_code(401);
    echo json_encode(["success" => false, "message" => "Not authenticated."]);
    exit();
}
 
$data     = json_decode(file_get_contents("php://input"), true);
$offer_id = $data["offer_id"] ?? null;
$response = $data["response"] ?? null; // "accepted" or "declined"
 
if (!in_array($response, ["accepted", "declined"])) {
    http_response_code(400);
    echo json_encode(["success" => false, "message" => "Invalid response value."]);
    exit();
}
 
$database = new Database();
$conn     = $database->getConnection();
 
$stmt = $conn->prepare(
    "UPDATE trade_offers SET status = :status WHERE offer_id = :offer_id AND receiver_id = :uid"
);
$stmt->execute([
    ":status"   => $response,
    ":offer_id" => $offer_id,
    ":uid"      => $_SESSION["user_id"],
]);
 
// --- Send notification to the sender (after successful update) ---
// Fetch offer details to get the sender_id
$fetch = $conn->prepare("SELECT sender_id FROM trade_offers WHERE offer_id = :oid");
$fetch->execute([":oid" => $offer_id]);
$offer = $fetch->fetch(PDO::FETCH_ASSOC);

if ($offer) {
    $msg = $response === "accepted"
         ? "Your trade offer was ACCEPTED! Coordinate with the trader."
         : "Your trade offer was declined.";
    
    $notif = $conn->prepare(
        "INSERT INTO notifications (user_id, type, reference_id, message)
         VALUES (:uid, :type, :ref, :msg)"
    );
    $notif->execute([
        ":uid"  => $offer["sender_id"],
        ":type" => $response === "accepted" ? "offer_accepted" : "offer_declined",
        ":ref"  => $offer_id,
        ":msg"  => $msg,
    ]);
}
// --- End notification block ---
 
echo json_encode(["success" => true, "message" => "Offer " . $response . "."]);
?>