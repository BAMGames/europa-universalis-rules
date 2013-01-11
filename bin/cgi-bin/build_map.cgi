#!/usr/bin/perl -w

#Process forms as created by colormap.cgi

#use CGI;

#$query = new CGI;

use CGI ':standard'; 
use CGI::Carp qw(fatalsToBrowser);

#Headers.
print "Content-type: text/html\r\n\r\n";
print "<HTML>\n";
print "<HEAD><TITLE>Generating colored minimap for EU8</TITLE></HEAD>\n";
print "<BODY>\n";
print "Processing form...<br>\n";

#Where to find stuff.
$map_file = "chemins.eps";
$tmpdir = ".";
$finaldir = "/home/webdoc/site-lipn/tmp";
$finalurl = "http://www-lipn.univ-paris13.fr/tmp";
$tmpnum = int(rand(100000));
$tmp_file_name = "map2pdf_tmpfile";

$tmpfile = $tmpdir."/".$tmp_file_name."_".$tmpnum;

#Remove old ( > 10 min) tmp .pdf files.
system ("find $finaldir/$tmp_file_name*.pdf -cmin +10 | xargs rm");

# Setting color aliases.
# We'll get "rgb(r,g,b)" values (0<r,g,b<255) and need to translate them
# into [R G B] (0<R,G,B<1) AND give an alias name for each.

%prov_col = ();
$col_name = "color"; # base.
%css_to_name = (); # rgb(r,g,b) => foo.
%name_to_col = (); # foo => [R G B].

sub css_to_map  # rgb(r,g,b) => [R G B]
{
    my $css = shift;
    $css =~ /rgb\((.*),(.*),(.*)\)/;
    my @entiers = ($1, $2, $3);
    my @reels = ();
    
    foreach (@entiers)
    {
	my $foo = $_/255;
	push(@reels,$_/255);
    }
    return "[$reels[0] $reels[1] $reels[2]]";
}

sub add_col # Add a color (rgb(r,g,b)) if not already existing.
{
    my $css = shift;

    unless ($css_to_name{$css}) #If don't exist
    { 
	my $i = (keys(%css_to_name));
	my $name = "color$i";
	$css_to_name{$css} = $name;
	$name_to_col{$name} = &css_to_map($css);
    }
}

# reading and setting the map-file
# Mostly copied from set-provinces.pl

$depth = 0; # initial depth of area definition.
@colors = ("rgb(255,255,255)"); # color of depth 0.
&add_col("rgb(255,255,255)"); #Avoid bad stuff if people set Map to none.
@religions = ("not"); # religion of depth 0.

#Since color definitions are to be put at the beginning but we only
#know all that we need at the end, we need two passes through the file.
#Once for setting everything and then for the colors only :-(
open (INFILE,"$map_file") || die ("Couldn't open $map_file $!");

open (OUTFILE,">$tmpfile.eps.fst") || die ("couldn't open $tmpfile.eps.fst $!\n");

$go = 1;

while(<INFILE>)
{
    $go = 0 if (/^%#D REMOVE/);
    $go = 1 if (m+^%#D /REMOVE+);

    if ($go == 1)
    {
	unless (/^\/prov/) {print OUTFILE "$_";}
	# Copy everything but province definitions

	if (/^\/prov/) # province definition -> change color.
	{
	    $col = $css_to_name{$colors[$depth]}; #color to set
	    @line = split(/ /); #get words.
	    $line[1] = $col; #replace terrain type by color.
	    $line = join(" ",@line); #rebuild line.
	    print OUTFILE "$line";
	}

	if (/^%#/) # Meta-data -> set color and depth
	{
	    unless ((/^%##/) or (/^%#definecolor/) 
		     or (/^%#$/) or (/^%#D/))
              # Remove comments, empty lines, color def, directives.
	    {
		chomp;
		s/ <(.*)>//; #remove religious info.
		$religion = $1;
		/^%#(\S*) (.*)$/;

		$depth_str = $1; # "+++" or such.
		$prov_str = $2; # rest of the line.
		$prov_str =~ s/Reg-(...).*/$1/;
		$prov_str =~ s/ /_/g;

		$depth = length($depth_str); 

		$color = $colors[$depth - 1];
		#default: color of super-area.

		$relig = $religions[$depth - 1]; 
		#default: relig. of super-area.

		$relig = $religion if ($religion);
		#if a religion is defined for this area.
		
		$prm = param("ZZZ$relig");
		$color = $prm if (($prm) && ($prm ne 'none'));
		#If color for the current religion is defined.
		
		$prm = param("ZZZ$prov_str");
		$color = $prm unless ($prm eq 'none');
		#Color for the area supersedes color for the religion.

		$colors[$depth] = $color; #set color for current depth.
		$religions[$depth] = $relig; #set religion.
		&add_col($color);


	    }
	}

    }
}

close(INFILE);
close(OUFILE);

open (INFILE,"$tmpfile.eps.fst") || die ("Couldn't open $tmpfile.eps.fst $!");

open (OUTFILE,">$tmpfile.eps") || die ("couldn't open $tmpfile.eps $!\n");

while(<INFILE>)
{
    print OUTFILE;
    if (/^%#D COLOR/)
	{
	    foreach $alias (sort(keys %name_to_col))
	    {
		print OUTFILE "/$alias [$name_to_col{$alias} dup] def\n";
	    }
	}
}

close(INFILE);
close(OUTFILE);
system("rm $tmpfile.eps.fst");

#Mimicking Makefile...
print "Building Postscript file...<br>";	    

$bindir = ".";
$cartedir = ".";
$homedir = ".";

$mmmm="m4 -P -DMMMM_HOMEDIR=$homedir";

system("$mmmm $tmpfile.eps | sed -e 's/enriched false def/enriched true def/g' -e 's/%%BoundingBox: .*/%%BoundingBox: 0 0 595 842/g' > $tmpfile.ps");

system("rm $tmpfile.eps");

print "Building PDF file (this takes some time)...<br>";

system("ps2pdf -sPAPERSIZE=a4 $tmpfile.ps $tmpfile.pdf");

system("rm $tmpfile.ps");

system("mv $tmpfile.pdf $finaldir/$tmpfile.pdf");

print "Done !<br><br>";

#Lastly, link to download/view file.
#print "Click <a href=\"download.cgi?file=$tmpfile.pdf\">here</a> to download your map.<br>";

print "Click <a href=\"$finalurl/$tmpfile.pdf\">here</a> to download 
your map.<br>";

print "</BODY>\n";
print "</HTML>\n";

exit (0);

