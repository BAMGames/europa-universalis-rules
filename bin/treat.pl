#!/usr/bin/perl
use POSIX;
$sc=1.5;$sca=1;$xoffset=-600;$yoffset=0;
sub transform {
    my @a;my $offset=$yoffset;
    return map {$offset=$xoffset+$yoffset-$offset;(POSIX::floor(($_<5666)?$_*$sc:(($_-5666)/2+5666)*$sc)+$offset)} @_;
}
while (<>) {
    chomp;
    if (/ c $/) {
	my @a;
	m/^([0-9.]+) +([0-9.]+) +([0-9.]+) +([0-9.]+) +([0-9.]+) +([0-9.]+) +c ?$/;
	@a=transform($1,$2,$3,$4,$5,$6);
	printf "".("%04d "x6)."c\n",@a;
    } elsif (/ l ?$/) {
	my @a;
	m/^([0-9.]+) +([0-9.]+) +l ?$/;
	@a=transform($1,$2);
	printf "".("%04d "x2)."l\n",@a;
    } elsif (/ m ?$/) {
	my @a;
	m/^([0-9.]+) +([0-9.]+) +m ?$/;
	@a=transform($1,$2);
	printf "".("%04d "x2)."m\n",@a;
    } elsif (/^%%BoundingBox: ([0-9.]+) +([0-9.]+) +([0-9.]+) +([0-9.]+).*$/){
	my @a;
	@a=transform($1,$2,$3,$4);
	$a[0]=0;$a[1]=0;
	$a[2]=POSIX::ceil($a[2]*$sca);$a[3]=POSIX::ceil($a[3]*$sca);
	printf "%%%%BoundingBox: ".("%04d "x4)."\n",@a;
    } elsif (/^\/S /){
	print "/cw 5 def cw setlinewidth\n/S { stroke cw setlinewidth } bd\n/mar {1 0 0 setrgbcolor 10 setlinewidth /cw 1 def} bd\n";
    } elsif (/^%%EndSetup/){
	print "$_\n$sca dup scale\n";
    } elsif (/^\*U$/){
        my @orig=(4337,552);
	my @size=(457,552);
	my $ca=0.552239716;
	my @coeff=(-1,-$ca,0,$ca,1);
	foreach $i (0..4) {
	  $cx[$i]=$orig[0]+$coeff[$i]*$size[0];
	  $cy[$i]=$orig[1]+$coeff[$i]*$size[1];
	}
    	my @a=transform($cx[2],$cy[4]);
	printf "".("%04d "x2)."m\n",@a;
    	my @a=transform($cx[1],$cy[4],$cx[0],$cy[3],$cx[0],$cy[2]);
	printf "".("%04d "x6)."c\n",@a;
    	my @a=transform($cx[0],$cy[1],$cx[1],$cy[0],$cx[2],$cy[0]);
	printf "".("%04d "x6)."c\n",@a;
    	my @a=transform($cx[3],$cy[0],$cx[4],$cy[1],$cx[4],$cy[2]);
	printf "".("%04d "x6)."c\n",@a;
    	my @a=transform($cx[4],$cy[3],$cx[3],$cy[4],$cx[2],$cy[4]);
	printf "".("%04d "x6)."c\n",@a;
	print "S\n";
        my @a=transform(400,1205);
        printf "".("%04d "x2)."m\n",@a;
        my @a=transform(1436,1205);
        printf "".("%04d "x2)."l\n",@a;
        my @a=transform(1675,786);
        printf "".("%04d "x2)."l\n",@a;
        my @a=transform(985,0);
        printf "".("%04d "x2)."l\n",@a;
        my @a=transform(400,0);
        printf "".("%04d "x2)."l\n",@a;
        my @a=transform(400,1205);
        printf "".("%04d "x2)."l\n",@a;
	print "S\n$_\n";
    } else {
	print "$_\n";
    }
}
