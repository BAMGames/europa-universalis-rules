<?php
if (isset($_GET['z']) && (isset($_GET['b']) || isset($_GET['s'])))  {
    $zoom=intval($_GET['z']);
    if (isset($_GET['b']) && isset($_GET['s'])) $doOverlay=1;
    $usesmall=(!isset($_GET['b']));
    if (!isset($_GET['b'])) $_GET['b']='';
    if (!isset($_GET['s'])) $_GET['s']='';
    if (preg_match('/\/\./',$_GET['b'].$_GET['s'])) die();
    $path='/users/jcdubacq/public_html/europa/pions/counter_'.$zoom.'/';
    $max=$path.($usesmall?$_GET['s']:$_GET['b']).'.png';
    if (!file_exists($max)) die();
    //Formation de l'image
    header ("Content-type: image/png");
    $image = imagecreatefrompng($max);
    imagealphablending($image, false);
    imagesavealpha($image, true);
    $bigh = imagesy($image);
    $bigw = imagesx($image);
    if ($doOverlay) {
        $min=$path.$_GET['s'].'.png';
        if (!file_exists($min)) die();
        $overlay = imagecreatefrompng($min);
        $smah = imagesy($overlay);
        $smaw = imagesx($overlay);
        imagecopy($image,$overlay,($bigw-$smaw)>>1,($bigh-$smah)>>1,0,0,$smaw,$smah);
    }
    $mask='/users/jcdubacq/public_html/europa/black_'.$bigh.'.png';
    if (!file_exists($mask)) {
        imagepng($image);
        // die("Notfound:".$mask);
    }
    $overlay = $image;
    $smah = $bigh;
    $smaw = $bigw;
    $image = imagecreatefrompng($mask);
    $bigh = imagesy($image);
    $bigw = imagesx($image);
    imagealphablending($image, false);
    imagesavealpha($image, true);
    imagecopy($image,$overlay,($bigw-$smaw)>>1,($bigh-$smah)>>1,0,0,$smaw,$smah);
    imagepng($image);
} else {
    if (isset($_GET['z'])) {
    echo 'Error';
    } else {
    echo 'Error';
    }
}       
