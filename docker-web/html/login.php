<?php
session_start();
error_reporting(0);
ini_set('display_errors', 0);

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $username = $_POST['username'] ?? '';
    $password = $_POST['password'] ?? '';

    $conn = new mysqli('mysql', 'root', 'ZXGPK9tk7s0RPqp3Q8d1Hy5MZRw=', 'webchik');

    if ($conn->connect_error) {
        die("Waiting for DB to initialize.");
    }

    $passwordHash = md5($conn->real_escape_string($password));

    $sql = "SELECT * FROM users WHERE username='$username' AND password='$passwordHash'";
    $result = $conn->query($sql);

    $logDir = 'logs';
    $logFile = 'logs/log.txt';
    if (!file_exists($logDir)) {
        mkdir($logDir, 0777, true);
    }

    $logMessage = date('Y-m-d H:i:s') . " | Username: $username | ";
    
    if ($result->num_rows > 0) {
        $_SESSION['username'] = $username;
        $logMessage .= "Status: SUCCESS\n";
        file_put_contents($logFile, $logMessage, FILE_APPEND);
        $message = "Welcome $username, I remind you our new Database credentials:\nroot:ZXGPK9tk7s0RPqp3Q8d1Hy5MZRw=";
        $messageClass = 'success';
    } else {
        $logMessage .= "Status: FAILURE\n";
        file_put_contents($logFile, $logMessage, FILE_APPEND);
        if (strpos(strtolower($username), 'or 1=1') !== false) {
            $message = "OR 1=1 , seriously?? Try harder!";
        } else {
            $message = "Invalid username or password.";
        }
        $messageClass = 'error';
    }

    $conn->close();
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Result</title>
    <style>
        body {
            background-color: #1e1e1e;
            color: #c7c7c7;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            text-align: center;
            background-size: cover;
            background-position: center;
        }

        .message-box {
            background-color: rgba(40, 44, 52, 0.8);
            padding: 20px 40px;
            border-radius: 15px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.6);
            max-width: 600px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .message {
            font-size: 18px;
            font-weight: bold;
            color: #98c379;
            word-wrap: break-word;
            line-height: 1.5;
            white-space: pre-wrap;
        }

        .error {
            color: #e06c75;
        }

        .success {
            color: #98c379;
        }
    </style>
</head>
<body>
    <div class="message-box">
        <p class="message <?php echo $messageClass ?? ''; ?>">
            <?php echo $message ?? ''; ?>
        </p>
    </div>
</body>
</html>
