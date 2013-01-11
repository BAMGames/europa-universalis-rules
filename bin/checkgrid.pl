#!/usr/bin/perl
# Lists all loops and multiple points
# degree not three
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
$count=0;
while (($key,$value) = each %beginpoint) {
    push @{$leadsto{$value}},$key;
}
while (($key,$value) = each %endpoint) {
    push @{$leadsto{$value}},$key." R";
}
$printed=0;
foreach (keys %leadsto) {
    @local=@{$leadsto{$_}};
    $toto=join(", ",@{$leadsto{$_}});
    if ($toto =~ /(path\w+),.*\1/) {
        print "Loops:\n" unless ($printed++);
	print "$#local:$_   -> $toto\n"; 
    } 
}
$printed=0;
foreach (keys %leadsto) {
    @local=@{$leadsto{$_}};
    @traits=grep(/^trait/,@local);
    $toto=join(", ",@{$leadsto{$_}});
    if (($#local-$#traits != 3)&&($#local-$#traits != 0)&&!(($#local-$#traits == 2)&&($toto =~ /(path\w+),.*\1/))) {
        print "Not meeting points:\n" unless ($printed++);
	print "(".($#local+1).",".($#traits+1)."):$_   -> $toto\n"; 
    } 
}
