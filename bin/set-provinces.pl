#!/usr/bin/perl

if (@ARGV < 2) 
{
    die("Usage: get-provinces.pl <color-file> <map-file>
<color-file>: .map file with provicnes names and colors.
<map-file>: should probably always be chemins.eps\n");
}

$color_file = $ARGV[0];
$map_file = $ARGV[1];

$no_lakes = 1; # default: don't color lakes

# reading the color-file

%prov_col = ();
%col_alias = ();

open FILE, ("$color_file") || die ("set-provinces couldn't open $color_file: $!");

while (<FILE>)
{
    unless ((/^$/) or (/^#/))   #skip empty lines and comments.
    {
	chomp;
	if (/^definecolor (\S*) (.*)/) #color definition
	{
	    $col_name = $1;
	    $col_rgb = $2;
	    $col_alias{$col_name} = $col_rgb;
	}
	else
	{
	    s/\S* //; #remove depth chars.
	    ($prov,$col)=split(/:/);
	    $prov =~ s/^Reg-(...).*/$1/;
	    #keep only the 3 chars code for religious areas.
	    $col =~ s/^\s//g;  
	    #color names should not contain leading whitespaces.
	    $prov_col{$prov} = $col if ($col);
	}
    }
}

close(FILE);

# reading and setting the map-file

$depth = 0; # initial depth of area definition.
@colors = ("white"); # color of depth 0.
@religions = ("not"); # religion of depth 0.

open FILE, ("$map_file") || die ("set-provinces couldn't open $map_file: $!");

$go = 1;

while(<FILE>)
{
    $go = 0 if (/^%#D REMOVE/);
    $go = 1 if (m+^%#D /REMOVE+);

    if ($go == 1)
    {
	print unless (/^\/prov/);
	# Copy everything but province definitions

	if (/^\/prov/) # province definition -> change color.
	{
	    $col = $colors[$depth]; #color to set
	    @line = split(/ /); #get words.
	    $line[1] = $col; #replace terrain type by color.
	    $line = join(" ",@line); #rebuild line.
	    print $line;
	}

	if (/^%#/) # Meta-data -> set color and depth
	{
	    unless ((/^%##/) or (/^%#definecolor/))
              # Remove comments and color definitions
	    {
		chomp;
		s/ <(.*)>//; #remove religious info.
		$religion = $1;
		/^%#(\S*) (.*)$/;

		$depth_str = $1; # "+++" or such.
		$prov_str = $2; # rest of the line.

		$depth = length($depth_str); 
		
		$color = $colors[$depth - 1];
		#default: color of super-area.
		$relig = $religions[$depth - 1]; 
		#default: relig. of super-area.

		$relig = $religion if ($religion);
		#if a religion is defined for this area.
		
		$color = $prov_col{$religion} if ($prov_col{$religion});
		#If color for the current religion is defined.
		
		$color = $prov_col{$prov_str} if $prov_col{$prov_str};
		#Color for the area supersedes color for the religion.

		$color = "clearwater" if (($depth_str =~ m+/+) and ($no_lakes ==1));
		#no_lakes supersedes everything.
		
		$colors[$depth] = $color; #set color for current depth.
		$religions[$depth] = $relig; #set religion.
	    }
	}

	if (/^%#D COLOR/)
	{
	    foreach $alias (sort(keys %col_alias))
	    {
		print "/$alias [$col_alias{$alias} dup] def\n";
	    }
	}
    }
}

close(FILE)
