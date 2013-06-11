A makefile replacement

# Transform Makefile in rules and actors

 * blasons : done
 * fonts : done
 * shadow : done
 * pions : done
 * figures: done
 * carte: done
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

# Do --why actions

These actions generate a graph explaining what is produced from one file.

# Introduce variables

Like modes, variables modify the actions, but opposite to them, not the plan.
Dependency on .tmp/vars should suffice.

# Introduce timings

Produce timing stats on demand. For example, --global-time reports how
much time was expanded rebuilding the targets.

# Introduce silent mode

Make a silent mode, outputting less things. Reintroduce --no-color ?

# Introduce plan making cache

While building a plan, MD5sum-ify everything. If everything is the same
for the next call to plan, just dump the last plan. When called in a loop,
this should speed up things in between recompiles.

Files to fingerprint:
 * rules (maybe just the ascii things of it)
 * infiles
 * outfiles
 * arguments to plan

Do the same thing for the narrow_plan (if planId is same and
includedFiles list is the same, not includedFiles contents).

Just clone planContext and here you are.

# Introduce display property

Display [this] before exec'ing. Compound will display all. If not set,
do not display anything (the program will either display nothing, or
use its own way).

Also introduce --recursive to tell plan not to filter its 'display' output.

Clarify displaying procedures.
