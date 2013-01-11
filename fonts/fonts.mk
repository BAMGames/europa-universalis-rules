# Local defs
FONTSCOMMON=$(BINDIR)/makeencodings
FONTSARIAL=$(addprefix $(FONTSDIR)/,ArialNarrow.afm  ArialNarrow-Italic.afm ArialNarrow-Bold.afm ArialNarrow.pfb  ArialNarrow-Italic.pfb ArialNarrow-Bold.pfb)
FONTSCHAMPION=$(addprefix $(FONTSDIR)/,ChampionCourrierNormal.afm ChampionTraditionNormal.afm ChampionExpertNormal.afm ChampionCourrierNormal.pfb ChampionTraditionNormal.pfb ChampionExpertNormal.pfb)

# Local targets
FONTSVIRTUALS=
FONTSFINALTARGETS=
FONTSNOTALLTARGETS=
FONTSTARGETS=encodings.eps champion.eps arial_narrow.eps stamp-texfonts
FONTSDEBUGTARGETS=
FONTSSLOWTARGETS=$(FONTSNOTALLTARGETS) stamp-texfonts

# Other files
$(FONTSDIR)/encodings.eps: $(FONTSCOMMON)
	@$(DISP) "Building font metrics" "encodings"
	@$(BINDIR)/makeencodings --encodings > $@
$(FONTSDIR)/champion.eps: $(FONTSCOMMON) $(FONTSCHAMPION)
	@$(DISP) "Building font metrics" "champion"
	@$(BINDIR)/makeencodings --metrics --ratio 0.2 --factor 1 --range 0,1,32 $(FONTSCHAMPION) > $@
$(FONTSDIR)/arial_narrow.eps: $(FONTSCOMMON) $(FONTSARIAL)
	@$(DISP) "Building font metrics" "arial_narrow"
	@$(BINDIR)/makeencodings --metrics --ratio 0.27 --factor 0.8 $(FONTSARIAL) > $@

$(FONTSDIR)/stamp-texfonts: $(HOMEDIR)/.stamp-tex $(FONTSDIR)/texfonts.def
	@set -e;for i in $$(cat $(FONTSDIR)/texfonts.def); do c=$${i%;*};d=$${i##*;};$(BINDIR)/install-pack --logfile $(LOGFILE) $${d:+--test $${d}} --fail $@ $${c%:*} $${c##*:}; done; cp $(FONTSDIR)/texfonts.def $@
