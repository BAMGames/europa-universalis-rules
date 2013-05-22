A makefile replacement

# Transform Makefile in rules and actors

 * blasons : done
 * fonts : done
 * shadow : done
 * pions : done
 * figures: done
 * carte, rotw: in progress
 * rules
 * records
 * web

# Introduce trace action

Will follow process with strace and point out read, written and junk
(both read and written) files that are accessed below the root of the
directory.

=> NOT SURE

# Introduce easytrace action

Will warn about 'in' missing or in excess, and 'out' missing or in
excess, by storing the mtime for all files and telling what was
modified. Out files will modify the mtime. For in files, it is a bit
more difficult. One possibility is to launch in a separate tree and see
if this fails (but this is not failproof : consider cat * > result as a
rule). The best would be the full trace action outlined above.

# Do --how and --why actions

These actions generate a graph explaining what is produced from one file and
what is necessary to build a file.

# Introduce variables

Like modes, variables modify the actions, but opposite to them, not the plan.
Dependency on .tmp/vars should suffice.

# Introduce smart targets

See inside man pages. Smart targets can add files, remove files, add
mode, set hardrule.

# Introduce sweeping

Remove all generated files no more generable.