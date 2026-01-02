<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
require_once "../config/database.php";

$data = json_decode(file_get_contents("php://input"));

if(!empty($data->id)) {
    // Delete the movie (movie_images should be deleted by foreign key cascade)
    $stmt = $conn->prepare("DELETE FROM movies WHERE id = ?");
    $stmt->bind_param("i", $data->id);

    if($stmt->execute()) {
        echo json_encode(["success" => true]);
    } else {
        echo json_encode(["success" => false, "message" => "Delete failed"]);
    }
}
?>