#!/bin/sh
if [ "$1" == "-s" ]; then
shift
A="$1"
shift
B="$1"
shift
perl -pi -e "s/eventref{${A}}/eventref{${B}}/g" "$@"
perl -pi -e "s/eventrefshort{${A}}/eventrefshort{${B}}/g" "$@"
perl -pi -e "s/evnt\\[${A}\\]/evnt\\[${B}\\]/g" "$@"
else
perl -n -e '$b=1;$a=$a." ".$_;chomp $a;while ($a =~ /\\eventrefs?h?o?r?t?{/ && $b) {if ($a =~ s/\\eventrefs?h?o?r?t?{([^}]*)}//) {print "$1\n";} else {$b=0;}} $a="" if ($b);' "$@"|LANG=C sort | uniq -c
fi
