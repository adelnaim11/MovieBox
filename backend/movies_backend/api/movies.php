<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
header("Content-Type: application/json");
require_once "../config/database.php";
$sql = "
SELECT 
    m.id,
    m.title,
    m.description,
    m.rating,
    m.category,
    m.cover,
    GROUP_CONCAT(mi.image_url) AS images
FROM movies m
LEFT JOIN movie_images mi ON m.id = mi.movie_id
GROUP BY m.id
";

$stmt = $pdo->prepare($sql);
$stmt->execute();

$movies = [];

while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
    $movies[] = [
        "id" => (int)$row["id"],
        "title" => $row["title"],
        "description" => $row["description"],
        "rating" => (float)$row["rating"],
        "category" => $row["category"],
        "cover" => $row["cover"],
        "images" => $row["images"] ? explode(",", $row["images"]) : []
    ];
}

echo json_encode($movies);
