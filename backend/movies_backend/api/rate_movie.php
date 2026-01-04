<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    exit;
}

require_once "../config/database.php";

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'POST') {
    $data = json_decode(file_get_contents("php://input"));
    if (!$data) exit;

    // Use UPSERT logic (Insert or Update on duplicate)
    $stmt = $pdo->prepare("INSERT INTO ratings (user_id, movie_id, rating) 
                           VALUES (?, ?, ?) 
                           ON DUPLICATE KEY UPDATE rating = VALUES(rating)");
    $success = $stmt->execute([$data->user_id, $data->movie_id, $data->rating]);
    echo json_encode(["success" => $success]);

} else if ($method === 'GET') {
    $uid = $_GET['user_id'];
    $mid = $_GET['movie_id'];
    
    $stmt = $pdo->prepare("SELECT rating FROM ratings WHERE user_id = ? AND movie_id = ?");
    $stmt->execute([$uid, $mid]);
    $row = $stmt->fetch();
    
    echo json_encode(["rating" => $row ? $row['rating'] : 0]);
}
?>