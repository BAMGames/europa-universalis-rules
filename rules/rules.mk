# Local defs
DEBUGSUFFIXES=.aux .bbl .blg .idx .ilg .ind .lof .log .lot .md5 .out .toc .xmp
ifdef DEPENDS
RULESTEXEXTRA = --strace /tmp/eu8depends.txt
endif

# Automatic section
TEXTFIGFILES = $(addprefix $(FIGDIR)/,\
)
TEXTRECORDSFILES = $(addprefix $(RECORDSDIR)/,\
)
TEXTCOUNTERBITMAPFILES = $(addprefix $(COUNTERBITMAPDIR)/,\
)
TEXTMAPBITMAPFILES = $(addprefix $(MAPBITMAPDIR)/,\
)
TEXTBLASONSFILES = $(addprefix $(BLASONSDIR)/,\
)
TEXTSRCFILES = $(addprefix $(RULESDIR)/,\
)
TEXFIGFILES = $(addprefix $(FIGDIR)/,\
)
TEXRECORDSFILES = $(addprefix $(RECORDSDIR)/,\
)
TEXCOUNTERBITMAPFILES = $(addprefix $(COUNTERBITMAPDIR)/,\
)
TEXMAPBITMAPFILES = $(addprefix $(MAPBITMAPDIR)/,\
)
TEXBLASONSFILES = $(addprefix $(BLASONSDIR)/,\
)
TEXSRCFILES = $(addprefix $(RULESDIR)/,\
)
TEXHFIGFILES = $(addprefix $(FIGDIR)/,\
)
TEXHRECORDSFILES = $(addprefix $(RECORDSDIR)/,\
)
TEXHCOUNTERBITMAPFILES = $(addprefix $(COUNTERBITMAPDIR)/,\
)
TEXHMAPBITMAPFILES = $(addprefix $(MAPBITMAPDIR)/,\
)
TEXHBLASONSFILES = $(addprefix $(BLASONSDIR)/,\
)
TEXHSRCFILES = $(addprefix $(RULESDIR)/,\
)
TEXOFIGFILES = $(addprefix $(FIGDIR)/,\
)
TEXORECORDSFILES = $(addprefix $(RECORDSDIR)/,\
)
TEXOCOUNTERBITMAPFILES = $(addprefix $(COUNTERBITMAPDIR)/,\
)
TEXOMAPBITMAPFILES = $(addprefix $(MAPBITMAPDIR)/,\
)
TEXOBLASONSFILES = $(addprefix $(BLASONSDIR)/,\
)
TEXOSRCFILES = $(addprefix $(RULESDIR)/,\
)
# End automatic

TEXRULESDEP=$(TEXSRCFILES) $(TEXFIGFILES) $(TEXRECORDSFILES) $(TEXBLASONSFILES) $(TEXCOUNTERBITMAPFILES) $(TEXMAPBITMAPFILES) $(FONTSDIR)/stamp-texfonts
TEXTRULESDEP=$(TEXTSRCFILES) $(TEXTFIGFILES) $(TEXTRECORDSFILES) $(TEXTBLASONSFILES) $(TEXTCOUNTERBITMAPFILES) $(TEXTMAPBITMAPFILES) $(FONTSDIR)/stamp-texfonts
TEXHRULESDEP=$(TEXHSRCFILES) $(TEXHFIGFILES) $(TEXHRECORDSFILES) $(TEXHBLASONSFILES) $(TEXHCOUNTERBITMAPFILES) $(TEXHMAPBITMAPFILES) $(FONTSDIR)/stamp-texfonts
TEXORULESDEP=$(TEXOSRCFILES) $(TEXOFIGFILES) $(TEXORECORDSFILES) $(TEXOBLASONSFILES) $(TEXOCOUNTERBITMAPFILES) $(TEXOMAPBITMAPFILES) $(FONTSDIR)/stamp-texfonts

$(RULESDIR)/engAlpha.pdf: $(TEXRULESDEP)
$(RULESDIR)/euTables.pdf: $(TEXTRULESDEP)
$(RULESDIR)/euMinors.pdf: $(TEXHRULESDEP)
$(RULESDIR)/euObjectives.pdf: $(TEXORULESDEP)

# Local targets
RULESVIRTUALS=depends view errors reformat
RULESFINALTARGETS=euTables.pdf engAlpha.pdf euMinors.pdf euObjectives.pdf
RULESNOTALLTARGETS=
RULESTARGETS=translations.tex engLeaders.tex leaders.utf release.sty
RULESCRUFT=booklet.aux booklet.log booklet2.aux booklet2.log booklet.pdf booklet2.pdf
RULESDEBUGTARGETS=$(addprefix engAlpha,.tgz $(DEBUGSUFFIXES)) $(addprefix euMinors,.tgz $(DEBUGSUFFIXES)) $(addprefix euTables,.tgz $(DEBUGSUFFIXES)) $(addprefix euObjectives,.tgz $(DEBUGSUFFIXES)) missfont.log release.sty.new
RULESSLOWTARGETS=$(RULESNOTALLTARGETS) engAlpha.tgz

.PRECIOUS: $(addprefix $(RULESDIR)/,$(RULESFINALTARGETS))

# Final files

$(RULESDIR)/engAlpha.pdf: $(HOMEDIR)/.stamp-tex $(BINDIR)/compile-latex
	@$(BINDIR)/displayrelease --tex > $(RULESDIR)/release.sty.new;if [ -f $(RULESDIR)/release.sty ] && diff -q $(RULESDIR)/release.sty $(RULESDIR)/release.sty.new > /dev/null; then rm -f $(RULESDIR)/release.sty.new; else $(DISP) "Building rules auxiliary files" "release"; mv $(RULESDIR)/release.sty.new $(RULESDIR)/release.sty; fi
	@$(BINDIR)/compile-latex $(RULESTEXEXTRA) --log $(LOGFILE) engAlpha.tex --index rules.ist $^

$(RULESDIR)/euTables.pdf: $(HOMEDIR)/.stamp-tex $(BINDIR)/compile-latex
	@$(BINDIR)/displayrelease --tex > $(RULESDIR)/release.sty.new;if [ -f $(RULESDIR)/release.sty ] && diff -q $(RULESDIR)/release.sty $(RULESDIR)/release.sty.new > /dev/null; then rm -f $(RULESDIR)/release.sty.new; else $(DISP) "Building rules auxiliary files" "release"; mv $(RULESDIR)/release.sty.new $(RULESDIR)/release.sty; fi
	@$(BINDIR)/compile-latex $(RULESTEXEXTRA) --log $(LOGFILE) euTables.tex $^

$(RULESDIR)/euMinors.pdf: $(HOMEDIR)/.stamp-tex $(BINDIR)/compile-latex
	@$(BINDIR)/displayrelease --tex > $(RULESDIR)/release.sty.new;if [ -f $(RULESDIR)/release.sty ] && diff -q $(RULESDIR)/release.sty $(RULESDIR)/release.sty.new > /dev/null; then rm -f $(RULESDIR)/release.sty.new; else $(DISP) "Building rules auxiliary files" "release"; mv $(RULESDIR)/release.sty.new $(RULESDIR)/release.sty; fi
	@$(BINDIR)/compile-latex $(RULESTEXEXTRA) --log $(LOGFILE) euMinors.tex $^

$(RULESDIR)/euObjectives.pdf: $(HOMEDIR)/.stamp-tex $(BINDIR)/compile-latex
	@$(BINDIR)/displayrelease --tex > $(RULESDIR)/release.sty.new;if [ -f $(RULESDIR)/release.sty ] && diff -q $(RULESDIR)/release.sty $(RULESDIR)/release.sty.new > /dev/null; then rm -f $(RULESDIR)/release.sty.new; else $(DISP) "Building rules auxiliary files" "release"; mv $(RULESDIR)/release.sty.new $(RULESDIR)/release.sty; fi
	@$(BINDIR)/compile-latex $(RULESTEXEXTRA) --log $(LOGFILE) euObjectives.tex $^

# Other files

$(RULESDIR)/translations.tex: $(RULESDIR)/translations.utf $(RULESDIR)/leaders.utf
	@$(DISP) "Building rules auxiliary files" "extended text"
	@$(BINDIR)/translate.pl $@ $(RULESDIR)/translations.utf $(RULESDIR)/leaders.utf

$(RULESDIR)/leaders.utf $(RULESDIR)/engLeaders.tex: $(PIONSDIR)/anonymes.txt $(PIONSDIR)/leaders.txt $(BINDIR)/extract_leaders
	@$(DISP) "Building rules auxiliary files" "leader info"
	@$(BINDIR)/extract_leaders $(RULESDIR)/engLeaders.tex $(RULESDIR)/leaders.utf $(PIONSDIR)/anonymes.txt $(PIONSDIR)/leaders.txt

$(RULESDIR)/release.sty: $(HOMEDIR)/conf.mk $(HOMEDIR)/.stamp-git $(HOMEDIR)/doc/release.txt $(BINDIR)/displayrelease
	@$(BINDIR)/displayrelease --tex > $@.new
	@if [ -f $@ ] && diff -q $@ $@.new > /dev/null; then rm -f $@.new; else $(DISP) "Building rules auxiliary files" "release"; mv $@.new $@; fi

# Virtual actions

$(RULESDIR)/depends:
	@counterbitmapdir=../pions/bitmap;\
mapbitmapdir=../pions/carte;\
figdir=../$(notdir $(FIGDIR));\
recordsdir=../$(notdir $(RECORDSDIR));\
blasonsdir=../$(notdir $(BLASONSDIR));\
sed -ne '1,/# Automatic section/ p' < $(RULESDIR)/rules.mk > $(RULESDIR)/rules.mk2;\
for xtarget in euTables.pdf:TEXT engAlpha.pdf:TEX euMinors.pdf:TEXH euObjectives.pdf:TEXO;\
 do target=$${xtarget%:*};\
root=$${xtarget#*:};\
rm -f $(RULESDIR)/$${target} 2>&1 > /dev/null;\
DEPENDS=1 make -s $(RULESDIR)/$$target;\
grep -v ENOENT /tmp/eu8depends.txt |grep O_RDONLY|cut -f2 -d\"|grep -v ^/|LC_ALL=C sort|uniq>/tmp/eu8depends2.txt;\
echo -n "$${root}FIGFILES" '= $$(addprefix $$(FIGDIR)/,' >> $(RULESDIR)/rules.mk2;\
grep ^$${figdir} /tmp/eu8depends2.txt|sed -e "s|^$${figdir}/||g"|xargs -n 1 echo -ne '\\\n' >> $(RULESDIR)/rules.mk2;\
echo ")" >> $(RULESDIR)/rules.mk2;\
echo -n "$${root}RECORDSFILES" '= $$(addprefix $$(RECORDSDIR)/,' >> $(RULESDIR)/rules.mk2;\
grep ^$${recordsdir} /tmp/eu8depends2.txt|sed -e "s|^$${recordsdir}/||g"|xargs -n 1 echo -ne '\\\n' >> $(RULESDIR)/rules.mk2;\
echo ")" >> $(RULESDIR)/rules.mk2;\
echo -n "$${root}COUNTERBITMAPFILES" '= $$(addprefix $$(COUNTERBITMAPDIR)/,' >> $(RULESDIR)/rules.mk2;\
grep ^$${counterbitmapdir} /tmp/eu8depends2.txt|sed -e "s|^$${counterbitmapdir}/||g"|xargs -n 1 echo -ne '\\\n' >> $(RULESDIR)/rules.mk2;\
echo ")" >> $(RULESDIR)/rules.mk2;\
echo -n "$${root}MAPBITMAPFILES" '= $$(addprefix $$(MAPBITMAPDIR)/,' >> $(RULESDIR)/rules.mk2;\
grep ^$${mapbitmapdir} /tmp/eu8depends2.txt|sed -e "s|^$${mapbitmapdir}/||g"|xargs -n 1 echo -ne '\\\n' >> $(RULESDIR)/rules.mk2;\
echo ")" >> $(RULESDIR)/rules.mk2;\
echo -n "$${root}BLASONSFILES" '= $$(addprefix $$(BLASONSDIR)/,' >> $(RULESDIR)/rules.mk2;\
grep ^$${blasonsdir} /tmp/eu8depends2.txt|sed -e "s|^$${blasonsdir}/||g"|xargs -n 1 echo -ne '\\\n' >> $(RULESDIR)/rules.mk2;\
echo ")" >> $(RULESDIR)/rules.mk2;\
echo -n "$${root}SRCFILES" '= $$(addprefix $$(RULESDIR)/,' >> $(RULESDIR)/rules.mk2;\
grep -E 'tex$$|cls$$|sty$$' /tmp/eu8depends2.txt|grep -v ^\./|xargs -n 1 echo -ne '\\\n' >> $(RULESDIR)/rules.mk2;\
echo ")" >> $(RULESDIR)/rules.mk2;\
done;\
sed -ne '/# End automatic/,$$ p' < $(RULESDIR)/rules.mk >> $(RULESDIR)/rules.mk2;\
mv $(RULESDIR)/rules.mk2 $(RULESDIR)/rules.mk

$(RULESDIR)/view: $(RULESDIR)/engAlpha.pdf
	@$(BINDIR)/acroread $^

$(RULESDIR)/errors:
	@(if [ -f "$(RULESDIR)/engAlpha.log" ]; then cat $(RULESDIR)/engAlpha.log ; else tar xzOf $(RULESDIR)/engAlpha.tgz engAlpha.log;fi)|perl -e 'BEGIN {$$DISPLAY=0;$$BUF="";$$currpage=0} while (<>) {chomp; s/\x9f/\xC2\xA7/g; $$currpage=sprintf("%03d",$$1+1) if (/^Page:(.*)$$/); $$DISPLAY=1 if (/(^..Package.*Warning)|(^LaTeX War)|(^pdfTeX war)|(^Overfull)|(^Underfull)|(^Missing character:)/ || s/^.*(pdfTeX war.*)$$/$$1/g);next unless ($$DISPLAY);$$BUF.=$$_;next unless (/^$$/ or /^Missing character:/);if ($$BUF=~ /^Overfull/ or $$BUF=~/^Underfull/) {$$BUF=~s/\\LUC[^T]*/~~~\\T/g;$$BUF=~s/[\\\\][A-Z][^ ]* /\xC2\xB7/g;$$BUF=~s/\xC2\xB7//g};printf "%s: %s\n",$$currpage,$$BUF;$$BUF="";$$DISPLAY=0;};'|LC_ALL=C sort

$(RULESDIR)/reformat:
	@cd $(RULESDIR);for i in engAlpha.tex engEvnt*.tex engAnnexe.tex engVictories.tex engDiplomacyAlliance.tex engThePowers.tex engDiplomacy.tex engDiplomacyMinor.tex engExpenses.tex engExpAdmin.tex engExpLogistic.tex engDiplomacyWar.tex engPoliticalRules.tex engBasic.tex engObjectives.tex euObjectives.tex; do ../bin/reformattex $$i; done
