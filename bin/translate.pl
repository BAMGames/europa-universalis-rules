#!/usr/bin/perl
my $fileout=shift @ARGV;
open OUT,">$fileout";

my %admissibles=();
foreach (292, 304, 347, 351, 353, 379, 256, 257, 261, 263, 273, 287, 289, 298, 299, 305, 322, 324, 333, 339, 381, 466, 537, 7693, 7739, 7775, 7789, 8217, 8219) {
  $admissibles{"$_"}++;
}
sub treat {
    my ($chaine)=@_;
    $result="";
    $somebinary=0;
    $justascii=0;
    $state=0;
    foreach $i (0..length($chaine)-1) {
	$courant=substr $chaine,$i,1;
	$code=ord($courant);
	if ($code<128) {
	    if ($justascii) {
		$result.=$courant;
	    } else {
		$result.="\\unicodechar{".ord($courant)."}";
		$justascii=1;
	    }
	    $state=0;
	} elsif ($state==0) {
	    $code=ord($courant);
	    if ($code<224 && $code>=192) {
		$state=1;
		$accu=$code-192;
	    } else {
		$state=2;
		$accu=$code-224;
	    }
	    $justascii=0;
	} else {
	    $state-=1;
	    $accu=$accu*64+(ord($courant)&63);
	    if (!$state) {
		$result.="\\unicodechar{".$accu."}";
		$somebinary=1 unless ($accu < 256 or $admissibles{$accu});
	    }
	}
    }
    if ($somebinary) {$result="\\REQUIRELUC".$result."\\ENDLUC";}
    return "$result";
}

foreach $filename (@ARGV) {
    print OUT "% This part is generated automatically from $filename\n";
    open FILE,$filename;
    while(<FILE>) {
	print OUT $_ if /^%/;
	next if /^$/;
	next if /^%/;
	$ok=0;
	if (/^([a-z]+):([^:]+):([^:]+):([^:]+)/) {
	    $keypart=$3;$part=$2;
	    $altpart=$4; chomp $altpart;
	    $altpart=&treat($altpart);
	    $keypart=&treat($keypart);
	    $ok=2;
	} elsif (/^([a-z]+):([^:]+):([^:]+)/) {
	    $altpart=$3; chomp $altpart;$part=$2;
	    $altpart=&treat($altpart);
	    $ok=1;
	} elsif (/^([a-z]+):([^:]+)/) {
	    $part=$2; chomp $part;
	    $altpart=&treat($part);
	    $ok=1;
	} elsif (/^([-A-Za-z ]+)=\[([A-Za-z ]+)\]=>([A-Za-z ]+)/) {
	    print OUT "\\defalias\{$2\}\{$1\}\{$3\}\n";next;
	} else {print "Invalid line: $_"; next;}
	if ($ok) {print OUT "\\defshort$1\{$part\}\{$altpart\}\n";}
	if ($ok>1) {print OUT "\\deflong$1\{$part\}\{$keypart\}\n";}
    }
    print OUT "% End from $filename\n";
    close FILE;
}
