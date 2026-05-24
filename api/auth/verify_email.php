<?php
require_once "../config/cors.php";
require_once "../config/db.php";
 
$token = $_GET["token"] ?? "";
if (!$token) { echo "Invalid link."; exit(); }
 
$db=$new Database(); $conn=$db->getConnection();
$s=$conn->prepare("SELECT user_id FROM users WHERE verification_token=:tok AND token_expires>NOW()");
$s->execute([":tok"=>$token]);
$user=$s->fetch(PDO::FETCH_ASSOC);
 
if (!$user) {
    echo "<h2>Link expired or invalid.</h2><p>Please register again.</p>"; exit();
}
 
$conn->prepare("UPDATE users SET email_verified=1,verification_token=NULL,token_expires=NULL WHERE user_id=:uid")
     ->execute([":uid"=>$user["user_id"]]);
 
echo "<h2>Email verified!</h2><p>You can now log in to BarterBayan.</p>
      <script>setTimeout(()=>window.location="http://localhost:5173/login",2000)</script>";
?>
