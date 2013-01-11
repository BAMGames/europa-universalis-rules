#!/usr/bin/perl
use POSIX;
sub atan { (atan2($_[1],$_[0])/3.141592653*180) }
if ($ARGV[0] =~ /--silent/) {shift @ARGV;$silent=1;}
$terrain="terrain";
if ($ARGV[0] =~ /--(.*)/) {$terrain=$1;shift @ARGV;}
%doublon=();
%hash=();
%types=();
open CHEMINS,"chemins.eps";
@lignes=<CHEMINS>;
close CHEMINS;
$label="undef";
$needspoint=0;
@provlines=grep(/^.prov/,@lignes);
$provline=$provlines[$#provlines];
$provline =~ m/^.prov([0-9]+)/;
$maxprov=$1+1;
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
    } elsif (m/([0-9]+ +[0-9]+) +m/) {
	$beginpoint{$label}=$1;
	$needspoint=1;
	$lastpoint=$1;$forelastpoint=$1;
    } elsif (m/([0-9]+ +[0-9]+) +l/) {
	if ($needspoint) {$secondpoint{$label}=$1;$needspoint=0;}
	$forelastpoint=$lastpoint;
	$lastpoint=$1;
    } elsif (m/([0-9]+ +[0-9]+) +([0-9]+ +[0-9]+) +([0-9]+ +[0-9]+) +c/) {
	if ($needspoint) {$secondpoint{$label}=$1;$needspoint=0;}
	$forelastpoint=$2;
	$lastpoint=$3;
    }
}
while (($key,$value) = each %beginpoint) {
    $value =~ m/([0-9]+) +([0-9]+)/;
    ($ax,$ay)=($1,$2);
    $secondpoint{$key} =~ m/([0-9]+) +([0-9]+)/;
    ($bx,$by)=($1,$2);
    $angle=atan(($bx-$ax),($by-$ay));
    push @{$leadsto{$value}},[$key,$angle];
}
while (($key,$value) = each %endpoint) {
    $value =~ m/([0-9]+) +([0-9]+)/;
    ($ax,$ay)=($1,$2);
    $forendpoint{$key} =~ m/([0-9]+) +([0-9]+)/;
    ($bx,$by)=($1,$2);
    $angle=atan(($bx-$ax),($by-$ay));
    push @{$leadsto{$value}},[$key." R",$angle];
}


foreach (keys %leadsto) {
    @local=@{$leadsto{$_}};
    @toto=sort {${$a}[1] <=> ${$b}[1]} @local;
    @sommetstries=();
    foreach (@toto) {push @sommetstries,${$_}[0];}
    push @{$leadstosorted{$_}},@sommetstries;
}
foreach (@ARGV) {
    @contour=();
    $_="path".$_ if (/^[0-9]+$/);
    if (/^([0-9]+)R$/) {$_="path".$1." R";}
    $current=$_;
    m/([^ ]*)( R)?/;
    $origin=$1;
    die "Argh! $origin not found\n" unless $beginpoint{$origin};
    do {
	push @contour,$current;
	if ($current =~ /(.*) R/) {
	    $tolook=$1;
	    $pointl=$beginpoint{$tolook};
	} else  {
	    $tolook=$current." R";
	    $pointl=$endpoint{$current};
	}
	@circular=@{$leadstosorted{$pointl}};
	print "$current -> ",join(" ",@circular),"\n" unless ($silent);
	LOOP: for (0..$#circular) {
	    $i=$_;last LOOP if ($circular[$i] =~ /$tolook/);
	}
	$i--;
	$i=$#circular if ($i==-1);
	$current=$circular[$i];
    } until ($current =~ /$origin( R)?/);
    print "/prov$maxprov $terrain [",join(" ",@contour),"]pdef\n";
    $maxprov++;
}
