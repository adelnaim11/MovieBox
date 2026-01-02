<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
require_once "../config/database.php";

$data = json_decode(file_get_contents("php://input"));

$user_id = $data->user_id;
$movie_id = $data->movie_id;
$rating = $data->rating;


$stmt = $conn->prepare("SELECT * FROM ratings WHERE user_id=? AND movie_id=?");
$stmt->bind_param("ii", $user_id, $movie_id);
$stmt->execute();
$result = $stmt->get_result();

if($result->num_rows > 0){

    $stmt = $conn->prepare("UPDATE ratings SET rating=? WHERE user_id=? AND movie_id=?");
    $stmt->bind_param("dii", $rating, $user_id, $movie_id);
    $stmt->execute();
} else {

    $stmt = $conn->prepare("INSERT INTO ratings (user_id, movie_id, rating) VALUES (?,?,?)");
    $stmt->bind_param("iid", $user_id, $movie_id, $rating);
    $stmt->execute();
}

echo json_encode(["success"=>true]);
