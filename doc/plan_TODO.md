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

# Improve plan builder tool

## Introduce trace action

Will follow process with strace and point out read, written and junk
(both read and written) files that are accessed below the root of the
directory.

=> NOT SURE

## Introduce easytrace action

Will warn about 'in' missing or in excess, and 'out' missing or in
excess, by storing the mtime for all files and telling what was
modified. Out files will modify the mtime. For in files, it is a bit
more difficult. One possibility is to launch in a separate tree and see
if this fails (but this is not failproof : consider cat * > result as a
rule). The best would be the full trace action outlined above.

=> NOT SURE

## Introduce variables

Like modes, variables modify the actions, but opposite to them, not the plan.
Dependency on .tmp/vars should suffice.

## Introduce timings

Produce timing stats on demand. For example, --global-time reports how
much time was expanded rebuilding the targets.

## Introduce silent mode

Make a silent mode, outputting less things. Reintroduce --no-color ?

## Introduce display property

Display [this] before exec'ing. Compound will display all. If not set,
do not display anything (the program will either display nothing, or
use its own way).

Also introduce --recursive to tell plan not to filter its 'display' output.

Clarify displaying procedures.

Status: almost done.

# Recreate compile-latex script

## Methodology

Parse ARGV, and possibly some ~/.compile-latex.conf

Find sourcegoals.

For each sourcegoal:

  Parse some more args.
  Determine main sources (couple jobname+source). Each couple is a goal.
  Each goal may have pre-treatment and post-treatment.
  post-treatment: dvipdf, dvips, ps2pdf, ...
  Issue plan with three parts, pre, run, post.

For each goal:
  Run the preplan.
  Run the runplan. Some items (discover) may append elements to the runplan.
  Run the postplan.

A plan part is a array:

{
  'order' => [ keys ],
  'key0' => {
    'filemustexist' => { filehash },
    'in' => { filehash },
    'out' => { filehash },
    'junk' => { filehash }
    'command' => [ 'pdflatex','--jobname','x','source.tex' ],
    'display' => 'pdflatex source (x)'
  },
  'key1' => {...}
}
