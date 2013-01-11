# Local defs
FIGGSEXTRA += -SCURRENTDIR=$(FIGDIR)

SDWPNGFILESCMD=$(GIMPIT) --logfile $(LOGFILE) --script $(LIBDIR)/shadowtopng.scm --input "$(SHADOWDIR)" --output "$(FIGDIR)" --class "Building individual pieces" --marker SDWPNGFILES --
XCFJPGFILESCMD=$(GIMPIT) --logfile $(LOGFILE) --script $(LIBDIR)/xcftojpg.scm --input "$(FIGDIR)" --output "$(FIGDIR)" --class "Building chapter heads" --marker XCFJPGFILES --

XFIGDEF=definitions.txt
XCFJPGSTEMS=basics powers diplomacy incomes expenses military victories specificrules events economicalevents politicalevents appendix appendixmajor winning scenarios index chess strategy default
SDWPNGSTEMS=ville1 ville2 villechine1 villechine2 villeinde1 villeinde2 anchor anchor2 anchor3 anchor4 anchor5 blocus bateau sel mine
XFIGSTEMS=$(shell cut -f1 -d: $(FIGDIR)/$(XFIGDEF))

SDWPNGFILES=$(addprefix $(FIGDIR)/,$(addsuffix .png,$(SDWPNGSTEMS)))
XCFJPGFILES=$(addprefix $(FIGDIR)/,$(addsuffix .jpg,$(XCFJPGSTEMS)))

# Local targets
FIGVIRTUALS=
FIGFINALTARGETS=
FIGNOTALLTARGETS=$(addsuffix .jpg,$(XCFJPGSTEMS)) $(addsuffix .png,$(SDWPNGSTEMS))
FIGTARGETS=$(addsuffix .eps,$(XFIGSTEMS)) $(addsuffix .pdf,$(XFIGSTEMS)) ancrefluviale.pdf
FIGSLOWTARGETS= $(FIGNOTALLTARGETS)
XDEGRADECOLORS=779 8A8 AA0 A53 555 779 88F
FIGCRUFT=$(addsuffix .eps,$(addprefix degrade,$(XDEGRADECOLORS))) $(addsuffix .pdf,$(addprefix degrade,$(XDEGRADECOLORS))) $(addsuffix .jpg,$(addprefix chapter,1 2 3 4 5 6 7 8 9 10 11 12 13))
FIGDEBUGTARGETS=

# Other files

$(XCFJPGFILES): $(FIGDIR)/%.jpg: $(GIMPITDEP) $(LIBDIR)/xcftojpg.scm $(FIGDIR)/%.xcf $(LIBDIR)/xcftojpg.scm
	@$(XCFJPGFILESCMD) $*

$(SDWPNGFILES): $(FIGDIR)/%.png: $(GIMPITDEP) $(SHADOWDIR)/%.pnm $(SHADOWDIR)/%.pgm $(LIBDIR)/shadowtopng.scm
	@$(SDWPNGFILESCMD) $*

$(addprefix $(FIGDIR)/,$(addsuffix .eps,$(XFIGSTEMS))): $(FIGDIR)/%.eps: $(FIGDIR)/$(XFIGDEF)
	@$(DISP) "Building PDF figures" "tpl:$*"
	@a=$$(grep '^$*:' $(FIGDIR)/$(XFIGDEF));echo "%!PS" > $@;echo "BOOTFILE (r) file run">> $@; echo "/compress true def/translation true def" >> $@; b=$${a%:*}; echo "/outputoutlines false def $${b#*:} /pageheight exch def /pagewidth exch def" >> $@;echo "HOMEDIR(/library/pdf_library.eps)! include" >> $@;echo "HOMEDIR(/library/xobjects.eps)! include" >> $@;echo "<< /Title (($*)) >> infochunk">>$@;echo "/beginpagehook{} def begindocument beginpage" >> $@; echo "($${a##*:}) xobject" >> $@;echo "endpage enddocument quit" >> $@

$(FIGDIR)/%.pdf: $(GSEXECDEP) $(FIGDIR)/%.eps $(LIBDIR)/xobjects.eps $(LIBDIR)/pdf_library.eps
	@-if [ ! -d "$(FIGDIR)/targets" ]; then mkdir $(FIGDIR)/targets; fi
	@$(DISP) "Building PDF figures" "pdf:$*"
	@$(GSEXEC) $(FIGGSEXTRA) -sOutput=$@ $(FIGDIR)/$*.eps 2>> $(LOGFILE)
	@$(RMTARGETS) $(FIGDIR)/targets

# Virtual actions

$(FIGDIR)/all: $(GIMPITDEP)
	@targets=$$($(MAKE) -n -s $(XCFJPGFILES)|grep -- "--marker XCFJPGFILES"|perl -pi -e 's/ /\n/g'|grep -A 1 ^--$$|grep -v ^--$$);if [ -n "$$targets" ]; then $(XCFJPGFILESCMD) $$targets; fi
	@targets=$$($(MAKE) -n -s $(SDWPNGFILES)|grep -- "--marker SDWPNGFILES"|perl -pi -e 's/ /\n/g'|grep -A 1 ^--$$|grep -v ^--$$);if [ -n "$$targets" ]; then $(SDWPNGFILESCMD) $$targets; fi
