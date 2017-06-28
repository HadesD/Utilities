<?php
//mb_convert_encoding($input, "UTF-8", "EUC-JP");
$dirHandler = opendir(".");

while ($fileName = readdir($dirHandler)) {

   if ($fileName != '.' && $fileName != '..' 
                        && $fileName != 'php' && $fileName != 'tmp') {

      $file = file_get_contents("./$fileName", FILE_USE_INCLUDE_PATH);
      $convertedText = mb_convert_encoding($file, "UTF-8", "EUC-JP");

      echo "$fileName\n";

      $writeFile  = "../tmp/$fileName";
      $fileHandle = fopen($writeFile, 'w') or die("can't open file");
      fwrite($fileHandle, $convertedText);
      fclose($fileHandle);
   }
 }

?>
