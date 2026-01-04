<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
require_once "../config/database.php";

$category = $_GET['category'] ?? '';
$excludeId = (int)($_GET['exclude_id'] ?? 0);

$sql = "
SELECT 
    m.id, 
    m.title, 
    m.description, 
    m.category, 
    m.cover,
    GROUP_CONCAT(mi.image_url) AS images,
    COALESCE((SELECT AVG(rating) FROM ratings WHERE movie_id = m.id), 0) as rating,
    COALESCE((SELECT COUNT(*) FROM ratings WHERE movie_id = m.id), 0) as votes
FROM movies m
LEFT JOIN movie_images mi ON m.id = mi.movie_id
WHERE m.category = ? AND m.id != ?
GROUP BY m.id
ORDER BY rating DESC
LIMIT 6
";

$stmt = $pdo->prepare($sql);
$stmt->execute([$category, $excludeId]);

$movies = [];
while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
    $movies[] = [
        "id" => (int)$row["id"],
        "title" => $row["title"],
        "description" => $row["description"],
        "rating" => (float)$row["rating"],
        "votes" => (int)$row["votes"],
        "category" => $row["category"],
        "cover" => $row["cover"],
        "images" => $row["images"] ? explode(",", $row["images"]) : []
    ];
}

echo json_encode($movies);