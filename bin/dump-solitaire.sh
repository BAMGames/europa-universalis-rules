#!/bin/bash
# Warning : the supposition is that a valid Xserver is running on :1
# Launch acroread on :1
# Ensure it is set to 75 dpi
# kill $(ps -ef | grep acroread|cut -f2 -d' ');DISPLAY=:1 acroread -geometry 1024x768+0+0 /home/jcdubacq/activites/europa/pions/pions.pdf &
# All menubars must go (F8, F9)
# Change the zoom (Control-Y 200 Enter)

PAGES=${PAGES:-4915}
PAGES=$((PAGES+1))
function usage {
      echo "Usage: $0 [--no-cap] [--keep-files] [--dir directory]"
      echo "	--dir | -d: change the capture directory to directory"
      echo "	--delay | -D: change delay between captures"
      echo "	--no-cap | -n: do not capture the screens again"
      echo "	--keep-files | -k: do not erase captures"
      echo "	--zoom | -z: select zoom level ($ZOOMS)"
      exit 0
}
function fail {
      error=$1
      shift
      echo "$@"
      exit $error
}
DIRECTORY=${DIRECTORY:-/tmp}
ZOOM=${ZOOM:-200}
ZOOMS="800"
XMAX="0"
YMAX="0"
## Pour etablir les XCROP
# Faire fabriquer les fichiers, prendre les deux derniers
# d'une ligne, localiser les coordonnées d'un point x0 et x1 (y identique)
# Reporter 1000-x1+x0
# Pour Y, 744-y1+y0
XCROP="0"
YCROP="0"
DELAY=0

while [ -n "$1" ]; do
  case $1 in
    (--mixed|-m)
      MIXED=1
      KEEPFILES=1
      shift
    ;;
    (--no-cap|-n)
      MIXED=1
      NOCAP=1
      KEEPFILES=1
      shift
    ;;
    (--dir|-d)
      DIRECTORY=$2
      shift 2
      if [ ! -d $DIRECTORY ]; then fail -1 "$DIRECTORY is not a directory"; fi
    ;;
    (--delay|-D)
      DELAY=$2
      shift 2
    ;;
    (--keep-files|-k)
      KEEPFILES=1
      shift
    ;;
    (--zoom|-z)
      ZOOM=$2
      shift 2
    ;;
    (*)
      usage
    ;;
  esac
done
IDWIN=$(xwininfo -display :1 -root -tree|grep 1008x768|tail -1|sed -e 's/^[ 	]//g'|cut -f1 -d'(')
if [ -z "$IDWIN" ] && [ "$NOCAP" != "1" ]; then 
    fail 104 "I could not find the correct acroread window";
fi

XXMAX=0
for i in $(seq 1 $(echo $ZOOMS|wc -w)); do
  xZOOM=$(echo "$ZOOMS" | cut -d' ' -f${i})
  if [ "$xZOOM" == "$ZOOM" ]; then
    XXMAX=$(echo "$XMAX" | cut -d' ' -f${i})
    XYMAX=$(echo "$YMAX" | cut -d' ' -f${i})
    XXCROP=$(echo "$XCROP" | cut -d' ' -f${i})
    XYCROP=$(echo "$YCROP" | cut -d' ' -f${i})
  fi
done

#if [ "$XXMAX" == "0" ]; then
#  fail -3 "Zoom $ZOOM not registered ($XXMAX $XYMAX $XXCROP $XYCROP)"
#fi

function clickit { echo "Delay 1
MotionNotify "$1" "$2"
ButtonPress 1
ButtonRelease 1" | xmacroplay :1 > /dev/null 2>&1 ; }

function dragit { echo "Delay 1
MotionNotify "$1" "$2"
ButtonPress 1
MotionNotify "$3" "$4"
ButtonRelease 1" | xmacroplay :1 > /dev/null 2>&1 ; }

function rewind {
dragit 983 760 128 760
}

function vrewind {
dragit 1016 735 1016 1
}

function advance_right {
clickit 991 760 # coup à droite
}

function advance_down {
echo "KeyStrPress Next
Delay 1
KeyStrRelease Next" | xmacroplay :1 > /dev/null 2>&1 ;
#clickit 1016 736 # coup en bas
}
p=1
XYLIM=$((XYMAX+1))

while [ "$p" -lt "$PAGES" ]; do
pp=$(printf %04d $p)
x=0
y=0
while [ "$y" != "$XYLIM" ]; do
  echo -n "Capturing ($pp,$x,$y)"
  if [ "$MIXED" != "1" ]; then
    echo -n "*"
    xwd -silent -display :1 -id $IDWIN | xwdtopnm > ${DIRECTORY}/capture$pp-$x-$y.pnm 2>/dev/null
  fi
  if [ ! -f "${DIRECTORY}/capture${pp}-$x-$y.pnm" ]; then
    echo -n '!'
    xwd -silent -display :1 -id $IDWIN | xwdtopnm > ${DIRECTORY}/capture$pp-$x-$y.pnm 2>/dev/null
  fi
  echo -n "."
  left=8;top=8;right=8;bottom=8
  if [ "$x" == "0" ]; then
    left=0
  fi
  if [ "$y" == "0" ]; then
    top=0
  fi
  if [ "$y" == "$XYMAX" ]; then
    top=${XYCROP}
    bottom=0
  fi
  if [ "$x" == "$XXMAX" ]; then
    left=${XXCROP}
    right=0
  fi
  width=$((1008-left-right))
  height=$((752-top-bottom))
  pnmcut -left $left -width $width -top $top -height $height ${DIRECTORY}/capture$pp-$x-$y.pnm > ${DIRECTORY}/screen-$x-$y.pnm
  if [ "$x" != "0" ]; then
    pnmcat -lr ${DIRECTORY}/line-$y.pnm ${DIRECTORY}/screen-$x-$y.pnm > ${DIRECTORY}/new-$y.pnm
    rm ${DIRECTORY}/screen-$x-$y.pnm
    mv ${DIRECTORY}/new-$y.pnm ${DIRECTORY}/line-$y.pnm
  else
    mv ${DIRECTORY}/screen-$x-$y.pnm ${DIRECTORY}/line-$y.pnm
  fi
  if [ "$KEEPFILES" != 1 ]; then
    rm ${DIRECTORY}/capture$pp-$x-$y.pnm
  fi
  if [ "$x" == "$XXMAX" ]; then
    if [ "$NOCAP" != "1" ]; then
      rewind
      advance_down
    fi
    if [ "$y" == "0" ]; then
      mv ${DIRECTORY}/line-$y.pnm ${DIRECTORY}/page-${ZOOM}-${pp}.pnm
    else
      pnmcat -tb ${DIRECTORY}/page-${ZOOM}-${pp}.pnm ${DIRECTORY}/line-$y.pnm > ${DIRECTORY}/new.pnm
      rm ${DIRECTORY}/line-$y.pnm
      mv ${DIRECTORY}/new.pnm ${DIRECTORY}/page-${ZOOM}-${pp}.pnm
    fi
    x=0
    y=$((y+1))
  else
    x=$((x+1))
    if [ "$NOCAP" != "1" ]; then
      advance_right
    fi
  fi
  echo -n "."
  if [ "$NOCAP" != "1" ]; then
    sleep $DELAY
  fi
  echo "."
done
# For counters, cut out the crap
pnmcut -left 8 -right -8 -top 8 -bottom -8 < ${DIRECTORY}/page-${ZOOM}-${pp}.pnm | pnmcrop -sides|pnmcrop -white> ${DIRECTORY}/new.pnm
mv ${DIRECTORY}/new.pnm ${DIRECTORY}/page-${ZOOM}-${pp}.pnm
size=$(stat -c '%s' ${DIRECTORY}/page-${ZOOM}-${pp}.pnm)
if [ "$size" -gt 0 ]; then
    # Omit blank pages
    p=$((p+1))
fi
done
if [ "$NOCAP" != "1" ]; then
  vrewind
fi
# Edit pion.eps at the beginning
# /pagewidth 75 def
# /pageheight 75 def
# m4_include(MMMM_HOMEDIR/library/library.ps)
# /beginpagehook {
#     /face exch def /grandspions exch def /doubleface exch def
#     /format doubleface{grandspions{0}{2}ifelse face not{1 add}if}
#         {grandspions{4}{5}ifelse}ifelse def
#     /taillepions grandspions {45}{36}ifelse def
#     /nbpions [1 1 1 1 1 1]format get def
#     /comptepions nbpions def
#     cparray format page put
#     /Ymin pagewidth 20 sub taillepions sub def
#     /Xmin pageheight nbpions taillepions 1 add mul sub 2 div def
#     /rangeefinie true def
#     (0 G 0.9 g 1 w\n)out %initialisation état graphique
# }def
