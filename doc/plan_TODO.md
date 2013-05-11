A makefile replacement

# Transform Makefile in rules and actors

 * blasons : done
 * fonts : done
 * shadow : done
 * pions : done
 * figures: shadow2png and chapter heads done, micropdf todo
 * carte, rotw
 * rules
 * web

# Introduce trace mode

Will follow process with strace and point out read, written and junk
(both read and written) files that are accessed below the root of the
directory.

=> NOT SURE

# Introduce easytrace mode

Will warn about 'in' missing or in excess, and 'out' missing or in
excess, by snapping the whole 

# Introduce args for 'ignore'
generate .gitignore in each directory. All buildable files are
ignored, unless a lazy axiom.

=> NOT SURE

# Do --how and --why modes
These modes generate a graph explaining what is produced from one file and
what is necessary to build a file.
