#!/usr/bin/perl

if (@ARGV < 2) 
{
    die("Usage: get-provinces.pl <skip> <file>
<skip>: regexp to skip. Typically [%/-].\n");
}
#Rq: don't put '/' as the first char in the regexp


# Areas labelled with these characters will be skipped.
# possibles chars are:
#   * special provinces/areas
#   + larger than province area
#   = provinces
#   - smaller than province area
#   / lakes and inland water bodies
#   % areas in the zoom.
#   r ROTW areas.
#   R Religious areas.
#   # comments (should never be skipped...)
#   D directivces for the script (should always be skipped)
$skip_chars = $ARGV[0];

$file = $ARGV[1];

open FILE, ("$file") || die ("get-provinces couldn't open $file: $!");

while (<FILE>)
{
    if (/^%#/) # Only lines starting with %# are for us
	{
	    s/^%#//; # remove leading %#.
	    s/ <.*>//; # remove religious indication.
	    
	    unless (/^.?$skip_chars/)
		#skipped char can be either first or second (for comments)
	    {
		s/^#./#/; #remove second char of comments.
		
		chomp;
		print;
		print ": " unless ((/^#/) or (/^$/) or (/^definecolor/)); 
                           #Not for comments or empty lines.
                print "\n";
	    }
	}
}
