#!/usr/bin/perl
open CHEMINS,"chemins.eps";
@lignes=<CHEMINS>;
close CHEMINS;
$printit=1;
foreach (@lignes) {
    chomp;$notempty=1;
    if (m/.path([0-9]+) beginpath/) {
	if (grep /$1/,@ARGV) {$printit=0;}
    } elsif (m/endpath/){
	$printit=1;
    } elsif (m/^$/) {
	$notempty=0 unless ($printit);
    }
    print "$_\n" if ($notempty);
}
