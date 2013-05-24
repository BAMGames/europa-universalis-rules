#!/bin/sh
set -e
# cartetopng [-r precision]
# -r highres|lowres: select resolution
# This program takes file pions-ops.pdf and transforms all counters in
# single-sided correctly-named counter bitmaps in a directory bitmap-myres.
cd carte
#STATE="$binpath/statedisplay $XID"
STATE="echo"
KEEP=0
CRUSH=1
resol=1
xname=bitmap
if [ "$1" = "-r" ]; then shift
    case $1 in
        highres)
            resol=800
            bigtilesize=5689
            bigtilesizebc=5778
            pixelsx=38000
            pixelsy=26000
            maxzoom=8
            minzoom=8
            maxbigx=6
            maxbigy=4
            xxname=high
            ;;
        lowres)
            resol=400
            bigtilesize=2845
            bigtilesizebc=2889
            pixelsx=19000
            pixelsy=13000
            maxzoom=7
            minzoom=0
            xxname=low
            maxbigx=6
            maxbigy=4
            ;;
        pixres)
            resol=50
            bigtilesize=355
            bigtilesizebc=361
            pixelsx=2375
            pixelsy=1625
            maxzoom=4
            minzoom=0
            xxname=pix
            maxbigx=6
            maxbigy=4
            ;;
        *)
            echo "resolution unknown"
            exit 1
    esac
fi
DOCA="../$2"
DOCB="../$3"

[ "$resol" = 1 ] && exit 1
maxx=$((pixelsx/256))
maxy=$((pixelsy/256))

if [ ! -x /usr/bin/pngcrush ]; then CRUSH=0; fi
cd $HOMEDIR/carte
if [ ! -d ${xname} ]; then mkdir ${xname}; fi
cd ${xname}
if [ ! -d ../backup ]; then
    mkdir ../backup
fi

pgmtoppm white < ../blank.pnm > blank.pnm
convert blank.pnm blankX.png
pngcrush -rem bKGD -rem tEXt -q -force blankX.png blank.png
rm -f blankX.png
convert -resize ${bigtilesize}x${bigtilesize} blank.pnm bigblankX.pnm
pgmtoppm white < bigblankX.pnm > bigblank.pnm
rm -f bigblankX.pnm

voffset=$((bigtilesizebc-bigtilesize))
m=$(md5sum blank.pnm |cut -c1-32)
for z in $(seq $maxzoom -1 $minzoom); do
    if [ ! -d tile_$z ]; then
        mkdir tile_${z}
    fi
done
bigtilename() {
    bigtiletarget=$(printf "%02.2d%02.2d" $1 $2)
    bigtilefile="toto${resol}${bigtiletarget}.pnm"
}




requirebigtile() {
    bigtilename $1 $2
    if [ -e "$bigtilefile" ]; then
        return
    fi
    i=$1;j=$2
    if [ "$1" -le "$maxbigx" ]&&[ "$2" -le "$maxbigy" ]&&[ "$1" -ge 0 ]&&[ "$2" -ge 0 ]; then
        if [ ! -e "toto-${resol}-$bigtiletarget-1.ppm" ]; then
            $STATE "$CLASS" "bitmapping $bigtiletarget"
            a=$((i*1280));b=$((j*1280))
            c=$(printf "s/00000 00000 cm 00000 00000/-%4.4d -%4.4d cm 0%4.4d 0%4.4d/g" $a $b $a $b); sed -e "/%Clipping/ $c" < $DOCA > clipped.pdf
            if [ -e ../backup/toto-${resol}-${bigtiletarget}-1.png ]; then
                convert ../backup/toto-${resol}-${bigtiletarget}-1.png toto-${resol}-${bigtiletarget}-1.ppm
            else
                pdftoppm clipped.pdf -r $resol toto-${resol}-${bigtiletarget}
                cp toto-${resol}-${bigtiletarget}-1.ppm ../backup/
                convert ../backup/toto-${resol}-${bigtiletarget}-1.ppm ../backup/toto-${resol}-${bigtiletarget}-1.png
                rm ../backup/toto-${resol}-${bigtiletarget}-1.ppm 
            fi
        fi
        $STATE "$CLASS" "shaving $bigtiletarget"
        pnmcut -left 0 -bottom -1 -width $bigtilesize -height $bigtilesize toto-${resol}-$bigtiletarget-1.ppm > $bigtilefile
    else
        if [ "$1" -le "$maxbigx" ]&&[ "$2" -le $((2*maxbigy+1)) ]&&[ "$1" -ge 0 ]&&[ "$2" -gt "$maxbigy" ]; then
            if [ ! -e "toto$bigtiletarget-1.ppm" ]; then
                $STATE "$CLASS" "bitmapping $bigtiletarget"
                a=$((i*1280));b=$(( (j-maxbigy-1)*1280))
                c=$(printf "s/00000 00000 cm 00000 00000/-%4.4d -%4.4d cm 0%4.4d 0%4.4d/g" $a $b $a $b); sed -e "/%Clipping/ $c" < $DOCB > clipped.pdf
                if [ -e ../backup/toto-${resol}-${bigtiletarget}-1.png ]; then
                    convert ../backup/toto-${resol}-${bigtiletarget}-1.png toto-${resol}-${bigtiletarget}-1.ppm
                else
                    pdftoppm clipped.pdf -r $resol toto-${resol}-${bigtiletarget}
                    cp toto-${resol}-${bigtiletarget}-1.ppm ../backup/
                    convert ../backup/toto-${resol}-${bigtiletarget}-1.ppm ../backup/toto-${resol}-${bigtiletarget}-1.png
                    rm ../backup/toto-${resol}-${bigtiletarget}-1.ppm 
                fi
            fi
            $STATE "$CLASS" "shaving $bigtiletarget"
            pnmcut -left 0 -bottom -1 -width $bigtilesize -height $bigtilesize toto-${resol}-$bigtiletarget-1.ppm > $bigtilefile
        else
            $STATE "$CLASS" "inventing $bigtiletarget"
            ln -s "bigblank.pnm" "$bigtilefile"
        fi
    fi
}

z=$maxzoom
zz=$(printf "%2.2d" $z)
XDEBUG=true

tilename() {
    ttname=$(printf "%d/%d_%d" $1 $2 $3)
    tname=tile_$ttname.pnm
}

othertilenamea() {
    otnamea=$(printf "tile_%d/%d_%d.pnm" $1 $2 $3)
    requiretile $1 $2 $3
}
othertilenameb() {
    otnameb=$(printf "tile_%d/%d_%d.pnm" $1 $2 $3)
    requiretile $1 $2 $3
}

requiretile() {
    local ttname=$(printf "%d/%d_%d" $1 $2 $3)
    local tname=tile_$ttname.pnm
    local z=$1
    local ax=$2
    local ay=$3
    local x
    local y
    local zz
    if [ -f "$tname" ]&&[ "$(stat -c %s "$tname")" = 0 ]; then
        rm -f "$tname"
    fi
    if [ -e "$tname" ]; then
        return
    fi
    if [ "$z" = "$maxzoom" ]; then
        case $z in
            4)
                zz=16;;
            7)
                zz=2;;
            8)
                zz=1;;
        esac
        if [ "$ax" = 169 ]|| [ "$ax" = 170 ]; then
            if [ "$ay" = 97 ]; then
                set -x
            fi
        fi
    # Compute ll-origin in zoom 8 pixels, offset, go back to zoom z
        x=$(( ((ax*256*$zz)-3500)/$zz ))
        y=$(( ((ay*256*$zz)-3500)/$zz ))
      # Extract from big tiles
        $STATE "$CLASS" "$ttname"
        lltx=$(( x/bigtilesize ))
        llx=$(( x%bigtilesize ))
        urtx=$(( (x+255)/bigtilesize ))
        urx=$(( (x+255)%bigtilesize ))
        llty=$(( y/bigtilesize ))
        lly=$(( y%bigtilesize ))
        urty=$(( (y+255)/bigtilesize ))
        ury=$(( (y+255)%bigtilesize ))
        if [ "$llx" -lt 0 ]; then llx=$((llx+bigtilesize));lltx=$((lltx-1)); fi
        if [ "$urx" -lt 0 ]; then urx=$((urx+bigtilesize));urtx=$((urtx-1)); fi
        if [ "$lly" -lt 0 ]; then lly=$((lly+bigtilesize));llty=$((llty-1)); fi
        if [ "$ury" -lt 0 ]; then ury=$((ury+bigtilesize));urty=$((urty-1)); fi
        requirebigtile $lltx $llty
        requirebigtile $lltx $urty
        requirebigtile $urtx $llty
        requirebigtile $urtx $urty
        if [ "$urtx" = "$lltx" ]; then
            if [ "$urty" = "$llty" ]; then
                # One bigtile
                $XDEBUG "From ($lltx,$llty) 256x256+$llx+$lly"
                requirebigtile $lltx $llty
                pnmcut -bottom $((bigtilesize-lly-1)) -left $llx -width 256 -height 256 $bigtilefile > $tname
            else
                # Two vertical
                requirebigtile $lltx $llty
                pnmcut -bottom $((bigtilesize-lly-1)) -left $llx -width 256 -height $((bigtilesize-lly)) $bigtilefile > part0.pnm
                requirebigtile $lltx $urty
                pnmcut -bottom -1 -left $llx -width 256 -height $((ury+1)) $bigtilefile > part1.pnm
                pnmcat -tb part1.pnm part0.pnm > $tname
                $XDEBUG "From ($lltx,$llty) 256x$((bigtilesize-lly))+$llx+$lly"
                $XDEBUG "From ($lltx,$urty) 256x$((ury+1))+$lly+0"
            fi
        else
            if [ "$urty" = "$llty" ]; then
                # Two horizontal
                requirebigtile $lltx $llty
                pnmcut -bottom $((bigtilesize-lly-1)) -left $llx -width $((bigtilesize-llx)) -height 256 $bigtilefile > part0.pnm
                requirebigtile $urtx $llty
                pnmcut -bottom $((bigtilesize-lly-1)) -left 0 -width $((urx+1)) -height 256 $bigtilefile > part1.pnm
                pnmcat -lr part0.pnm part1.pnm > $tname
                $XDEBUG "From ($lltx,$llty) $((bigtilesize-llx))x256+$llx+$lly"
                $XDEBUG "From ($urtx,$llty) $((urx+1))x256+0+$lly"
            else
                # Four across
                requirebigtile $lltx $llty
                pnmcut -bottom $((bigtilesize-lly-1)) -left $llx -width $((bigtilesize-llx)) -height $((bigtilesize-lly)) $bigtilefile > part0.pnm
                requirebigtile $urtx $llty
                pnmcut -bottom $((bigtilesize-lly-1)) -left 0 -width $((urx+1)) -height $((bigtilesize-lly)) $bigtilefile > part1.pnm
                pnmcat -lr part0.pnm part1.pnm > part2.pnm
                requirebigtile $lltx $urty
                pnmcut -bottom -1 -left $llx -width $((bigtilesize-llx)) -height $((ury+1)) $bigtilefile > part0.pnm
                requirebigtile $urtx $urty
                pnmcut -bottom -1 -left 0 -width $((urx+1)) -height $((ury+1)) $bigtilefile > part1.pnm
                pnmcat -lr part0.pnm part1.pnm > part3.pnm
                pnmcat -tb part3.pnm part2.pnm > $tname
                $XDEBUG "From ($lltx,$llty) $((bigtilesize-llx))x$((bigtilesize-llx))+$llx+$lly"
                $XDEBUG "From ($urtx,$llty) $((urx+1))x$((bigtilesize-llx))+0+$lly"
                $XDEBUG "From ($lltx,$urty) $((bigtilesize-llx))x$((ury+1))+$llx+0"
                $XDEBUG "From ($urtx,$urty) $((urx+1))x$((ury+1))+0+0"
            fi
        fi
    else
        x=$ax
        y=$ay
        # reduce
        $STATE "$CLASS" "$ttname"
        othertilenamea $((z+1)) $((x*2)) $((y*2))
        othertilenameb $((z+1)) $((x*2+1)) $((y*2))
        otnameaa=$otnamea;otnamebb=$otnameb
        othertilenamea $((z+1)) $((x*2)) $((y*2+1))
        othertilenameb $((z+1)) $((x*2+1)) $((y*2+1))
        if [ -L $otnameaa ]&&[ -L $otnameb ]&&[ -L $otnamea ]&&[ -L $otnamebb ]; then
            ln -s ../blank.pnm $tname
        else
            pnmcat -lr $otnameaa $otnamebb > part0.pnm
            pnmcat -lr $otnamea $otnameb > part1.pnm
            pnmcat -tb part1.pnm part0.pnm > part2.pnm
            pnmscalefixed -reduce 2 part2.pnm > $tname 2>/dev/null
        fi
    fi
    if [ ! -L "$tname" ]; then
        n=$(md5sum $tname |cut -c1-32)
        if [ "$n" = "$m" ]; then
            rm $tname; ln -s ../blank.pnm $tname
        fi
    fi
    if [ "$ax" = 169 ]|| [ "$ax" = 170 ]; then
        if [ "$ay" = 97 ]; then
            hexdump -C $tname
            set +x
        fi
    fi
}


for z in $(seq $maxzoom -1 $minzoom); do
    for x in $(seq 0 $(echo "2^${z}-1"|bc)); do
        for y in $(seq 0 $(echo "2^${z}-1"|bc)); do
            tilename $z $x $y
            if [ ! -e tile_${ttname}.png ]; then
                if [ ! -e tile_${ttname}.pnm ]; then
                    requiretile $z $x $y
                    tilename $z $x $y
                fi
            fi
            if [ ! -e tile_${ttname}.png ]; then
#                $STATE "$CLASS" ">$ttname"
                if [ -L $tname ]; then
                    ln -s ../blank.png tile_${ttname}.png
                else
                    convert $tname tile_${ttname}X.png
                    pngcrush -rem bKGD -rem tEXt -q -force tile_${ttname}X.png tile_$ttname.png
                    rm -f tile_${ttname}X.png
                fi
            fi
        done
    done
done
for z in $(seq $maxzoom -1 $minzoom); do
    $STATE "$CLASS" "manifest (zoom $z)"
    cat ../manifest.txt | grep -v tile_${z}/ > manifest.txt
    cp manifest.txt ../manifest.txt
    find tile_${z} -type f -name "*.png"|while read ff; do
        f=tile_${z}/$(basename $ff)
        sum=$(md5sum "$f"|cut -c1-32)
        bytes=$(stat -c %s "$f")
        size="Z"
        printf "%s %s %s %s\n" $sum $size $bytes $f >> ../manifest.txt
    done
    find tile_${z} -type l -name "*.png"|while read ff; do
        sum=00000000000000000000000000000000
        f=tile_${z}/$(basename $ff)
        d=$(readlink "$f")
        size="Z"
        printf "%s %s %s %s\n" $sum $size $d $f >> ../manifest.txt
    done
done
if [ "$minzoom" = 0 ]; then 
    cat ../manifest.txt | grep -v ' blank.png' > manifest.txt
    cp manifest.txt ../manifest.txt
    f="blank.png"
    sum=$(md5sum "$f"|cut -c1-32)
    bytes=$(stat -c %s "$f")
    size="Z"    
    printf "%s %s %s %s\n" $sum $size $bytes $f >> ../manifest.txt
fi
cp ../manifest.txt manifest.txt
cat manifest.txt|sort -k 4 -t ' ' > ../manifest.txt
rm -f manifest.txt
cp ../manifest.txt manifest.txt
rm -f manifest.txt.bz2
bzip2 -9 manifest.txt
cp manifest.txt.bz2 ../
$STATE "$CLASS" "cleaning"
rm -f *.ppm *.pnm */*.pnm clipped.pdf 2>&1 > /dev/null
cd ../
rm -f manifest.txt
bunzip2 -k manifest.txt.bz2
