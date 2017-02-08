<?php
function ascii2utf8 ($str) {
  $rp = [
    //A-a
    'À' => 'À',
    'Á' => 'Á',
    'Ä' => 'Ả',
    'Ã' => 'Ã',
    '' => 'Ạ',
    'Å' => 'Ă',
    '' => 'Ằ',
    //D-d
    //E-e
    'ê' => 'ê',
    '«' => 'ề',
    'ª' => 'ế',
    '¬' => 'ể',
    '­' => 'ễ',
    '®' => 'ệ',
    //I-i
    //O-o
    '¶' => 'ờ',
    //U-u
    //Y-y
    //#
    '' => '&#x025FB;',
  ];

  return str_replace(array_keys($rp), array_values($rp), $str);
}
