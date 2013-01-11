# Local defs
DEBUGSUFFIXES=.aux .bbl .blg .idx .ilg .ind .lof .log .lot .md5 .out .toc .xmp
ifdef DEPENDS
RULESTEXEXTRA = --strace /tmp/eu8depends.txt
endif

# Automatic section
TEXTFIGFILES = $(addprefix $(FIGDIR)/,\
 autrereligion.pdf\
 catholique.pdf\
 etoile.pdf\
 orthodoxe.pdf\
 protestant.pdf)
TEXTRECORDSFILES = $(addprefix $(RECORDSDIR)/,\
)
TEXTCOUNTERBITMAPFILES = $(addprefix $(COUNTERBITMAPDIR)/,\
)
TEXTMAPBITMAPFILES = $(addprefix $(MAPBITMAPDIR)/,\
)
TEXTBLASONSFILES = $(addprefix $(BLASONSDIR)/,\
)
TEXTSRCFILES = $(addprefix $(RULESDIR)/,\
 barlist.sty\
 engCommandes.tex\
 engCorpsMineurs.tex\
 engCountryTables.tex\
 engEntetesMineurs.tex\
 engGeneralTables.tex\
 engLeaders.tex\
 engTables.tex\
 euTables.tex\
 europa.sty\
 foreach.sty\
 gametables.sty\
 graytab.sty\
 pageprefix.sty\
 release.sty\
 simplerules.cls\
 tikzlibraryxsize.code.tex\
 translations.tex\
 unicodetricks.sty\
 xnameref.sty)
TEXFIGFILES = $(addprefix $(FIGDIR)/,\
 anchor.png\
 anchor2.png\
 anchor3.png\
 anchor4.png\
 anchor5.png\
 ancrefluviale.pdf\
 appendix.jpg\
 appendixmajor.jpg\
 autrereligion.pdf\
 basics.jpg\
 bateau.png\
 blocus.png\
 catholique.pdf\
 chess.jpg\
 chiite.pdf\
 diplomacy.jpg\
 economicalevents.jpg\
 etoile.pdf\
 events.jpg\
 expenses.jpg\
 incomes.jpg\
 military.jpg\
 mine.png\
 orthodoxe.pdf\
 politicalevents.jpg\
 powers.jpg\
 protestant.pdf\
 scenarios.jpg\
 sel.png\
 specificrules.jpg\
 strategy.jpg\
 sunnite.pdf\
 victories.jpg\
 ville1.png\
 ville2.png\
 villechine1.png\
 villechine2.png\
 villeinde1.png\
 villeinde2.png\
 winning.jpg)
TEXRECORDSFILES = $(addprefix $(RECORDSDIR)/,\
 accounting-income.pdf\
 accounting-rt.pdf)
TEXCOUNTERBITMAPFILES = $(addprefix $(COUNTERBITMAPDIR)/,\
 counter_7/King_russie.png\
 counter_7/King_venise_doge.png\
 counter_7/LeaderDouble_porviceroy_Albuquerque_recto.png\
 counter_7/LeaderDouble_porviceroy_Albuquerque_verso.png\
 counter_7/Leader_angseahound_Drake.png\
 counter_7/Leader_espagne_Toledo.png\
 counter_7/Leader_france_Vauban.png\
 counter_7/Leader_mogol_Akbar.png\
 counter_7/Leader_turquie_Sirocco.png\
 counter_7/Leader_usa_Arnold.png\
 counter_7/Pacha_timar_Amar_recto.png\
 counter_7/Pacha_timar_Amar_verso.png)
TEXMAPBITMAPFILES = $(addprefix $(MAPBITMAPDIR)/,\
)
TEXBLASONSFILES = $(addprefix $(BLASONSDIR)/,\
 shield_aceh.png\
 shield_aden.png\
 shield_afghans.png\
 shield_algerie.png\
 shield_alsace.png\
 shield_angleterre.png\
 shield_arabie.png\
 shield_astrakhan.png\
 shield_azteque.png\
 shield_bade.png\
 shield_balkans.png\
 shield_baviere.png\
 shield_belgique.png\
 shield_berg.png\
 shield_boheme.png\
 shield_bourgogne.png\
 shield_brandebourg.png\
 shield_brunswick.png\
 shield_catalogne.png\
 shield_chevaliers.png\
 shield_chine.png\
 shield_cologne.png\
 shield_corse.png\
 shield_cosaquesdon.png\
 shield_courlande.png\
 shield_crimee.png\
 shield_cyrenaique.png\
 shield_damas.png\
 shield_danemark.png\
 shield_eastprussia.png\
 shield_ecosse.png\
 shield_espagne.png\
 shield_finlande.png\
 shield_flandrebrabant.png\
 shield_france.png\
 shield_genes.png\
 shield_georgie.png\
 shield_grenade.png\
 shield_gujarat.png\
 shield_habsbourg.png\
 shield_hanovre.png\
 shield_hanse.png\
 shield_hesse.png\
 shield_hollande.png\
 shield_hongrie.png\
 shield_huguenots.png\
 shield_hyderabad.png\
 shield_inca.png\
 shield_irak.png\
 shield_irlande.png\
 shield_iroquois.png\
 shield_japon.png\
 shield_kazan.png\
 shield_liege.png\
 shield_liflandie.png\
 shield_lithuanie.png\
 shield_lorraine.png\
 shield_lucca.png\
 shield_mamelouks.png\
 shield_maroc.png\
 shield_mayence.png\
 shield_mazovie.png\
 shield_milan.png\
 shield_modene.png\
 shield_mogol.png\
 shield_moldavie.png\
 shield_montferrat.png\
 shield_mysore.png\
 shield_naples.png\
 shield_natives.png\
 shield_norvege.png\
 shield_oldenburg.png\
 shield_oman.png\
 shield_oresund.png\
 shield_palatinat.png\
 shield_papaute.png\
 shield_parme.png\
 shield_perse.png\
 shield_pirates.png\
 shield_pologne.png\
 shield_pommeranie.png\
 shield_portugal.png\
 shield_prusse.png\
 shield_pskov.png\
 shield_rebelles.png\
 shield_royalistes.png\
 shield_russie.png\
 shield_ryazan.png\
 shield_saint-empire.png\
 shield_sainte-ligue.png\
 shield_savoie.png\
 shield_saxe.png\
 shield_siberie.png\
 shield_soudan.png\
 shield_steppes.png\
 shield_suede.png\
 shield_suisse.png\
 shield_teutoniques1.png\
 shield_teutoniques2.png\
 shield_thuringe.png\
 shield_toscane.png\
 shield_transylvanie.png\
 shield_treves.png\
 shield_tripoli.png\
 shield_tunisie.png\
 shield_turquie.png\
 shield_ukraine.png\
 shield_usa.png\
 shield_valachie.png\
 shield_venise.png\
 shield_vijayanagar.png\
 shield_wurtemberg.png)
TEXSRCFILES = $(addprefix $(RULESDIR)/,\
 EUevents.sty\
 EUtheme.sty\
 barlist.sty\
 engAlpha.tex\
 engAnnexe.tex\
 engAustria.tex\
 engBasic.tex\
 engCommandes.tex\
 engCopyleft.tex\
 engCorpsMineurs.tex\
 engCountryTables.tex\
 engDiplomacy.tex\
 engDiplomacyAlliance.tex\
 engDiplomacyMinor.tex\
 engDiplomacyROTW.tex\
 engDiplomacyWar.tex\
 engDiplomacyWarROTW.tex\
 engERS.tex\
 engEngland.tex\
 engEntetesMineurs.tex\
 engEvnt1.tex\
 engEvnt2.tex\
 engEvnt3.tex\
 engEvnt4.tex\
 engEvnt5.tex\
 engEvnt6.tex\
 engEvnt7.tex\
 engEvntEco.tex\
 engEvntFWR.tex\
 engEvntGen.tex\
 engEvntRules.tex\
 engEvntTYW.tex\
 engExpAdmin.tex\
 engExpLogistic.tex\
 engExpenses.tex\
 engFrance.tex\
 engGameSequence.tex\
 engGeneralTables.tex\
 engGreatCampaign.tex\
 engHolland.tex\
 engIncomes.tex\
 engIntroduction.tex\
 engLeaders.tex\
 engMilitary.tex\
 engMilitaryFrench.tex\
 engMinorCountries.tex\
 engObjectives.tex\
 engPeace.tex\
 engPlaying.tex\
 engPoland.tex\
 engPoliticalRules.tex\
 engPortugal.tex\
 engPrussia.tex\
 engRussia.tex\
 engScenarios.tex\
 engSpain.tex\
 engSpecificRules.tex\
 engStrategy.tex\
 engSweden.tex\
 engTables.tex\
 engThePowers.tex\
 engTurkey.tex\
 engVenice.tex\
 engVictories.tex\
 europa.sty\
 foreach.sty\
 gametables.sty\
 graytab.sty\
 newpaper.sty\
 pageprefix.sty\
 release.sty\
 simplerules.cls\
 tikzlibraryxsize.code.tex\
 translations.tex\
 unicodetricks.sty\
 xnameref.sty)
TEXHFIGFILES = $(addprefix $(FIGDIR)/,\
 autrereligion.pdf\
 catholique.pdf\
 chiite.pdf\
 etoile.pdf\
 orthodoxe.pdf\
 protestant.pdf\
 sunnite.pdf)
TEXHRECORDSFILES = $(addprefix $(RECORDSDIR)/,\
)
TEXHCOUNTERBITMAPFILES = $(addprefix $(COUNTERBITMAPDIR)/,\
)
TEXHMAPBITMAPFILES = $(addprefix $(MAPBITMAPDIR)/,\
)
TEXHBLASONSFILES = $(addprefix $(BLASONSDIR)/,\
)
TEXHSRCFILES = $(addprefix $(RULESDIR)/,\
 barlist.sty\
 engCommandes.tex\
 engCorpsMineurs.tex\
 engEntetesMineurs.tex\
 engLeaders.tex\
 euMinors.tex\
 europa.sty\
 foreach.sty\
 gametables.sty\
 graytab.sty\
 pageprefix.sty\
 release.sty\
 simplerules.cls\
 tikzlibraryxsize.code.tex\
 translations.tex\
 unicodetricks.sty\
 xnameref.sty)
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
 barlist.sty\
 engCommandes.tex\
 engEntetesMineurs.tex\
 engObjectives.tex\
 euObjectives.tex\
 europa.sty\
 foreach.sty\
 gametables.sty\
 graytab.sty\
 pageprefix.sty\
 release.sty\
 simplerules.cls\
 tikzlibraryxsize.code.tex\
 translations.tex\
 unicodetricks.sty\
 xnameref.sty)
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

$(RULESDIR)/release.sty: $(HOMEDIR)/conf.mk $(HOMEDIR)/.stamp-svn $(HOMEDIR)/doc/release.txt $(BINDIR)/displayrelease
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
grep -v ENOENT /tmp/eu8depends.txt |grep O_RDONLY|cut -f2 -d\"|grep -v ^/|sort|uniq>/tmp/eu8depends2.txt;\
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
	@(if [ -f "$(RULESDIR)/engAlpha.log" ]; then cat $(RULESDIR)/engAlpha.log ; else tar xzOf $(RULESDIR)/engAlpha.tgz engAlpha.log;fi)|perl -e 'BEGIN {$$DISPLAY=0;$$BUF="";$$currpage=0} while (<>) {chomp; s/\x9f/\xC2\xA7/g; $$currpage=sprintf("%03d",$$1+1) if (/^Page:(.*)$$/); $$DISPLAY=1 if (/(^..Package.*Warning)|(^LaTeX War)|(^pdfTeX war)|(^Overfull)|(^Underfull)|(^Missing character:)/ || s/^.*(pdfTeX war.*)$$/$$1/g);next unless ($$DISPLAY);$$BUF.=$$_;next unless (/^$$/ or /^Missing character:/);if ($$BUF=~ /^Overfull/ or $$BUF=~/^Underfull/) {$$BUF=~s/\\LUC[^T]*/~~~\\T/g;$$BUF=~s/[\\\\][A-Z][^ ]* /\xC2\xB7/g;$$BUF=~s/\xC2\xB7//g};printf "%s: %s\n",$$currpage,$$BUF;$$BUF="";$$DISPLAY=0;};'|sort

$(RULESDIR)/reformat:
	@cd $(RULESDIR);for i in engAlpha.tex engEvnt*.tex engAnnexe.tex engVictories.tex engDiplomacyAlliance.tex engThePowers.tex engDiplomacy.tex engDiplomacyMinor.tex engExpenses.tex engExpAdmin.tex engExpLogistic.tex engDiplomacyWar.tex engPoliticalRules.tex engBasic.tex engObjectives.tex euObjectives.tex; do ../bin/reformattex $$i; done
