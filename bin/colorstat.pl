#!/usr/bin/perl
open CHEMINS,"chemins.eps";
@lignes=<CHEMINS>;
close CHEMINS;
foreach (red,blue,yellow,black,white,green,magenta,cyan,dark,mauve,aqua)
{$rex=qr/ z$_/;$count=grep /$rex/,@lignes;
 print "$_: $count\n";}
