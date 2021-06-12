<?php
/**
.htaccess
RewriteEngine On
RewriteCond %{REQUEST_URI} !LoginServer.php
RewriteRule LoginServer.txt LoginServer.php
 */

header('Content-Type:text/plain; charset=latin1');

$useFile = 'LoginServer.txt';

try {
    $clientRealIp = $_SERVER['REMOTE_ADDR'];
    $countryCode = trim(json_decode(file_get_contents(
        'http://www.geoplugin.net/json.gp?ip='.$clientRealIp
    ))->geoplugin_countryCode);

    if ($countryCode !== 'VN') {
        $useFile = 'LoginServerOversea.txt';
    }
} catch (\Throwable $e) {
    file_put_contents('LoginServer.log', $e->getMessage() . PHP_EOL, FILE_APPEND);
} finally {
    // file_put_contents('LoginServer.log', $clientRealIp . PHP_EOL, FILE_APPEND);
}

echo file_get_contents($useFile);
