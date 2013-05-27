var BASE="http://www-lipn.univ-paris13.fr/~dubacq/europa/"
var XBASE=BASE+"carte/"
var PBASE=BASE+"pions/"
// The following line is for local use. Do not use it on the remote server.
// It uses bitmaps in local directories
if (location.href.indexOf("file:///") != -1 ||
    location.href.indexOf("http://localhost") != -1 ||
    location.href.indexOf("http://www.tenebreuse.org/jcdubacq/europa/web") != -1
   ) {
    XBASE="../carte/bitmap/"
    PBASE="../pions/bitmap/"
}
TILESIZE=256

var map;
$(function() {
    map=new mV.map('map_canvas',{url: XBASE+'tile_', blankUrl: 'img/bkgnd.png', maxZoom: 8});
})