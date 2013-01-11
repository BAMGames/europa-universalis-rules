#!/usr/bin/perl -wT

#CGI/Perl script for taking chemins.eps and building the form from it
#
#
# Written by Jym. January 2007.

use CGI qw/:standard :html3/;

$base_file = "chemins.eps";
#The file we're building the script from.

$max_depth = 7; # maximum depth of an area. May cause errors if too small.
$depth_hide = 3; # deeper or equal stuff will be hidden at start.
                 # so $depth < $depth_hide - 1 is opened at start.


$usage =<<ENDHTML;
<center>
<h1>EU8 map coloring form</h1>
written by Jym on Jan. 2007.
</center>

<p>
<b>How to use this:</b><br>
Each row displays an areas, that is either a province or a group of provinces.
Clicking on the "+"/"-" buttons allows to expand a large area and see its
contents, or fold it back.
Using the menus, you can assign a color to each area.
Whenever a color is assigned to an area, it is also assigned to all its 
sub-areas unless another color is already assigned to it.
That is, if you assign "ANG" to the area "British Isles" and "FRA" to its
subarea "Scotland", then Ireland and England will be colored "ANG" but 
Scotland will be colored "FRA".<br>

At any time, you will see in the rigthmost column the actual color assigned 
to each area, row by row, so you can make sure everything is as you want.<br>

Colors are intended to be more or less reminiscent of each of the major
countries of the game. That is, "ANG" (Anglia) is red, "FRA" (Francia) is 
deep blue and so on. The colors are taken from the counters rather than 
some more usual colors, so, <em>e.g.</em>, "HOL" is somewhat purple
rather than orange. The "light" version of each color is, well, the light
version of the color... So you can, typically, assign "FRA" to provinces
owned by France and "FRAlight" to provinces of its minors allies.
"none" is used is no color is assigned to a specific
area (and hence it should inherit color of its parent). "black" and "white"
are pretty self-explanatory, "clearwater" is a very light blue. The default 
setting is to have all water bodies (seas and lakes) in "clearwater" and the
rest in white.
</p>

<p>
Once you have finished setting colors to areas, click the submit button at
bottom... and wait. Building the map can take some times, please only click
once. You'll be redirected to another page from where you'll be able to
download your map (in PDF).
</p>

<p>
The first lines are religious areas. Each of them correspond to all the
provinces of the given religion. "Mixed" is for provinces that can be
either Catholics or Protestant (typically in France or England). "Other"
is ROTW specific.
</p>

<p>
At the top are a few checkboxes. They allow you to show or hide lakes 
(<em>e.g.</em> Ladoga, Loch Lomond, ...) ; smaller than provinces
areas (<em>e.g.</em> Orkneys, Ibiza, ...) ; special areas that are
not really part of any province (<em>e.g.</em> Shetlands, Bornholm, ...) 
and areas from the zoom. In case you want to specifically color these,
you can.
</p>

<p>
Coloring the zoom (in different colors than the corresponding areas on
the main map) is currently not supported.<br>
Adding user-defined colors is not possible now but should be some day.<br>
Some small areas or lakes (especially in Scandinavia and Russia) have no
individual name because I was unable to find one... If you have ideas for
them, please tell me.
</p>

<p>
You'll need javascript to use this page. If it's turned off on your 
browser, turn it on.<br>
This script has been tested with <a href="http://www.opera.com">Opera</a>, 
<a href="http://www.moziall.com">Firefox</a> and 
<a href="http://www.apple.com/safari">Safari</a>.
</p>
ENDHTML


# Reading the file and filing several arrays we'll need later.
# This will cause 2 passes through all provinces (once while reading
# the file, once while writing the stuff) but should allow for a
# cleaner javascript and stuff since we'll have all the string
# manipulation power of Perl to build everything needed.

# Takes "[x y z]" where 0<x,y,z<1.
# Return "rgb(X,Y,Z)" where 0<X,Y,Z<255.
sub make_rgb
{
    my $rgb = shift;
    $rgb =~ /\[(.*) (.*) (.*)\]/;
    my @reels = ($1, $2, $3);
    my @entiers = ();

    foreach (@reels)
    {
	push(@entiers,int(255*$_));
    }
    return "rgb($entiers[0],$entiers[1],$entiers[2])";
}

$current_row = -1; # Starting at row number 0 but first thing is increment.
@prov_row = (0); #row number of last province of depth i.
@last_ctrl = (); #Since javascript can't do the job, let Perl do it.
%colors = ('none','none'); # name, rgb.
              # RGB is stored as "rgb(x,y,z)" to be directly used in CSS.
%reverse_col =('none','none'); #the other way around...
@depths = ();
@parents = ();
@display_names = ();
@internal_names = ();
@row_colors = (); #the color (rgb) of each row.
%special_col = (); # Areas not defaulted to none, by num of row.

@lakes = (); #list of lakes.
@small = (); #list of smaller than provinces areas.
@spec = (); #list of special areas.
@zoom = (); #list of zoom areas.

#Reading the map file.
open FILE, ("$base_file") || die ("Couldn't open $base_file: $!\n Please report server error.");

while (<FILE>)
{
    if (/^%#/) #Only proceed stuf for us.
    {
	s/%#//;
	#Do not proceed empty lines or comments or directives.
	unless ((/^$/) or (/^#/) or (/^D/)) 
        {
	    chomp;
	    if (/^definecolor (\S*) (.*)/) #color definition
	    {
		$col_name = $1;
		$col_rgb = $2;
		$col_css = &make_rgb($col_rgb);
		$colors{$col_name} = $col_css;
		$reverse_col{$col_css} = $col_name;
	    }
	    else
	    {
		$current_row = $current_row + 1;
		$rel_ab =""; #short name for religious areas
		s/^(\S*) (.*)/$2/; #remove depth chars.
		$depth_str = $1;
		$depth = length($depth_str);
		s/ <...>//; #remove religious info.
		
		if (/^Reg-/)  #Deal with religious areas
		{
		    s/^Reg-(...)(.*)/$1$2/;
		    $rel_ab = $1;
		}
		
		$internal = $_;
		$internal =~ s/ /_/g;
		$internal = $rel_ab if ($rel_ab);

		$cur_col = "none";
		$cur_col = "clearwater" if ($internal eq "Seas");
		$cur_col = "white" if ($internal eq "Map");
		$cur_col = "clearwater" if ($depth_str =~ m+/+); #lakes
		push(@row_colors,$colors{$cur_col});

		if ($depth_str =~ m+/+)
		{push(@lakes,"true");}
		else {push(@lakes,"false");}

		if ($depth_str =~ /-/)
		{push(@small,"true");}
		else {push(@small,"false");}

		if ($depth_str =~ /^\*/)
		{push(@spec,"true");}
		else {push(@spec,"false");}

		if ($depth_str =~ /%/)
		{push(@zoom,"true");}
		else {push(@zoom,"false");}

		$internal = "ZZZ$internal";
    #Without the "ZZZ", the -default parameter is not taken into account
    #at least for some names ('Cat', 'Map' among others).
    #If you know why, please tell me !

		$prov_row[$depth] = $current_row;
		$parent = $prov_row[$depth-1];
		$display = $_;
		
		#Update last controlled row of all the ancestors.
		for($i=0;$i<=$depth;$i=$i+1)
		{
		    $last_ctrl[$prov_row[$i]] = $current_row;
		}
		
		push(@depths,$depth);
		push(@parents,$parent);
		push(@display_names,$display);
		push(@internal_names,$internal);
	    }
	}
    }
}
close FILE;

# CSS Styles.
@styles = ();
for ($i = 1; $i < $max_depth+3; $i++)
{
    $j = ($i-1)/2;
    push(@styles,"td.pad$i {padding-left: ${j}cm}");
}
push(@styles,".hide {display: none}");
$style = join("\n",@styles);

# Javascript.
$JScript=<<ENDJS;
<!--

/* For each row of the table we need to know which other rows are
 * controlled (forget about recursive closes).
 * For this, we use a array storing the last controlled row.
 * Since the transitive closure of controlled rows are all in one
 * bunch immediatly after current row, this should work.
 * This array is build all at once at the end, cause we need Perl
 * to have parsed the whole file before.

 * Similarly, we have a status array remebering whether rows were shown
 * or hidden when the controlling row was closed (in order to reopen
 * in the same state).

 * We also need to know which rows are directly controlled because only
 * these ones should change status when opening/closing.
 * For this, we keep the depth of each row. Directly controlled rows are 
   the controleld rows of depth n+1.

 * This will be done in a 2-dimensions array.
 * Somehow, a dummy thing is needed to initialise each sub-array.

 * Yes, this 2-dimensions array could be use to recursively open/close
 * things but javascript seems to be a bit strange with recursive 
 * function. Maybe one day I can do a proper while loop.
 * Since this is not tail-recursion, that will not be done soon...

 */

// Change the status of a row.
function toggleStatus(row)
{
    status[row] = !status[row];
}

// Shows a row, by its number, if status says so.
function showRow(row)
{
    var show = true;
    var ancestor = row;

    while (ancestor)
    {
	show = show && status[ancestor];
	ancestor = parent[ancestor];
    } 

    show = show && (show_lakes || (!lakes[row]));
    show = show && (show_small || (!small[row]));
    show = show && (show_spec || (!spec[row]));
    show = show && (show_zoom || (!zoom[row]));

    if (show)
	table.rows[row].style.display = 'table-row';
}

// Opens a row: toggle status of directly controlled rows and shows 
// controleld rows.
function openRow(row)
{
    var prof = depth[row];
    var last = lastControlled[row];

    for(i=row+1;i<=last;i=i+1)
    {
	if (depth[i] == prof + 1)
	{
	    toggleStatus(i);
	}
	showRow(i);
    }
}

// Hides a row, by its number, oblivious of status.
function hideRow(row)
{
    table.rows[row].style.display = 'none';
}

// Closes a row: toggle status of directly controleld rows and hides 
// controlled rows.
function closeRow(row)
{
    var last = lastControlled[row];
    var prof = depth[row];

    for(i=row+1;i<=last;i=i+1) 
    {
	if (depth[i] == prof + 1)
	{
	    toggleStatus(i);
	}
	hideRow(i);
    }
}

// Toggle a row: open/close it.
// The text of the button (+/-) allows to know if we must close or open.
function toggleRow(bouton,row)
{
    if (bouton.value == '+') // row is closed ->open
    {
	bouton.value = '-';
	openRow(row);
    }
    else // row is opened -> close.
    {
	bouton.value = '+';
	closeRow(row);
    }
}


// Toggling the show_lakes flag need to go through all lakes.
function toggleLakes()
{
    show_lakes = !show_lakes;
    if (show_lakes)
    {
	for(i=0;i<lakes.length;i=i+1)
	  if (lakes[i])
  	    showRow(i);
    }
    else
    {
	for(i=0;i<lakes.length;i=i+1)
	  if (lakes[i])
  	    hideRow(i);
    }
}

// Toggling the show_lakes flag need to go through all small.
function toggleSmall()
{
    show_small = !show_small;
    if (show_small)
    {
	for(i=0;i<small.length;i=i+1)
	  if (small[i])
  	    showRow(i);
    }
    else
    {
	for(i=0;i<small.length;i=i+1)
	  if (small[i])
  	    hideRow(i);
    }
}

// Toggling the show_lakes flag need to go through all spec.
function toggleSpec()
{
    show_spec = !show_spec;
    if (show_spec)
    {
	for(i=0;i<spec.length;i=i+1)
	  if (spec[i])
  	    showRow(i);
    }
    else
    {
	for(i=0;i<spec.length;i=i+1)
	  if (spec[i])
  	    hideRow(i);
    }
}

// Toggling the show_lakes flag need to go through all zoom.
function toggleZoom()
{
    show_zoom = !show_zoom;
    if (show_zoom)
    {
	for(i=0;i<zoom.length;i=i+1)
	  if (zoom[i])
  	    showRow(i);
    }
    else
    {
	for(i=0;i<zoom.length;i=i+1)
	  if (zoom[i])
  	    hideRow(i);
    }
}

// Coloring the third td of a cell in a single row.
function colorRow(row,color)
{
    table.rows[row].cells[2].style.backgroundColor = color;
}

// Coloring the third TD of a cell by inheritance: 
// only if no color specified.
function changeColorRow(row,color)
{
    if (colors[row] == 'none')
    {
	colorRow(row,color);
    }
}

// Changing a color => change all controlled.
function changeCtrlColorRow(row,color)
{
    colorRow(row,color);
    for(i=row+1;i<=lastControlled[row];i=i+1)
    {
	if (colors[i] == 'none')
	{
	    colorRow(i,color);
	}
	else
	{
	    i = lastControlled[i];
	}
    }
}

function menuChange(menu,row)
{
    var col = menu.value;
    colors[row] = col;

    if (col == 'none') // Change to none
    {	// Looking for the first not 'none' ancestor.
	var ancestor = row;
	while ((ancestor) && (colors[ancestor] == 'none'))
	{
	    ancestor = parent[ancestor];
	}
	if (ancestor)
	    col = colors[ancestor];
	else
	    col = 'white';
    }
    changeCtrlColorRow(row,col);
}

//--> 
ENDJS

print 
    header(-charset=>'utf-8'),
    start_html(-title=>"EU8 map coloring form",
	       -author=>"Jym",
	       -style=>{-code=>$style},
	       -script=>$JScript);
	  
print $usage;
print br,hr,br;
     
print start_form(-action=>"build_map.cgi");


print checkbox(-name=>'toggle_lakes',
	       -label=>'Show lakes',
	       -onClick=>'toggleLakes()');

print "\n&nbsp;&nbsp;\n";

print checkbox(-name=>'toggle_small',
	       -label=>'Show small areas',
	       -onClick=>'toggleSmall()');

print "\n&nbsp;&nbsp;\n";

print checkbox(-name=>'toggle_spec',
	       -label=>'Show special areas',
	       -onClick=>'toggleSpec()');

print "\n&nbsp;&nbsp;\n";

print checkbox(-name=>'toggle_zoom',
	       -label=>'Show zoom',
	       -onClick=>'toggleZoom()');

print "<table id=\"the_table\">\n";

@status = ();

$empty = td({-class=>"pad8"},"&nbsp;");

for($i=0;$i<@depths;$i=$i+1)
{
    $button_text = '+';
    $button_text = '-'     if ($depths[$i] < $depth_hide - 1);

    $button="";
    $button = button(-name=>"button$i",
		     -value=>$button_text,
		     -onClick=>"toggleRow(this,$i)") 
	if ($depths[$i]<$depths[$i+1]);

    @cols = keys(%reverse_col);
    @cols = sort {$reverse_col{$a} cmp $reverse_col{$b}} @cols;

    $change = "menuChange(this,$i)";

    $menu = popup_menu(-name=>$internal_names[$i],
		       -values=>\@cols,
		       -labels=>\%reverse_col,
		       -default=>$row_colors[$i],
		       -onChange=>$change);		      
    print "\n";
    if ($depths[$i] < $depth_hide)
    {
	print TR(td({-class=>"pad$depths[$i]"},
		    $button.$display_names[$i]),
		 td($menu),
		 $empty);
	push(@status,1);
    }
    else
    {
	print TR({-class=>"hide"},
		 td({-class=>"pad$depths[$i]"},
		    $button.$display_names[$i]),
		 td($menu),
		 $empty);
	push(@status,0);
    }
    print "\n";
}

# End of form, setting global variable.
print "</table>\n";

print submit(-name=>"build_map",
	     -label=>"Build map (this takes some time)"), 
      end_form;

print <<EOM;

Building the map can takes up to two minutes. Please only click 
once.<br>

<script type="text/javascript">
var table = document.getElementById("the_table");
EOM

# Filling the arrays.

print "var lastControlled = new Array(".join(',',@last_ctrl).");\n";
print "var depth = new Array(".join(',',@depths).");\n";
print "var status = new Array(".join(',',@status).");\n";
print "var parent = new Array(".join(',',@parents).");\n";
print "var colors = new Array('".join("','",@row_colors)."');\n";
print "var lakes = new Array(".join(',',@lakes).");\n";
print "var small = new Array(".join(',',@small).");\n";
print "var spec = new Array(".join(',',@spec).");\n";
print "var zoom = new Array(".join(',',@zoom).");\n";
#print "var colHash = newArray();\n";
#foreach $name (keys (%colors))
#{
#    print "colHash['$name'] = '$colors{$name}';\n";
#}
print <<ENDJS;
var show_lakes = false;
var show_small = false;
var show_spec = false;
var show_zoom = true; // Zoom is depth 2 hence initially displayed...
toggleZoom(); // So hide it.

for(j=0;j<colors.length;j=j+1)
{
    if (colors[j] != 'none')
    {
    changeCtrlColorRow(j,colors[j]);	
    }
}
</script>\n
ENDJS

#if (param())
#{
#    print 
#	hr,
#	"France ->", param('France'),
#	br;
#}

print end_html;
