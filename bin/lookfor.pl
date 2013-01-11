#!/usr/bin/perl
open CHEMINS,"chemins.eps";
$lx=shift;
$ly=shift;
$lexclude=shift;
@lignes=<CHEMINS>;
close CHEMINS;
$label="undefined";
$bdist=9000*9000+4000*4000;
$bbdist=$bdist;
$bx=-1;
$by=-1;
$bi=1;
$blabel=$label;
$bligne=$bbligne=$ligne=0;
sub compare {
    ($tx,$ty,$ti)=@_;
    return if ($label eq $lexclude);
    $dist=(($tx-$lx)*($tx-$lx)+($ty-$ly)*($ty-$ly))+$ti;
    if ($bdist>$dist) {
	$bbx=$bx;
	$bby=$by;
	$bbi=$bi;
	$bblabel=$blabel;
	$bbdist=$bdist;
	$bbligne=$bligne;

	$bdist=$dist;
	$bx=$tx;
	$by=$ty;
	$bi=$ti;
	$blabel=$label;
	$bligne=$ligne;
#	print "1:$bx,$by\n";
    } elsif ($bbdist>$dist) {
	$bbx=$tx;
	$bby=$ty;
	$bbi=$ti;
	$bblabel=$label;
	$bbdist=$dist;
	$bbligne=$ligne;
#	print "2:$bbx,$bby\n";
    }
}
foreach (@lignes) {
    $ligne++;
    $label=$1 if (m/^\/([a-z]+[0-9]+) beginpath/);
    compare($1,$2,0) if (m/([0-9\.]+) +([0-9\.]+) +([lm])/);
    if (m/([0-9\.]+) +([0-9\.]+) +([0-9\.]+) +([0-9\.]+) +([0-9\.]+) +([0-9\.]+) +c/) {
	compare($1,$2,1);compare($3,$4,1);compare($5,$6,0);
    }
}

print "($lx,$ly) -> ($bx $by) /$blabel\t(l. $bligne) ".($bi?"au milieu d'une courbe":"une extremité").".\n";
print " "x(2*length($lx)+4)."-> ($bbx $bby) /$bblabel\t(l. $bbligne) ".($bbi?"au milieu d'une courbe":"une extremité").".\n";
