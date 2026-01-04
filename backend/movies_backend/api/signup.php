<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");
require_once "../config/database.php";

$data = json_decode(file_get_contents("php://input"));

if (!empty($data->username) && !empty($data->password)) {
    try {
        $username = trim($data->username);
        $password = password_hash($data->password, PASSWORD_BCRYPT);
        $role = 'user';

        $stmt = $pdo->prepare("INSERT INTO users (username, password, role) VALUES (:username, :password, :role)");

        $stmt->execute([
            ':username' => $username,
            ':password' => $password,
            ':role'     => $role
        ]);

        echo json_encode(["success" => true, "message" => "User created"]);
    } catch (PDOException $e) {
        if ($e->getCode() == 23000) {
            echo json_encode(["success" => false, "message" => "Username already exists"]);
        } else {
            echo json_encode(["success" => false, "message" => "Database error: " . $e->getMessage()]);
        }
    }
} else {
    echo json_encode(["success" => false, "message" => "Incomplete data"]);
}
