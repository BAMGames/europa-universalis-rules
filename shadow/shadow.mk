# Local defs
SHADOWSTEMS=ville1 anchor anchor5 anchor6 anchor7 mecca
PNMSHADOWTARGETS=$(addsuffix .pnm,$(SHADOWSTEMS))
PGMSHADOWTARGETS=$(addsuffix .pgm,$(SHADOWSTEMS))
XCFSDWFILES=$(addprefix $(SHADOWDIR)/,$(PNMSHADOWTARGETS) $(PGMSHADOWTARGETS))
XCFSDWFILESCMD=$(GIMPIT) --logfile $(LOGFILE) --script $(LIBDIR)/xcftoshadow.scm --input "$(SHADOWDIR)" --output "$(SHADOWDIR)" --class "Building shadow images" --marker XCFSDWFILES --

# Local targets
SHADOWVIRTUALS=
SHADOWFINALTARGETS=
SHADOWNOTALLTARGETS=$(PNMSHADOWTARGETS) $(PGMSHADOWTARGETS)
SHADOWTARGETS=
SHADOWDEBUGTARGETS=
SHADOWSLOWTARGETS=$(SHADOWNOTALLTARGETS)

$(SHADOWDIR)/all:
	@targets=$$($(MAKE) -n -s $(XCFSDWFILES)|grep -- "--marker XCFSDWFILES"|perl -pi -e 's/ /\n/g'|grep -A 1 ^--$$|grep -v ^--$$|sort|uniq);if [ -n "$$targets" ]; then $(XCFSDWFILESCMD) $$targets; fi

$(addprefix $(SHADOWDIR)/,$(PNMSHADOWTARGETS)): $(SHADOWDIR)/%.pnm: $(GIMPITPRG) $(SHADOWDIR)/%.xcf $(LIBDIR)/xcftoshadow.scm
	@$(XCFSDWFILESCMD) $*
$(addprefix $(SHADOWDIR)/,$(PGMSHADOWTARGETS)): $(SHADOWDIR)/%.pgm: $(GIMPITPRG) $(SHADOWDIR)/%.xcf $(LIBDIR)/xcftoshadow.scm
	@$(XCFSDWFILESCMD) $*

