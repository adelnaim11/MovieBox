<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$host = getenv('MYSQLHOST');
$db_name = getenv('MYSQLDATABASE');
$username = getenv('MYSQLUSER');
$password = getenv('MYSQLPASSWORD');
$port = getenv('MYSQLPORT');

try {
    $options = [
        PDO::MYSQL_ATTR_SSL_CA => __DIR__ . '/isrgrootx1.pem',
        PDO::MYSQL_ATTR_SSL_VERIFY_SERVER_CERT => false, // Prevents hostname mismatch errors
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
    ];

    $pdo = new PDO(
        "mysql:host=$host;port=$port;dbname=$db_name;charset=utf8",
        $username,
        $password,
        $options
    );
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["error" => "Connection failed: " . $e->getMessage()]);
    exit;
}