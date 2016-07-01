<?php
function getDirContents($dir, &$results = array()){
    $files = scandir($dir);

    foreach($files as $key => $value){
        $path = realpath($dir.DIRECTORY_SEPARATOR.$value);
        if(!is_dir($path)) {
            $results[] = $path;
        } else if($value != "." && $value != "..") {
            getDirContents($path, $results);
            $results[] = $path;
        }
    }

    return $results;
}
$ar = getDirContents('./');
foreach ( $ar as $file )
{
  if (mb_ereg(".php",$file))
  {
    if (mb_ereg("vendor",$file))
    {
      continue;
    }
	if (is_dir(file)) {
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
