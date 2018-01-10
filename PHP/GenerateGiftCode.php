<?php
/**
 * Create Gift Code
 * A Gift Code has 18 Character
 * Each of them is a file
 *
 * Gift Code is checked by ASCII code of first Character
 * A = 65 -> Alpha test
 * B = 66 -> Close Beta
 *
 * You need add the check first character to
 * ../Public/Data/Script/event/prize/eprize.lua in x888899_OpenCard Function
 *
 * Run command in Terminal/Shell bash/Console tool to create Giftcode:
 * shell> php GiftCodeCreate.php -t [(string) Gift Code Type] -n [(int) Numbers of Gift Code to create]
 * Examle: php GiftCodeCreate.php -t A -n 500
 *
 * (c) Hai Le - (a.k.a Dark.Hades)
 */

define('GIFTCODE_DIR', dirname(__FILE__) . '/Var/GiftCode/');

$shortopts  = '';
$shortopts .= 't:';  // Type: A||B||C||...
$shortopts .= 'n:';  // Numbers of Gift Code to Create

$options = getopt($shortopts);
echo "\n";
try
{

  if (!is_dir(GIFTCODE_DIR))
  {
    $mdr = mkdir(GIFTCODE_DIR);
    if (!$mdr) {
      throw new Exception('Folder ['.GIFTCODE_DIR.'] is not found!');
    }
  }
  if (!isset($options['n']) || empty($options['n']) || !is_numeric($options['n']) || $options['n']<1)
  {
    throw new Exception('Number(s) [-n] not is a number > 0.');
  }
  if (strlen($options['t']) > 1)
  {
    throw new Exception('Type [-t] \'s length = 1 character.');
  }

  // Try create
  echo '==== Creating [' . $options['n'] . '] GiftCode(s) Type ['.$options['t'].'] in ['.GIFTCODE_DIR."] ====\n";
  echo "\n";
  for ($i=0; $i < $options['n']; $i++)
  {
    $filename = GIFTCODE_DIR.$options['t'].generateRandomString(17);
    if (file_exists($filename))
    {
      unlink($filename);
    }
    touch($filename);
    echo basename($filename)."\n";
  }

  $allGiftCode = glob(GIFTCODE_DIR.'*');
  sort($allGiftCode);
  $log = dirname(dirname(GIFTCODE_DIR)).'/GiftCodeList.txt';
  $fp = fopen($log, "w");
  if (!$fp)
  {
    throw new Exception('Cant create list file.');
  }
  fwrite($fp, "No.\t"."Code\n");
  foreach ($allGiftCode as $key => $value)
  {
    fwrite($fp, ($key+1)."\t".basename($value)."\n");
  }
  fclose($fp);
  echo "\n";
  echo 'Log in ['.$log.']';
  echo "\n";
  echo '==== Created [' . $options['n'] . '] GiftCode(s) Type ['.$options['t'].'] in ['.GIFTCODE_DIR."]  ====\n";
  echo "\n";
}
catch (Exception $e)
{
  echo 'Error(s): '.$e."\n\n";
  echo 'You must insert all -t and -n'."\n";
  echo '  -t: Type of GiftCode.'."\n";
  echo '  -n: Number(s) of GiftCode that you want to create.'."\n";
  echo 'Examle: php CreateGiftCode.php -t A -n 500'."\n\n";
}

function generateRandomString($length = 10)
{
  $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  $charactersLength = strlen($characters);
  $randomString = '';
  for ($i = 0; $i < $length; $i++)
  {
    $randomString .= $characters[rand(0, $charactersLength - 1)];
  }
  return $randomString;
}
