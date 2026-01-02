<?php
echo json_encode([
    "status" => "API Running",
    "endpoints" => [
        "/api/movies.php",
        "/api/movie_details.php?id=1"
    ]
]);
