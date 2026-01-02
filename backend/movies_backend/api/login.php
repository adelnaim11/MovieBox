<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type"); // Required for some Flutter http clients
require_once "../config/database.php";

$data = json_decode(file_get_contents("php://input"));

if (!$data || !isset($data->username) || !isset($data->password)) {
    echo json_encode(["success" => false, "message" => "Invalid request data"]);
    exit;
}

$username = trim($data->username);
$password = $data->password;

$stmt = $conn->prepare("SELECT id, username, password, role FROM users WHERE username = ?");
$stmt->bind_param("s", $username);
$stmt->execute();
$result = $stmt->get_result();

if($row = $result->fetch_assoc()){
    if(password_verify($password, $row['password'])){
        echo json_encode([
            "success" => true,
            "user_id" => $row['id'],
            "role" => $row['role'],
            "username" => $row['username']
        ]);
    } else {
        echo json_encode(["success" => false, "message" => "Incorrect password"]);
    }
} else {
    echo json_encode(["success" => false, "message" => "Username does not exist"]);
}