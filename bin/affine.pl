#!/usr/bin/perl
# Do an affine transformation (angle dx dy)
use POSIX;
sub atan { (atan2($_[1],$_[0])/3.141592653*180) } 
($enlarge,$angle,$dx,$dy)=@ARGV;
shift; shift; shift; shift;
$angle=$angle*1.5707963267949/90;
while($ligne=<>) {
    chomp $ligne;
    while ($ligne =~ m/^(.*?)([0-9]+) ([0-9]+) (.*)$/) {
	($a,$b,$c,$d)=($1,$2,$3,$4);
	$bb=$b*cos($angle)+$c*sin($angle);
	$cc=-$b*sin($angle)+$c*cos($angle);
	$bb=POSIX::floor($enlarge*$bb+$dx+0.5);
	$cc=POSIX::floor($enlarge*$cc+$dy+0.5);
	$b=sprintf("%04d",$bb);
	$c=sprintf("%04d",$cc);
	$ligne="$a$b#$c#$d";
    }
    $ligne =~ s/#/ /g;
    print "$ligne\n";
}
