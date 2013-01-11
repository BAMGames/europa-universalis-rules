SHADOWDIR=$(HOMEDIR)/shadow
BLASONSDIR=$(HOMEDIR)/blasons
FONTSDIR=$(HOMEDIR)/fonts
ROTWDIR=$(HOMEDIR)/rotw
CARTEDIR=$(HOMEDIR)/carte
PIONSDIR=$(HOMEDIR)/pions
RECORDSDIR=$(HOMEDIR)/records
FIGDIR=$(HOMEDIR)/figures
RULESDIR=$(HOMEDIR)/rules
PRINTDIR=$(HOMEDIR)/print
WEBDIR=$(HOMEDIR)/web

IMAGEDIR=$(HOMEDIR)/images
LIBDIR=$(HOMEDIR)/library
BINDIR=$(HOMEDIR)/bin

LOGFILE=$(HOMEDIR)/build.log

ifndef XID
XID := $(shell date +%s)
endif
DISPBIN=$(BINDIR)/statedisplay
DISP=$(DISPBIN) $(XID)
export XID
export HOMEDIR
export BINDIR
export CURRENTDIR
export FTPPASSWORD

ifdef DEBUG
RMTARGETS = /bin/true
else
RMTARGETS = /bin/rm -rf
endif

# default values

GIMPLIMIT=45
RESOLUTION=low

-include $(HOMEDIR)/conf.mk

# GS common definitions

GSDEFS=-SHOMEDIR=$(HOMEDIR) -SBOOTFILE=$(LIBDIR)/bootstrap.eps
GSEXEC=gs -dEPSCrop -r20x20 -sDEVICE=ppm -SOutputFile=/dev/null -DBATCH -DNOPAUSE -q $(GSDEFS)

GSCOMMON=$(HOMEDIR)/.stamp-gs $(LIBDIR)/bootstrap.eps
GSCHEMINCOMMON=$(GSCOMMON) $(LIBDIR)/libchemin.eps
GSLIBCOMMON=$(addsuffix .eps,$(FONTSDIR)/arial_narrow $(FONTSDIR)/encodings $(addprefix $(LIBDIR)/,common library pdf_library)) # Plus images.eps in CURDIR
GSCOMCOMMON=$(LIBDIR)/common.eps $(LIBDIR)/xobjects.eps
GSMAPCOMMON=$(GSCOMMON) $(GSLIBCOMMON) $(GSCOMCOMMON) $(LIBDIR)/libcarte.eps
GSCOLORMAPCOMMON=$(GSMAPCOMMON) $(FONTSDIR)/champion.eps $(addprefix $(IMAGEDIR)/,orage4.pnm orage5.pnm orage6.pnm orage7.pnm orage8.pnm) $(BLASONSDIR)/templates/blason.pgm $(BLASONSDIR)/templates/protoblason.pgm

# Gimp common definitions

GIMPITPRG=$(BINDIR)/gimpit
GIMPIT=$(GIMPITPRG) --limit $(GIMPLIMIT)
GIMPITDEP=$(HOMEDIR)/.stamp-gimp $(GIMPITPRG)

COUNTERBITMAPDIR=$(PIONSDIR)/bitmap
MAPBITMAPDIR=$(PIONSDIR)/carte

all: $(HOMEPERSISTENTFILES)

$(HOMEDIR)/conf: $(BINDIR)/configure
	@$(DISP) "Configuring" "global configuration"
	@$(BINDIR)/configure $(HOMEDIR)/conf.mk
 $(HOMEDIR)/conf.mk: $(BINDIR)/configure
	@$(DISP) "Configuring" "default configuration"
	@$(BINDIR)/configure --default $(HOMEDIR)/conf.mk

$(HOMEDIR)/.stamp-gs:
	@$(DISP) "Checking installation" "ghostscript"
	@if [ $$(which gs 2>&1|grep ^/|wc -l) -lt 1 ]; then $(DISP) "Checking installation" failed; rm -f $@; false;fi
	@touch $@

$(HOMEDIR)/.stamp-lftp:
	@$(DISP) "Checking installation" "lftp"
	@if [ $$(which lftp 2>&1|grep ^/|wc -l) -lt 1 ]; then $(DISP) "Checking installation" failed; rm -f $@; false;fi
	@touch $@

$(HOMEDIR)/.stamp-svn:
	@$(DISP) "Checking installation" "subversion"
	@if [ $$(which svn 2>&1|grep ^/|wc -l) -lt 1 ]; then $(DISP) "Checking installation" failed; rm -f $@; false;fi
	@touch $@

$(HOMEDIR)/.stamp-gimp:
	@$(DISP) "Checking installation" "gimp"
	@if [ $$(which gimp 2>&1|grep ^/|wc -l) -lt 1 ]; then $(DISP) "Checking installation" failed; rm -f $@; false;fi
	@version=$$(LANG=C gimp --version | sed -e 's/[^0-9]//g' -e 's/^\(..\).*/\1/g'); if [ "$$version" -lt "20" ]; then $(DISP) "Checking installation" "too old"; rm -f $@; false;fi
	@touch $@
$(HOMEDIR)/.stamp-tex:
	@$(DISP) "Checking installation" "TeX"
	@if [ $$(which pdflatex 2>&1|grep ^/|wc -l) -lt 1 ]; then $(DISP) "Checking installation" failed; rm -f $@; false;fi
	@if [ $$(which kpsewhich 2>&1|grep ^/|wc -l) -lt 1 ]; then $(DISP) "Checking installation" failed; rm -f $@; false;fi
	@version=$$(LANG=C pdflatex --version | grep 3.1415 | cut -f2 -d-| cut -c3-4); if [ "$$version" -lt "21" ]; then version=$$(LANG=C pdflatex --version | grep 3.1415 | cut -f3 -d-| cut -c3-4); if [ "$$version" -lt "21" ]; then $(DISP) "Checking installation" "too old"; rm -f $@; false;fi;fi
	@touch $@

HOMEFINALTARGETS=conf.mk .stamp-gs .stamp-gimp .stamp-tex .stamp-svn .stamp-lftp
HOMEVIRTUALS=conf
HOMEDEBUGTARGETS=build.log cl.db doc/serve/counters.php
HOMENOTALLTARGETS=
HOMETARGETS=$(HOMENOTALLTARGETS)
HOMECRUFT=players-changelog.txt script.ftp changelog.txt index.html
HOMEPERSISTENTFILES=$(HOMEDIR)/conf.mk $(HOMEDIR)/.stamp-gs $(HOMEDIR)/.stamp-gimp $(HOMEDIR)/.stamp-tex $(HOMEDIR)/.stamp-svn $(HOMEDIR)/cl.db $(HOMEDIR)/.stamp-lftp

NAMES=HOME SHADOW FONTS BLASONS ROTW CARTE RECORDS PIONS FIG RULES PRINT WEB
include $(SHADOWDIR)/shadow.mk
include $(FONTSDIR)/fonts.mk
include $(BLASONSDIR)/blasons.mk
include $(ROTWDIR)/rotw.mk
include $(CARTEDIR)/carte.mk
include $(PIONSDIR)/pions.mk
include $(RECORDSDIR)/records.mk
include $(FIGDIR)/figures.mk
include $(RULESDIR)/rules.mk
include $(PRINTDIR)/print.mk
include $(WEBDIR)/web.mk

# Global targets

#eq = $(findstring $(1),$(findstring $(2),$(1)))
#xd = $(patsubst %/,%,$(patsubst ./.%,.%,./$(dir $(1))))
#fb = $(if $(1),$(foreach v,$(2),$(if $(call eq,$(call xd,$(1)),$(call xd,$(v))),$(v),)),$(error argh empty call to fb))

TOPLEVELVIRTUALS=help listfinal all update fastclean clean distclean ignore ignorelist depends reboot listfiles uptodate justupdate justuptodate conflicts cl changelog commit editchangelog release online ftp
IMPORTANTVIRTUALS=help listfinal all update fastclean clean distclean

define DIR_template
$(1)DEBUGTARGETS += $$($(1)CRUFT)
$(1)TARGETS += $$($(1)FINALTARGETS) $$($(1)NOTALLTARGETS)
SUBDIRS += $$($(1)DIR)
VIRTUALS += $$(addprefix $$($(1)DIR)/,$$($(1)VIRTUALS) $$(TOPLEVELVIRTUALS))
FILES += $$(addprefix $$($(1)DIR)/,$$($(1)TARGETS))
DEBUGFILES += $$(addprefix $$($(1)DIR)/,$$($(1)DEBUGTARGETS))
NOTALLFILES += $$(addprefix $$($(1)DIR)/,$$($(1)NOTALLTARGETS))
SLOWFILES += $$(addprefix $$($(1)DIR)/,$$($(1)SLOWTARGETS))
FINALFILES += $$(addprefix $$($(1)DIR)/,$$($(1)FINALTARGETS))
$(1)SUBNAME=$$(notdir $$($(1)DIR))
$(1)ALLFILES=$$(addprefix $$($(1)DIR)/,$$(filter-out $$($(1)NOTALLTARGETS),$$($(1)TARGETS)))
$(1)GENERATEDFILES=$$(addprefix $$($(1)DIR)/,$$($(1)DEBUGTARGETS) $$($(1)TARGETS))
$$($(1)DIR)/all: $$($(1)ALLFILES)
$$($(1)DIR)/fastclean:
	@del="$$(filter-out $$(SLOWFILES) $$(FINALFILES),$$($(1)GENERATEDFILES))"; j=0; for f in $$$$del; do if [ -e "$$$$f" ]; then j=$$$$((j+1)); fi; done; if [ "$$$$j" -gt 0 ]; then $$(DISP) "Fast cleaning" "$$($(1)SUBNAME)"; rm -rf $$$$del; fi
$$($(1)DIR)/clean:
	@del="$$(filter-out $$(FINALFILES),$$($(1)GENERATEDFILES))"; j=0; for f in $$$$del; do if [ -e "$$$$f" ]; then j=$$$$((j+1)); fi; done; if [ "$$$$j" -gt 0 ]; then $$(DISP) "Cleaning" "$$($(1)SUBNAME)"; rm -rf $$$$del; fi
$$($(1)DIR)/distclean:
	@del="$$(filter-out $$($(1)PERSISTENTFILES),$$($(1)GENERATEDFILES))"; j=0; for f in $$$$del; do if [ -e "$$$$f" ]; then j=$$$$((j+1)); fi; done; if [ "$$$$j" -gt 0 ]; then $$(DISP) "Purging" "$$($(1)SUBNAME)"; rm -rf $$$$del; fi
$$($(1)DIR)/reboot:
	@del="$$($(1)GENERATEDFILES)"; j=0; for f in $$$$del; do if [ -e "$$$$f" ]; then j=$$$$((j+1)); fi; done; if [ "$$$$j" -gt 0 ]; then $$(DISP) "Rebooting" "$$($(1)SUBNAME)"; rm -rf $$$$del; fi
$$($(1)DIR)/help:
	@echo "You can try to make the following actions from $$($(1)SUBNAME)";echo $$(sort $$(filter $$(IMPORTANTVIRTUALS),$$(TOPLEVELVIRTUALS) $$($(1)VIRTUALS)))|fmt|sed -e 's/^/  /g'
	@echo "You can also try to make the following actions from $$($(1)SUBNAME)";echo $$(sort $$(filter-out $$(IMPORTANTVIRTUALS),$$(TOPLEVELVIRTUALS) $$($(1)VIRTUALS)))|fmt|sed -e 's/^/  /g'
$$($(1)DIR)/listfiles:
	@echo "You can try to make the following files from $$($(1)SUBNAME)";echo $$(subst $$(CURRENTDIR)/,,$$($(1)GENERATEDFILES))|fmt|sed -e 's/^/  /g'
$$($(1)DIR)/ignore:
	@$$(DISP) "Setting local files list" "$$($(1)SUBNAME)";	cd $$($(1)DIR);echo $$(patsubst $$($(1)DIR)/%,%,$$($(1)GENERATEDFILES))|perl -pi -e 's/ /\n/g'|svn propset svn:ignore -F - . > /dev/null
$$($(1)DIR)/ignorelist:
	@svn propget svn:ignore $$($(1)DIR)|sed -e '/^$$$$/ d'
$$($(1)DIR)/depends:
$$($(1)DIR)/ftp: $(WEBDIR)/ftpaction
endef

$(foreach dir,$(NAMES),$(eval $(call DIR_template,$(dir))))

HOMESUBNAME=home
REALSUBDIRS=$(filter-out $(HOMEDIR),$(SUBDIRS))

define recurse_template
$$(HOMEDIR)/$(1): $$(addsuffix /$(1),$$(REALSUBDIRS))
endef

$(foreach sym,clean distclean fastclean all ignore depends reboot,$(eval $(call recurse_template,$(sym))))

justupdate: $(HOMEDIR)/.stamp-svn
	@$(DISP) "Checking updates" "update"
	@-if [ -d $(HOMEDIR)/.svn ]; then cd $(HOMEDIR);REV=$$(LC_ALL=C svn info|grep ^Revision:|cut -f2 -d' '); svn update --quiet --accept postpone; XREV=$$(LC_ALL=C svn info|grep ^Revision:|cut -f2 -d' '); if [ "$$XREV" != "$$REV" ]; then $(DISP) "Checking updates" "success:$$XREV"; rm -f $(RULESDIR)/release.sty;fi;fi
justuptodate: $(HOMEDIR)/.stamp-svn
	@$(DISP) "Checking updates" "testing home"
	@set -e;if [ -d $(HOMEDIR)/.svn ]; then dir=$$(LANG=C svn info $(HOMEDIR)|grep ^URL|cut -f2 -d' ');lastrev=$$(LANG=C svn info $$dir|grep '^Last Changed Rev:'|cut -f4 -d' '); currev=$$(LANG=C svn info $(HOMEDIR)|grep ^Revision:|cut -f2 -d' ');if [ "$$currev" -lt "$$lastrev" ]; then $(DISP) "Checking updates" "failed: use make update"; false; fi; fi

update: justupdate conflicts
uptodate: justuptodate conflicts

conflicts:
	@set -e;if [ -d $(HOMEDIR)/.svn ]; then $(DISP) "Checking updates" "checking conflicts";a=$$(svn status $(HOMEDIR)|grep '^ *C'||true);if [ -n "$$a" ]; then for i in $$(svn status $(HOMEDIR)|grep '^ *C'|cut -c9-); do $(DISP) "Checking updates" "conflict:$$i"; done; false; fi; fi

$(HOMEDIR)/doc/changelog.db editchangelog:
	@$(BINDIR)/changelog $(HOMEDIR)/doc/changelog.db
$(HOMEDIR)/cl.db cl changelog:
	@$(BINDIR)/changelog $(HOMEDIR)/cl.db

release: uptodate
	@$(DISP) "Pre-committing" "computing release information"
	@release=$$(grep ^release= $(HOMEDIR)/doc/release.txt|cut -f2 -d=);releasename=$$(grep ^name= $(HOMEDIR)/doc/release.txt|cut -f2 -d=);$(BINDIR)/changelog --automatic  --category misc $(HOMEDIR)/cl.db "Releasing version $${release} \"$${releasename}\""
	@$(DISP) "Committing" "merging changelogs"
	@cp $(HOMEDIR)/doc/changelog.db $(HOMEDIR)/doc/changelog.sav ||exit 1
	@$(BINDIR)/changelog --merge $(HOMEDIR)/cl.db $(HOMEDIR)/doc/changelog.db
	@release=$$(grep ^release= $(HOMEDIR)/doc/release.txt|cut -f2 -d=);$(BINDIR)/changelog --release current $$release doc/changelog.db
	@$(DISP) "Committing" "sending data"
	@HELPER="";if [ -f /tmp/eu8-$$(whoami).txt ]; then HELPER="-F /tmp/eu8-$$(whoami).txt"; fi; cd $(HOMEDIR); if svn commit $$HELPER; then true; else mv doc/changelog.sav doc/changelog.db; $(DISP) "Committing" "failed";exit 1; fi
	@$(DISP) "Post-committing" "cleaning"
	@rm -f $(HOMEDIR)/doc/changelog.sav $(HOMEDIR)/cl.db
	@$(DISP) "Post-committing" "done"
commit: uptodate
	@$(DISP) "Pre-committing" "showing changelogs and changes"
	@cd $(HOMEDIR);svn status;a=$$(svn status|grep -v ^?|wc -l);if [ "$$a" -lt 1 ]; then $(DISP) "Committing" "nothing to commit"; exit 1; fi;echo "---- Description of changes ----";$(BINDIR)/changelog --text --current-only cl.db > /tmp/eu8-$$(whoami).txt;cat /tmp/eu8-$$(whoami).txt;echo "---- Press enter (or interrupt with ^C) ----";read a; if [ $$(cat /tmp/eu8-$$(whoami).txt|wc -l) -lt 1 ]; then rm -f /tmp/eu8-$$(whoami).txt;fi
	@$(DISP) "Committing" "merging changelogs"
	@cp $(HOMEDIR)/doc/changelog.db $(HOMEDIR)/doc/changelog.sav ||exit 1
	@$(BINDIR)/changelog --merge $(HOMEDIR)/cl.db $(HOMEDIR)/doc/changelog.db
	@$(DISP) "Committing" "sending data"
	@HELPER="";if [ -f /tmp/eu8-$$(whoami).txt ]; then HELPER="-F /tmp/eu8-$$(whoami).txt"; fi; cd $(HOMEDIR); if svn commit $$HELPER; then true; else mv doc/changelog.sav doc/changelog.db; $(DISP) "Committing" "failed";exit 1; fi
	@$(DISP) "Post-committing" "cleaning"
	@rm -f $(HOMEDIR)/doc/changelog.sav $(HOMEDIR)/cl.db
	@$(DISP) "Post-committing" "done"

online:
	@rm -f $(PIONSDIR)/bitmap/index.txt
	@rm -f $(CARTEDIR)/bitmap/index.txt

listfinal:
	@echo "You can read the following final files";echo $(patsubst $(CURRENTDIR)/%,%,$(filter-out $(HOMEPERSISTENTFILES),$(FINALFILES)))|sort|fmt|sed -e 's/^/  /g'

.PHONY: $(TOPLEVELVIRTUALS) $(VIRTUALS)

info:
	@echo $(notdir $(filter $(CURRENTDIR)/%,$(FILES) $(VIRTUALS)))
ifneq "$(CURRENTDIR)" "."
$(patsubst $(CURRENTDIR)/%,%,$(filter $(CURRENTDIR)/%,$(FILES) $(VIRTUALS))): %: $(CURRENTDIR)/%
endif

%.out:
%.a:
%.ln:
%.o:
%: %.o
%.c:
%: %.c
%.ln: %.c
%.o: %.c
%.cc:
%: %.cc
%.o: %.cc
%.C:
%: %.C
%.o: %.C
%.cpp:
%: %.cpp
%.o: %.cpp
%.p:
%: %.p
%.o: %.p
%.f:
%: %.f
%.o: %.f
%.F:
%: %.F
%.o: %.F
%.f: %.F
%.r:
%: %.r
%.o: %.r
%.f: %.r
%.y:
%.ln: %.y
%.c: %.y
%.l:
%.ln: %.l
%.c: %.l
%.r: %.l
%.s:
%: %.s
%.o: %.s
%.S:
%: %.S
%.o: %.S
%.s: %.S
%.mod:
%: %.mod
%.o: %.mod
%.sym:
%.def:
%.sym: %.def
%.h:
%.info:
%.dvi:
%.tex:
%.dvi: %.tex
%.texinfo:
%.info: %.texinfo
%.dvi: %.texinfo
%.texi:
%.info: %.texi
%.dvi: %.texi
%.txinfo:
%.info: %.txinfo
%.dvi: %.txinfo
%.w:
%.c: %.w
%.tex: %.w
%.ch:
%.web:
%.p: %.web
%.tex: %.web
%.sh:
%: %.sh
%.elc:
%.el:
%.out: %
%.c: %.w %.ch
%.tex: %.w %.ch
%:: %,v
%:: RCS/%,v
%:: RCS/%
%:: s.%
%:: SCCS/s.%

.NOTPARALLEL:
