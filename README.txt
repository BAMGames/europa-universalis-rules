What is needed?

It has been successfully tested on Linux Debian 5.0 (stable version,
2008) and other (newer) versions of Linux, and on Mac OS X 10.4+macports
(on a very light Mac, so newer configurations should work flawlessly).
See especially doc/OSX.txt if you work on OS X.

How to use this repository

Most actions are to be done through "make something" (you may require to
use "gmake something" on some setups). Some heavy actions will not
succeed (such as updating all bitmap counters) if not done in the
correct environment (such as some specific developer machine). They are
not needed to build the rules. Network connexion is required to download
some pictures and font files from the Internet. If you do not "make
distclean" and have previously built the rules, you will not need a
network connexion.

------------------
You can try to make the following actions from home
  all clean distclean fastclean help listfinal update
You can also try to make the following actions from home
  changelog cl commit conf conflicts depends editchangelog ignore ignorelist
  justupdate justuptodate listfiles reboot uptodate
------------------
(this list is the direct result of make help in the toplevel directory).

For the toplevel directory and the following sub-directories, you can
use many actions: "shadow" "fonts" "blasons" "rotw" "carte" "records"
"pions" "fig" "rules".
You can also build the files. These makefiles are conceived so that any
file or action can be built from somewhere else, e.g. make ../pions/help
from the "rotw" sub-directory will give the help for the "pions"
sub-directory and "make rules/engLeaders.tex" from the toplevel directory
will build correctly (if not in an optimal way) the file engLeaders.tex
in the "rules" sub-directory.

HOW TO BUILD THE RULES

Simply use "make all" in the toplevel directory.

HOW TO MAKE A SIMPLE CHANGE

 1. Do all of your changes. Ensure that the rules still build correctly.
 2. Describe all of your changes by repeatedly using "make cl" Each
    change should be a few lines of text (it will be reformatted).
 3. Third, use "make commit". This will first update your repository and
    you may need to correct some conflicts. Then it will merge all the
    changes you entered with the global changelog file. Finally, it will
    commit the changes to the repository.
 4. Last, use make update

HOW TO MAKE A LARGE RELEASE

 1. Do all the changes as simple changes indicated above.
 2. Edit the doc/release.txt file to put the new version number.
 3. "make release" will turn in the changes database all the release=current
    in release=number.

 LocalWords:  toplevel gmake distclean
