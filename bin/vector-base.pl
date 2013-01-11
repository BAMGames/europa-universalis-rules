#!/usr/bin/perl
# Switch representation from chemin.ps to vector based representation
# (computing angles). Juste paste an excerpt from chemin.eps to see.
sub atan { (atan2($_[1],$_[0])/3.141592653*180) } 
while(<>) {
    if (m/([0-9]+) +([0-9]+) +([0-9]+) +([0-9]+) +([0-9]+) +([0-9]+) +c/) {
	$obx=$bx;$oax=$ax;$ocx=$cx;$oby=$by;$oay=$ay;$ocy=$cy;
	($cx,$cy,$ax,$ay,$bx,$by)=($1,$2,$3,$4,$5,$6);
	if ($obx and $oax) {
	    printf "{% 4d,% 4d}~~(%4u,%4u)~~{% 4d,% 4d}\t%3.1f %3.1f\n",$obx-$oax,$oby-$oay,$obx,$oby,$cx-$obx,$cy-$oby,atan($obx-$oax,$oby-$oay),atan($cx-$obx,$cy-$oby);
	} elsif ($obx) {
	    printf "{    ,    }--(%4u,%4u)~~{% 4d,% 4d}\t      %3.1f\n",$obx,$oby,$cx-$obx,$cy-$oby,atan($cx-$obx,$cy-$oby);
	} else {print "Début\n";}
    } elsif (m/([0-9]+) +([0-9]+) +[lm]/) {
	$obx=$bx;$oax=$ax;$ocx=$cx;$oby=$by;$oay=$ay;$ocy=$cy;
	($cx,$cy,$ax,$ay,$bx,$by)=(0,0,0,0,$1,$2);
	if ($obx and $oax) {
	    printf "{% 4d,% 4d}~~(%4u,%4u)--{    ,    }\t%3.1f \n",$obx-$oax,$oby-$oay,$obx,$oby,atan($obx-$oax,$oby-$oay);
	} elsif ($obx) {
	    printf "{    ,    }--(%4u,%4u)--{    ,    }\t\n",$obx,$oby;
	}  else {print "Début\n";}
    } else {print "*\n";}
}
$obx=$bx;$oax=$ax;$ocx=$cx;$oby=$by;$oay=$ay;$ocy=$cy;
if ($obx and $oax) {
    printf "{% 4d,% 4d}~~(%4u,%4u)--{    ,    }\t%3.1f \n",$obx-$oax,$oby-$oay,$obx,$oby,atan($obx-$oax,$oby-$oay);

} elsif ($obx) {
    printf "{    ,    }--(%4u,%4u)--{    ,    }\t\n",$obx,$oby;
}  else {print "Début\n";}

