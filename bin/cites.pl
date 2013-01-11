#!/usr/bin/perl
while (<>) {
    chomp;
    ($a,$b,$c)=split(/ /);
    if ($c=~/^lev[01]/) {
	if($c=~s/lev0/capitale1/g) {
	    $d="img:$c";$a-=17;$b=6339-$b;
	} else {
	    $c=~s/lev1/ville1/g;
	    $d="img:$c";$a-=11;$b=6342-$b;
	}
    } else {
	if ($c=~s/lev2/ville2/g) {
	    $a-=43;$b=6330-$b;$d="img:$c";
	} else {
	    $c=~s/lev3/capitale2/g;
	    $d="img:$c";$a-=45;$b=6325-$b;
	}
    }
    print "($d) $a $b putsymbol\n";
}
