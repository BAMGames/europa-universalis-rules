#!/usr/bin/perl
# This script looks for paths attached
# to a specific (or list of) path given
# by name and number. Use "123R" to designate
# path123 in reverse
use POSIX;
%doublon=();
%hash=();
%types=();
open CHEMINS,"chemins.eps";
@lignes=<CHEMINS>;
close CHEMINS;
$label="undef";
$needspoint=0;
foreach (@lignes) {
    if (m/\/([a-z]+[0-9]+) beginpath( contpath)?/) {
	$label=$1;
	if ($2 eq " contpath") {
	    $beginpoint{$label}=$lastpoint;
	    $needspoint=1;
	}
    } elsif (m/^endpath/) {
	$endpoint{$label}=$lastpoint;
	$forendpoint{$label}=$forelastpoint;
	$label="undef";
    } elsif (m/^([0-9]+ +[0-9]+) +m/) {
	$beginpoint{$label}=$1;
	$needspoint=1;
	$lastpoint=$1;$forelastpoint=$1;
    } elsif (m/^([0-9]+ +[0-9]+) +l/) {
	if ($needspoint) {$secondpoint{$label}=$1;$needspoint=0;}
	$forelastpoint=$lastpoint;
	$lastpoint=$1;
    } elsif (m/^([0-9]+ +[0-9]+) +([0-9]+ +[0-9]+) +([0-9]+ +[0-9]+) +c/) {
	if ($needspoint) {$secondpoint{$label}=$1;$needspoint=0;}
	$forelastpoint=$2;
	$lastpoint=$3;
    }
}
while (($key,$value) = each %beginpoint) {
    push @{$leadsto{$value}},$key;
}
while (($key,$value) = each %endpoint) {
    push @{$leadsto{$value}},$key." R";
}

foreach (@ARGV) {
    next if (/^R$/);
    $_="path$_" if (/^[0-9]+$/);
    $patback="^$_\$";
    $patfor="^$_ R\$";
    @backward=grep(!/$patback/,@{$leadsto{$beginpoint{$_}}});
    @forward=grep(!/$patfor/,@{$leadsto{$endpoint{$_}}});
    print "$_   -> ",join(", ",@forward),"\n";
    print "$_ R -> ",join(", ",@backward),"\n";
}
