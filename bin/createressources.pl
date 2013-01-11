#!/usr/bin/perl
$res=@ARGV[0];
open RESSOURCES,"gzip -cd $res |";
foreach (<RESSOURCES>) {
     if (/gnm:Cell Row=.(\d+). Col=.(\d+). ValueType=.(\d+).>(.+)<\/gnm:Cell>/) {	
	$case{$2}{$1}=$4;
	if ($2 eq 24) {
	    $pays{$4}=$1;
	}
    }
}

sub dc {
    my ($col)=@_;
    if ($case{$col}{$ligne}) {
	return  ($case{$col}{$ligne});
    } else {return "0";}
}
sub dd {
    my ($col)=@_;
    if ($case{$col}{$ligne}) {
	return  ($case{$col}{$ligne});
    } else {return "-";}
}
@ress=("orient","epices","america","sucre","sucrebr","esclaves","coton","cotonas","peaux","peche","sel","soie","bois","areacold");

print "/ressdict 100 dict def ressdict begin\n";
foreach (sort keys %pays) {
    $ligne=$pays{$_};
    $constituant=dc(2)."/".dd(3)."/".dd(4);
    $armee=dc(5);
    if ($armee=~/\.([2367])/) {
	$armee="1 LDE" if ($1 eq 3) or ($1 eq 2);
	$armee="2 LDE" if ($1 eq 7) or ($1 eq 6);
    } else {$armee.=" LD";}
    print "/$_ [($constituant) ($armee) ".$case{25}{$ligne}."[";
    foreach (0..11) {
	print "[(".$ress[$_].")(".$case{$_+6}{$ligne}.")]" if ($case{$_+6}{$ligne});
    }
    $_=12;
    print "[(".$ress[$_].")(+)]" if ($case{$_+6}{$ligne});
    $_=13;
    print "[(".$ress[$_].")(".($case{$_+6}{$ligne}-1).")]" if ($case{$_+6}{$ligne});
    print "]]def\n";
}
close RESSOURCES;
print "end\n";
