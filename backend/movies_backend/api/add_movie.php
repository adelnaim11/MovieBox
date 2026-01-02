<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
require_once "../config/database.php";

$data = json_decode(file_get_contents("php://input"));

if(!empty($data->title)) {
    // 1. Insert the main movie data
    $stmt = $conn->prepare("INSERT INTO movies (title, description, rating, category, cover) VALUES (?, ?, ?, ?, ?)");
    $stmt->bind_param("ssdss", $data->title, $data->description, $data->rating, $data->category, $data->cover);

    if($stmt->execute()) {
        $movie_id = $conn->insert_id; // Get the ID of the movie we just created

        // 2. Insert extra images into movie_images table
        if(!empty($data->images) && is_array($data->images)) {
            $stmtImg = $conn->prepare("INSERT INTO movie_images (movie_id, image_url) VALUES (?, ?)");
            foreach($data->images as $url) {
                $stmtImg->bind_param("is", $movie_id, $url);
                $stmtImg->execute();
            }
        }
        echo json_encode(["success" => true]);
    } else {
        echo json_encode(["success" => false, "message" => "Error adding movie"]);
    }
}
?>
