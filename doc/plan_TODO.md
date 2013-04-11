A makefile replacement

# Transform Makefile in rules and actors

 * blasons : done
 * fonts : done
 * shadow : to do
 * pions : to do after shadow/

# Introduce auto documentation

# Clean and Distclean

 * store an inventory of all junk and out files
 * remove from inventory at start if file was removed
 * remove when argv == distclean
 * remove except "finals" when argv == clean

# Introduce trace mode

Will follow process with strace and point out read, written and junk
(both read and written) files that are accessed below the root of the
directory.
