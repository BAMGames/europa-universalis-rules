A makefile replacement

# Transform Makefile in rules and actors

 * blasons : done
 * fonts : done
 * shadow : done
 * pions : done except for figures
 * carte, rotw

# Introduce trace mode

Will follow process with strace and point out read, written and junk
(both read and written) files that are accessed below the root of the
directory.

# Introduce easytrace mode

Will warn about 'in' missing or in excess, and 'out' missing or in
excess, by snapping the whole 

# Introduce dir targets

A whole dir is considered as a target, unlinked as one, moved as
one, etc. The fingerprint of a dir is much lighter than checksumming
everything: checksumming a recursive stat for example (name,size of
each file is a good starting point).

# Introduce args for 'ignore'
generate .gitignore in each directory. All buildable files are
ignored, unless a lazy axiom.

# Do --how and --why modes
These modes generate a graph explaining what is produced from one file and
what is necessary to build a file.
