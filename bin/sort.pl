#!/usr/bin/perl
use POSIX;
%doublon=();
%hash=();
%types=();
open CHEMINS,"chemins.eps";
@lignes=<CHEMINS>;
close CHEMINS;
open CHEMINS,">chemins.eps.old";
print CHEMINS @lignes;
close CHEMINS;
@pathdefs=grep / beginpath/,@lignes;
foreach (@pathdefs) {
    if (m/^\/([a-z]+)([0-9]+) beginpath/) {
	die "Double définition de /$1$2\n" if ($doublon{"$1:$2"}++);
	$hash{$1}{$2}=$types{$1}++;
	print "$1:$2 ==> $hash{$1}{$2}\n";
    } else {
#	print $_;
    }
}

@provdefs=grep /^\/prov[0-9]/,@lignes;
foreach (@provdefs) {
    if (m/^\/(prov)([0-9]+) /) {
	die "Double définition de /$1$2\n" if ($doublon{"$1:$2"}++);
	$hash{$1}{$2}=$types{$1}++;
	print "$1:$2 ==> $hash{$1}{$2}\n";
    } else {
#	print $_;
    }
}

foreach (keys %types) {
    $format{$_}="%0".POSIX::ceil(log($types{$_})/log(10))."d";
    printf "$_ => $format{$_}\n",0;
}

foreach $type (keys %hash) {
    foreach $val (sort keys %{$hash{$type}}) {
	my $oldlabel="$type$val";
	my $newlabel=sprintf "$type$format{$type}",$hash{$type}{$val};
	my $tmplabel=sprintf "$type---$format{$type}",$hash{$type}{$val};
	if ($oldlabel eq $newlabel) {
#	    print "$oldlabel ne change pas.\n";
	} else {
	    foreach (@lignes) {s/$oldlabel\b/$tmplabel/;}
#	    $substitution{$tmplabel}=$newlabel;
	    $substitution{$type."---"}=$type;
	    print "$oldlabel --> $tmplabel\n";
	}
    }
}
foreach $replace (keys %substitution) {
    my $newlabel=$substitution{$replace};
    foreach (@lignes) {s/$replace/$newlabel/g; }
    print "$replace --> $newlabel s/$replace/$newlabel/\n";
}
open CHEMINS,">chemins.eps";
print CHEMINS @lignes;
close CHEMINS;
