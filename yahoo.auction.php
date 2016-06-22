<span class="yconnectLogin"></span>

<script type="text/javascript">
window.yconnectInit = function() {
    YAHOO.JP.yconnect.Authorization.init({
        button: {
            format: "image",
            type: "a",
            textType:"a",
            width: 196,
            height: 38,
            className: "yconnectLogin"
        },
        authorization: {
            clientId: "dj0zaiZpPUJmWGNqRzY4T3JONiZzPWNvbnN1bWVyc2VjcmV0Jng9YmM-",
            redirectUri: "http://localhost/yahoo/index.php",
            scope: "openid",
            state: "hades",
            nonce: "dark",
            windowWidth: "500",
            windowHeight: "400"
        },
        onError: function(res) {
            // エラー発生時のコールバック関数
        },
        onCancel: function(res) {
            // 同意キャンセルされた時のコールバック関数
        }
    });
};
(function(){
var fs = document.getElementsByTagName("script")[0], s = document.createElement("script");
s.setAttribute("src", "https://s.yimg.jp/images/login/yconnect/auth/1.0.3/auth-min.js");
fs.parentNode.insertBefore(s, fs);
})();
</script>
<?php
if(empty($_GET['code']))
  exit;
function cURL($url = null, $headers = null, $postFields = null) {
  $curl = curl_init($url);
  curl_setopt($curl, CURLOPT_FOLLOWLOCATION, true);
  curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
  if($postFields){
    curl_setopt($curl, CURLOPT_POST, true);
    curl_setopt($curl, CURLOPT_POSTFIELDS,  $postFields);
  }
  if($headers)
    curl_setopt($curl, CURLOPT_HTTPHEADER, $headers);
  curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, false);
  curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
  $result = curl_exec($curl);
  curl_close ( $curl );
  return $result;
}
// get Access Token
$url = 'https://auth.login.yahoo.co.jp/yconnect/v1/token';
$applicationId = "dj0zaiZpPUJmWGNqRzY4T3JONiZzPWNvbnN1bWVyc2VjcmV0Jng9YmM-";
$secret = "85ec2f54d220ee311eb0325e7a30f49bf1e5ce18";
$basicAuth = base64_encode($applicationId . ':' . $secret);
$postFields = "grant_type=authorization_code&code=" . $_GET['code'] . "&redirect_uri=http%3A%2F%2Flocalhost%2Fyahoo%2Findex.php";
$headers = array(
  "Content-Type: application/x-www-form-urlencoded",
  "Authorization: Basic " . $basicAuth,
);
$result = cURL($url, $headers, $postFields);
if(empty($result))
  exit;
$result_arr = json_decode($result, true);
if(isset($result_arr['error']))
  exit;
$access_token = $result_arr['access_token'];
// end get Access Token
?>
<pre>
<?php
$URLmySellingList = 'https://auctions.yahooapis.jp/AuctionWebService/V2/mySellingList?start=1&';
$params = array(
  'output'  =>  'json',
  'start'   =>  1,
);
$headers = array(
  "Authorization: Bearer " . $access_token,
);
$list = cURL($URLmySellingList . http_build_query($params), $headers);
print_r($list);
?>
</pre>
