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

try {
    $stmt = $pdo->prepare("SELECT id, username, password, role FROM users WHERE username = :username");
    $stmt->execute([':username' => $username]);
    
    $user = $stmt->fetch();

    if ($user) {
        if (password_verify($password, $user['password'])) {
            echo json_encode([
                "success" => true,
                "id" => (int)$user['id'],
                "role" => $user['role'],
                "username" => $user['username']
            ]);
        } else {
            echo json_encode(["success" => false, "message" => "Incorrect password"]);
        }
    } else {
        echo json_encode(["success" => false, "message" => "Username does not exist"]);
    }

} catch (PDOException $e) {
    echo json_encode(["success" => false, "message" => "Database error: " . $e->getMessage()]);
}
?>