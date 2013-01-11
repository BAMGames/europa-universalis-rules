#!/usr/bin/perl
# This script is used to find loose ends of a path and fix those
# so that the path is attached to formerly defined paths
# Launch it with $0 pathnumber test
use POSIX;
open CHEMINS,"chemins.eps";
%doublon=();
$test=1 if $ARGV[1]=~ /[A-Za-z]+/;
$ENDNOT=$test;
$BEGINNOT=$test;
$ENDNOT=0 if $ARGV[1]=~ /END/;
$BEGINNOT=0 if $ARGV[1]=~ /BEGIN/;
$test=$ENDNOT*$BEGINNOT;
print "#"x80,"\n#"," "x34,"MODE TEST"," "x35,"#\n","#"x80,"\n" if ($test);
$mypath=shift;
@lignes=<CHEMINS>;
close CHEMINS;
foreach (@lignes) {
    chomp;
}
@beginpaths=grep /^.path[0-9]+ beginpath/,@lignes;
foreach (@beginpaths) {
    if (m/^\/path([0-9]+) beginpath/) {
	die "Double définition de /$1\n" if ($doublon{"path$1"}++);
    }
}
@beginpaths=grep /^.bord[0-9]+ beginpath/,@lignes;
foreach (@beginpaths) {
    if (m/^\/bord([0-9]+) beginpath/) {
	die "Double définition de /$1\n" if ($doublon{"bord$1"}++);
    }
}
open CHEMINS,">chemins.eps.old";
print CHEMINS join("\n",@lignes);
close CHEMINS;
$pattern="^/[pb][ao][tr][hd]".$mypath.' beginpath$';
$lexclude="path$mypath";
$begligne=$movligne=$endligne=0;
$beginc=$movinc=$endinc=1;
foreach (@lignes) {
    $beginc=0 if /$pattern/;
    $movinc=0 if (/ m$/ and $beginc==0);
    $endinc=0 if (/^endpath/ and $movinc==0);
    $begligne+=$beginc;
    $movligne+=$movinc;
    $endligne+=$endinc;
}
$realendligne=$endligne;
do {
    $endligne--;
} until ($lignes[$endligne]=~/([0-9]+) +([0-9]+) +([lc])$/);
($endpointx,$endpointy,$endcurve)=($1,$2,$3);
print "For $mypath, found endpoint at ($endpointx,$endpointy,$endcurve)\n";
die unless ($lignes[$movligne]=~/^([0-9]+) +([0-9]+) +m$/);
($begpointx,$begpointy)=($1,$2);
#print $lignes[$begligne];
#print $lignes[$movligne];
#print $lignes[$endligne];
#print $lignes[$realendligne];
#print "----\n";
print "($begpointx,$begpointy),($endpointx,$endpointy)\n" if ($test);
#print "----\n";
if ($begpointx==$endpointx && $begpointy==$endpointy) {
    print "CYCLE.\n\n";
    goto THEEND;
}
$label="undefined";
$bdist=$edist=9000*9000+4000*4000;
$bx=$ex=-1;
$by=$ey=-1;
$bi=$ei=1;
$blabel=$elabel=$label;
$bligne=$eligne=$ligne=0;
sub compare {
    ($tx,$ty,$ti)=@_;
#    return if ($label eq $lexclude);
    ($lx,$ly)=($begpointx,$begpointy);
    $dist=(($tx-$lx)*($tx-$lx)+($ty-$ly)*($ty-$ly))+$ti;
    if (($bdist>$dist) && (abs($movligne-$ligne)>1)) {
	$bdist=$dist;
	$bx=$tx;
	$by=$ty;
	$bi=$ti;
	$blabel=$label;
	$bligne=$ligne;
    }
    ($lx,$ly)=($endpointx,$endpointy);
    $dist=(($tx-$lx)*($tx-$lx)+($ty-$ly)*($ty-$ly))+$ti;
    if (($edist>$dist) && (abs($endligne-$ligne)>1)) {
	$edist=$dist;
	$ex=$tx;
	$ey=$ty;
	$ei=$ti;
	$elabel=$label;
	$eligne=$ligne;
    }
}
foreach (@lignes) {
    $ligne++;
    $label=$1 if (m/^\/([a-z]+[0-9]+) beginpath/);
    compare($1,$2,0) if (m/([0-9\.]+) +([0-9\.]+) +([lm])/);
    if (m/([0-9\.]+) +([0-9\.]+) +([0-9\.]+) +([0-9\.]+) +([0-9\.]+) +([0-9\.]+) +c/) {
	#compare($1,$2,2);compare($3,$4,1);
	compare($5,$6,0);
    }
}
print "----\n";
print $bligne," ",$bdist,":",POSIX::ceil(sqrt($bdist)),"\n";
print $eligne," ",$edist,":",POSIX::ceil(sqrt($edist)),"\n";
if ($blabel=~/path([0-9]*)([0-9][0-9][0-9][0-9])/) {
    $blabelnum =$2;$blabelhead="path";
} elsif ($blabel=~/bord([0-9]*)([0-9][0-9])/) {
    $blabelnum=$2;$blabelhead="bord";
} elsif ($blabel=~/path([0-9]*)([0-9][0-9][0-9])/) {
    $blabelnum =$2;$blabelhead="path";
} elsif ($blabel=~/path([0-9]*)([0-9][0-9])/) {
    $blabelnum =$2;$blabelhead="path";
}
foreach (1..20) {
    $bsupp=$_;last if (!$doublon{$blabelhead.$bsupp.$blabelnum});
}
$doublon{$blabelhead.$bsupp.$blabelnum}++;

if ($elabel=~/path([0-9]*)([0-9][0-9][0-9][0-9])/) {
    $elabelnum =$2;$elabelhead="path";
} elsif ($elabel=~/bord([0-9]*)([0-9][0-9])/) {
    $elabelnum=$2;$elabelhead="bord";
} elsif ($elabel=~/path([0-9]*)([0-9][0-9][0-9])/) {
    $elabelnum =$2;$elabelhead="path";
} elsif ($elabel=~/path([0-9]*)([0-9][0-9])/) {
    $elabelnum =$2;$elabelhead="path";
}
foreach (1..20) {
    $esupp=$_;last if (!$doublon{$elabelhead.$esupp.$elabelnum});
}




print "$blabelhead$bsupp$blabelnum et $elabelhead$esupp$elabelnum\n";
print "----\n";
print "($movligne)<$lignes[$movligne]>: s/$begpointx +$begpointy +m/$bx $by m/\n";
print "($endligne)<$lignes[$endligne]>: s/$endpointx +$endpointy +$endcurve/$ex $ey $endcurve/\n";
foreach ($begligne+1..$movligne-1) {
    print "($_)<$lignes[$_]>: delete\n";
}
foreach ($endligne+1..$realendligne-1) {
    print "($_)<$lignes[$_]>: delete\n";
}
print "(".($bligne-1).")<$lignes[$bligne-1]>: ajout de endpath\\n/$blabelhead$bsupp$blabelnum beginpath contpath\n";
print "(".($eligne-1).")<$lignes[$eligne-1]>: ajout de endpath\\n/$elabelhead$esupp$elabelnum beginpath contpath\n";

$lignes[$bligne-1].="\nendpath\n/$blabelhead$bsupp$blabelnum beginpath contpath" unless ($BEGINNOT);
$lignes[$eligne-1].="\nendpath\n/$elabelhead$esupp$elabelnum beginpath contpath" unless ($ENDNOT);
$lignes[$movligne]=~s/$begpointx +$begpointy +m/$bx $by m/ unless ($BEGINNOT);
$lignes[$endligne]=~s/$endpointx +$endpointy +$endcurve/$ex $ey $endcurve/ unless ($ENDNOT);
THEEND:
@lignes=(@lignes[0..$begligne],@lignes[$movligne..$endligne],@lignes[$realendligne..$#lignes]);
exit 0 if $test;
open CHEMINS,">chemins.eps";
print CHEMINS join("\n",@lignes);
close CHEMINS;
