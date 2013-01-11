#!/usr/bin/perl
while (<>) {
    if (m/([0-9\.]+) +([0-9\.]+) +([0-9\.]+) +([0-9\.]+) +([0-9\.]+) +([0-9\.]+)/) {
push @x, $1;
push @y, $2;
push @x, $3;
push @y, $4;
push @x, $5;
push @y, $6;
push @c, "c";
$a++;} elsif (m/([0-9\.]+) +([0-9\.]+) +([lm])/) {
push @x, $1;
push @y, $2;
push @c, $3;
$a++;
}
}
print "a=$a\n";
push @c,"m";
until ($a==0) {
    $c=pop @c;
    if ($c eq "c") {
    $x=pop @x;
    $y=pop @y;
    $xx=pop @x;
    $yy=pop @y;
    $xxx=pop @x;
    $yyy=pop @y;
    print "$x $y $xx $yy $xxx $yyy c\n";
    $a--;
    } else {
	$x=pop @x;
	$y=pop @y;
	print "$x $y $c\n";
	$a--;
    }
}
