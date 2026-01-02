<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
require_once "../config/database.php";

$data = json_decode(file_get_contents("php://input"));

if(!empty($data->username) && !empty($data->password)) {
    $username = $data->username;
    // Hash the password for security
    $password = password_hash($data->password, PASSWORD_BCRYPT);
    $role = 'user'; // Default role

    $stmt = $conn->prepare("INSERT INTO users (username, password, role) VALUES (?, ?, ?)");
    $stmt->bind_param("sss", $username, $password, $role);

    if($stmt->execute()) {
        echo json_encode(["success" => true, "message" => "User created"]);
    } else {
        echo json_encode(["success" => false, "message" => "Username already exists"]);
    }
} else {
    echo json_encode(["success" => false, "message" => "Incomplete data"]);
}
?>
