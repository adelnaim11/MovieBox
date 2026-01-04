<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
header("Content-Type: application/json");
require_once "../config/database.php";

if (!isset($_GET["id"])) {
    http_response_code(400);
    echo json_encode(["error" => "Movie ID required"]);
    exit;
}

$movieId = (int)$_GET["id"];

$sql = "
SELECT 
    m.id,
    m.title,
    m.description,
    (SELECT AVG(rating) FROM ratings WHERE movie_id = m.id) as avg_rating,
    (SELECT COUNT(*) FROM ratings WHERE movie_id = m.id) as total_votes,
    m.category,
    m.cover,
    mi.image_url
FROM movies m
LEFT JOIN movie_images mi ON m.id = mi.movie_id
WHERE m.id = ?
";

$stmt = $pdo->prepare($sql);
$stmt->execute([$movieId]);

$movie = null;
$images = [];

while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
    if (!$movie) {
        $movie = [
            "id" => (int)$row["id"],
            "title" => $row["title"],
            "description" => $row["description"],
            "rating" => round((float)($row["avg_rating"] ?? 0), 1),
            "votes" => (int)$row["total_votes"],
            "category" => $row["category"],
            "cover" => $row["cover"],
            "images" => []
        ];
    }
    if ($row["image_url"]) {
        $images[] = $row["image_url"];
    }
}

if (!$movie) {
    http_response_code(404);
    echo json_encode(["error" => "Movie not found"]);
    exit;
}

$movie["images"] = $images;
echo json_encode($movie);
