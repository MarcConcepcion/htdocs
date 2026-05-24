<?php
require_once "../config/cors.php";
require_once "../config/db.php";

$data = json_decode(file_get_contents("php://input"), true);

if (empty($data["username"]) || empty($data["email"]) || empty($data["password"])) {
    http_response_code(400);
    echo json_encode(["success" => false, "message" => "All fields are required."]);
    exit();
}

$database = new Database();
$conn     = $database->getConnection();

$check = $conn->prepare("SELECT user_id FROM users WHERE email = :email");
$check->execute([":email" => $data["email"]]);
if ($check->fetch()) {
    http_response_code(409);
    echo json_encode(["success" => false, "message" => "Email is already registered."]);
    exit();
}

$hash = password_hash($data["password"], PASSWORD_BCRYPT);

$stmt = $conn->prepare(
    "INSERT INTO users
       (username, email, password_hash, phone,
        first_name, middle_initial, last_name,
        location, city, barangay)
     VALUES
       (:username, :email, :password_hash, :phone,
        :first_name, :middle_initial, :last_name,
        :location, :city, :barangay)"
);
$stmt->execute([
    ":username"       => trim($data["username"]),
    ":email"          => trim($data["email"]),
    ":password_hash"  => $hash,
    ":phone"          => $data["phone"]          ?? null,
    ":first_name"     => trim($data["first_name"] ?? ""),
    ":middle_initial" => trim($data["middle_initial"] ?? ""),
    ":last_name"      => trim($data["last_name"] ?? ""),
    ":location"       => $data["location"]       ?? null,
    ":city"           => $data["city"]            ?? null,
    ":barangay"       => $data["barangay"]        ?? null,
]);

$token   = bin2hex(random_bytes(32));
$expires = date("Y-m-d H:i:s", strtotime("+24 hours"));
$uid     = $conn->lastInsertId();

$conn->prepare(
    "UPDATE users SET verification_token=:tok, token_expires=:exp WHERE user_id=:uid"
)->execute([":tok"=>$token, ":exp"=>$expires, ":uid"=>$uid]);

$verify_link = "http://localhost/barterbayan/api/auth/verify_email.php?token=".$token;
$to      = $data["email"];
$subject = "BarterBayan — Verify Your Email";
$message = "Hello {$data["username"]},\n\nPlease verify your email: {$verify_link}\n\nLink expires in 24 hours.\n\nBarterBayan Team";
$headers = "From: noreply@barterbayan.ph";

file_put_contents(__DIR__."/../../../verify_links.txt",
    date("Y-m-d H:i:s")." | ".$data["email"]." | ".$verify_link."\n",
    FILE_APPEND);

echo json_encode([
    "success"=>true,
    "message"=>"Registered! Check your email to verify your account.",
    "dev_verify_link"=>$verify_link
]);
?>