#!/bin/sh
set -e
# pionstopng [-k] [-c] [-u] [-r precision]
# -k: keep temporary files, for debugging
# -c: crush the png files (useless)
# -u: do not crush the png files (for debugging)
# -r highres|lowres: select resolution
# This program takes file pions-ops.pdf and transforms all counters in
# single-sided correctly-named counter bitmaps in a directory bitmap-myres.
CLASS="Creating bitmap counters"
cwd=$(pwd)
cd $BINDIR
binpath=$(pwd)
cd $cwd
STATE="$binpath/statedisplay $XID"
KEEP=0;
CRUSH=1;
resol=400
croplarge=248x248+154+109
cropsmall=198x198+179+109
xname=bitmap
zoomlevel=7
minzoomlevel=2
if [ "$1" = "-k" ]; then KEEP=1; shift; fi
if [ "$1" = "-c" ]; then CRUSH=1; shift; fi
if [ "$1" = "-u" ]; then CRUSH=0; shift; fi
if [ "$1" = "-r" ]; then shift
    case $1 in
        highres)
            resol=800
            croplarge=498x498+307+218
            cropsmall=398x398+357+218
            xname=bitmap
            zoomlevel=8
            minzoomlevel=8
            ;;
        lowres)
            resol=400
            croplarge=248x248+154+109
            cropsmall=198x198+179+109
            xname=bitmap
            zoomlevel=7
            minzoomlevel=2
            ;;
        *)
            echo "resolution unknown"
            exit 1
    esac
fi

if [ ! -x /usr/bin/pngcrush ]; then CRUSH=0; fi
cd $HOMEDIR/pions
if [ ! -d ${xname} ]; then mkdir ${xname}; fi
cd ${xname}
for i in $(seq $minzoomlevel $zoomlevel); do
    if [ ! -d "counter_$i" ]; then mkdir "counter_$i"; fi
done

$STATE "$CLASS" $xname
sed -ne '/^.DS/ {s/^\(.\)...#\([^#]*\)#.*$/\1%\2_recto/g;p;s/_recto$/_verso/g p}' -e '/^.SS/ {s/^\(.\)...#\([^#]*\)#.*$/\1%\2/g;p}' < ../counters.txt > filenames.txt
REDO=0
if [ ! -f "toto-0001.ppm" ]; then
    if [ "$REDO" -lt 1 ]; then $STATE "$CLASS" "no images"; fi
    REDO=1
fi
max=$(wc -l filenames.txt|cut -f1 -d' ')
if [ ! -f "toto-$max.ppm" ]; then
    if [ "$REDO" -lt 1 ]; then $STATE "$CLASS" "not enough images"; fi
    REDO=1
fi
b=$((max+1))
if [ -f "toto-$b.ppm" ]; then
    if [ "$REDO" -lt 1 ]; then $STATE "$CLASS" "too many images"; fi
    REDO=1
    mv "toto-$b.ppm" "toto-$b.ppm.old"
fi
if [ "$REDO" -gt 0 ]; then
    $STATE "$CLASS" "redoing"
    rm -f toto-*.ppm >/dev/null 2>&1
    find . -name '*.png'|grep -v counter_[0-$((minzoomlevel-1))]|grep -v counter_[$((zoomlevel+1))-9]|xargs --no-run-if-empty rm >/dev/null 2>&1
    (pdftoppm ../pions-ops.pdf -r $resol toto)&
else
    $STATE "$CLASS" "not redoing"
fi
num=0
waited=0
zz=$((zoomlevel-1))

prefix=$($STATE "multiple" "$CLASS" "build:00000/$max")
$STATE "$CLASS" "build:00000/$max"
while read a; do
    num=$((num+1))
    size="${a%%%*}"
    name="${a#*%}";
    xnum=$(printf "%04d" $num)
    nnum=$(printf "%04d" $((num+1)))
    trg="toto-$xnum.ppm"
    ntrg="toto-$nnum.ppm"
    while [ \( ! -f "$ntrg" \) -a \( "$num" -lt "$max" \) ]; do
	waited=$((waited+1))
	sleep 1
    done
    while [ ! -f "$trg" ]; do
	waited=$((waited+1))
	sleep 1
    done
    printf "%s[build:%05d/$max]\n" "$prefix" "$num"
    waited=0
    if [ ! -f "$name.png" ]; then
	if [ "$size" = "L" ]; then
	    convert -crop $croplarge -bordercolor black -border 1 $trg +repage $name.png
	else
	    convert -crop $cropsmall -bordercolor black -border 1 $trg +repage $name.png
	fi
    fi
    if [ "${name}" != "${name##Manufacture}" ]; then
	cp ${name}.png ${name}.old.png
	convert $name.old.png ../masqueMNU$resol.png -compose CopyOpacity -composite $name.png
	rm $name.old.png
    fi
    if [ "$KEEP" -lt 1 ]; then rm $trg; fi
    mv ${name}.png counter_${zoomlevel}/${name}.png
    for z in $(seq $zz -1 $minzoomlevel); do
        convert -resize '50%' counter_$((z+1))/${name}.png counter_${z}/${name}.png
    done
done < filenames.txt
rm filenames.txt
FILES=""
for z in $(seq $zoomlevel -1 $minzoomlevel); do
    FILES="$FILES $(ls counter_${z}/*.png)"
done
max=$(printf "%05d" $(echo "$FILES"|wc -w))
if [ "$CRUSH" -gt 0 ]; then
    cd ../
    rm -rf crush${xname}
    mkdir crush${xname}
    for z in $(seq $zoomlevel -1 $minzoomlevel); do
        (pngcrush -rem bKGD -rem tEXt -q -force -d crush${xname}/counter_${z} ${xname}/counter_${z}/*.png > /dev/null 2>&1)&
        sleep 2
    done
    cd crush${xname}
    num=0
    for f in $FILES; do
        while [ ! -f "$f" ]; do
            sleep 1
        done
        num=$((num+1))
        printf "%s[crush:%05d/$max]\n" "$prefix" "$num"
    done
    sleep 2
    cd ..
    for f in $FILES; do
        mv crush${xname}/$f ${xname}/$f
    done
    rm -rf crush${xname}
fi
cd $cwd
cd $xname
for z in $(seq $zoomlevel -1 $minzoomlevel); do
    $STATE "$CLASS" "manifest (zoom $z)"
    cat ../manifest.txt | grep -v counter_${z}/ > manifest.txt
    cp manifest.txt ../manifest.txt
    for f in counter_${z}/*.png; do
        sum=$(md5sum "$f"|cut -c1-32)
        bytes=$(stat -c %s "$f")
        size=$(identify "$f"|cut -f3 -d' '|cut -f1 -dx)
        case $size in
            500)
                size=A;;
            250)
                size=B;;
            125)
                size=C;;
            63)
                size=D;;
            32)
                size=E;;
            16)
                size=F;;
            8)
                size=G;;
            400)
                size=M;;
            200)
                size=N;;
            100)
                size=O;;
            50)
                size=P;;
            25)
                size=Q;;
            13)
                size=R;;
            7)
                size=S;;
            *)
                size=X;;
        esac
        printf "%s %s %s %s\n" $sum $size $bytes $f >> ../manifest.txt
    done
done
cp ../manifest.txt manifest.txt
cat manifest.txt|sort -k 4 > ../manifest.txt
rm -f manifest.txt
cp ../manifest.txt manifest.txt
rm -f manifest.txt.bz2
bzip2 -9 manifest.txt
cp manifest.txt.bz2 ../
cd ../
rm -f manifest.txt
bunzip2 -k manifest.txt.bz2
