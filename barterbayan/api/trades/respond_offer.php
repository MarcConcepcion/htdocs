<?php
session_start();
require_once "../config/cors.php";
require_once "../config/db.php";
 
if (!isset($_SESSION["user_id"])) {
    http_response_code(401);
    echo json_encode(["success"=>false,"message"=>"Not authenticated."]);
    exit();
}
 
$data     = json_decode(file_get_contents("php://input"), true);
$offer_id = (int)($data["offer_id"] ?? 0);
$response = $data["response"] ?? "";
 
if (!in_array($response, ["accepted","declined"])) {
    http_response_code(400);
    echo json_encode(["success"=>false,"message"=>"Invalid response."]);
    exit();
}
 
$db = new Database(); $conn = $db->getConnection();
 
// Verify this user is the receiver
$check = $conn->prepare(
    "SELECT * FROM trade_offers
     WHERE offer_id=:oid AND receiver_id=:uid AND status='pending'"
);
$check->execute([":oid"=>$offer_id, ":uid"=>$_SESSION["user_id"]]);
$offer = $check->fetch(PDO::FETCH_ASSOC);
 
if (!$offer) {
    http_response_code(403);
    echo json_encode(["success"=>false,"message"=>"Offer not found or already responded."]);
    exit();
}
 
// Update offer status
$upd = $conn->prepare(
    "UPDATE trade_offers SET status=:status WHERE offer_id=:oid"
);
$upd->execute([":status"=>$response, ":oid"=>$offer_id]);
 
if ($response === "accepted") {
    // ── Transfer item ownership ──────────────────────────────────
    // Offered item (from sender) → goes to receiver
    $conn->prepare(
        "UPDATE items SET user_id=:new_owner, status='traded'
         WHERE item_id=:iid"
    )->execute([
        ":new_owner" => $offer["receiver_id"],
        ":iid"       => $offer["offered_item_id"],
    ]);
 
    // Requested item (from receiver) → goes to sender
    $conn->prepare(
        "UPDATE items SET user_id=:new_owner, status='traded'
         WHERE item_id=:iid"
    )->execute([
        ":new_owner" => $offer["sender_id"],
        ":iid"       => $offer["requested_item_id"],
    ]);
 
    // ── Notify sender ─────────────────────────────────────────────
    $conn->prepare(
        "INSERT INTO notifications (user_id, type, reference_id, message)
         VALUES (:uid, 'offer_accepted', :ref, :msg)"
    )->execute([
        ":uid" => $offer["sender_id"],
        ":ref" => $offer_id,
        ":msg" => "Your trade offer was ACCEPTED! Items have been transferred.",
    ]);
 
} else {
    // Declined — notify sender
    $conn->prepare(
        "INSERT INTO notifications (user_id, type, reference_id, message)
         VALUES (:uid, 'offer_declined', :ref, :msg)"
    )->execute([
        ":uid" => $offer["sender_id"],
        ":ref" => $offer_id,
        ":msg" => "Your trade offer was declined.",
    ]);
}
 
echo json_encode(["success"=>true,"message"=>"Offer ".$response.".","response"=>$response]);
?>
