<?php
$ar = array();
exec("find", $ar );
foreach ( $ar as $file )
{
  if (mb_ereg(".php|.phtml",$file))
  {
    if (mb_ereg("/lib/",$file))
    {
      continue;
    }
    $fileContents = file_get_contents($file);
    $isCRLF = preg_match("/\r\n/", $fileContents);
    if ($isCRLF)
    {
      $setLF = preg_replace("/\r\n/", "\n", $fileContents);
      file_put_contents($file, $setLF);
      echo $file."\n";
    }
  }
}
?>
