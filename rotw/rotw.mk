# Local defs
ROTWCLASS=Building ROTW maps
ifdef DEPENDS
ROTWGSEXTRA = -SDEPENDS=$(ROTWDIR)/depends.txt
ROTWMAPEXTRA = +depends
ROTWCLASS=Building depends
endif
ROTWGSEXTRA += -SCURRENTDIR=$(ROTWDIR)
# Automatic section
ROTWBLASONS = aden afghans angleterre azteque chine espagne france gujarat habsbourg hollande hyderabad inca iroquois japon mogol mysore oman perse pologne portugal prusse russie siberie soudan suede tordesillas turquie venise vijayanagar chineespagne caraibes
ROTWSHADOWS = america anchor anchor2 anchor3 areacold bateau blocus bois coton drapeauforet drapeauplaine epices esclaves indigene00 indigene01 indigene02 indigene03 indigene04 indigene05 indigene06 indigene07 indigene08 indigene09 indigene10 indigene11 indigene12 indigene13 indigene14 indigene15 indigene16 indigene17 indigene18 indigene19 indigene20 indigene21 indigene22 indigene23 inflation mine orient peaux peche rocher sel soie sucre ville1 villechine1 villechine2 villeinde1 villeinde2
# End automatic
ROTWCOLORMAPEXTFILES=$(addprefix $(BLASONSDIR)/shield_,$(addsuffix .pnm,$(ROTWBLASONS))) $(addprefix $(SHADOWDIR)/,$(addsuffix .pnm,$(ROTWSHADOWS))) $(addprefix $(SHADOWDIR)/,$(addsuffix .pgm,$(ROTWSHADOWS)))

# Local targets
ROTWVIRTUALS=view miniview bs
ROTWFINALTARGETS=carterotw8.pdf rotwsmall.pdf
ROTWNOTALLTARGETS=clipped.pdf
ROTWTARGETS=activation.eps ressource.eps carres.eps text.eps fonddecarte.clp minifonddecarte.clp moretraces.js
ROTWDEBUGTARGETS=rotw.mk2 depends.txt targets
ROTWSLOWTARGETS=fonddecarte.clp minifonddecarte.clp carres.eps

# Final files

$(ROTWDIR)/moretraces.js $(ROTWDIR)/carterotw8.pdf: $(ROTWCOMMON) $(GSCOLORMAPCOMMON) $(addprefix $(ROTWDIR)/,source.eps activation.eps carres.eps fonddecarte.clp clip1.clp clip2.clp clip3.clp images.eps portsandmines.eps ressource.eps text.eps) $(ROTWCOLORMAPEXTFILES)
	@$(DISP) "$(ROTWCLASS)" "map$(ROTWMAPEXTRA)"
	@-if [ ! -d "$(ROTWDIR)/targets" ]; then mkdir $(ROTWDIR)/targets; fi
	@$(GSEXEC) $(ROTWGSEXTRA) -sOutput=$(ROTWDIR)/carterotw8.pdf -DPDFOUTPUT $(ROTWDIR)/source.eps
	@$(RMTARGETS) $(ROTWDIR)/targets

$(ROTWDIR)/rotwsmall.pdf: $(ROTWCOMMON) $(GSMAPCOMMON) $(addprefix $(ROTWDIR)/,mini.eps minifonddecarte.clp)
	@$(DISP) "$(ROTWCLASS)" "minimap"
	@-if [ ! -d "$(ROTWDIR)/targets" ]; then mkdir $(ROTWDIR)/targets; fi
	@$(GSEXEC) $(ROTWGSEXTRA) -sOutput=$@ -DPDFOUTPUT $(ROTWDIR)/mini.eps
	@$(RMTARGETS) $(ROTWDIR)/targets

# Other files

$(ROTWDIR)/carres.eps $(ROTWDIR)/fonddecarte.clp: $(ROTWCOMMON) $(GSCHEMINCOMMON) $(ROTWDIR)/chemins.eps
	@$(DISP) "$(ROTWCLASS)" "map background"
	@-$(GSEXEC) $(ROTWGSEXTRA) -DPDFOUTPUT $(ROTWDIR)/chemins.eps > $(ROTWDIR)/fonddecarte.clp
	@if grep ^Error: $(ROTWDIR)/fonddecarte.clp; then grep -B 3 -A 8 ^Error: < $(ROTWDIR)/fonddecarte.clp; rm $(ROTWDIR)/fonddecarte.clp; false;fi

$(ROTWDIR)/minifonddecarte.clp: $(ROTWCOMMON) $(GSCHEMINCOMMON) $(ROTWDIR)/chemins.eps
	@$(DISP) "$(ROTWCLASS)" "minimap background"
	@-$(GSEXEC) $(ROTWGSEXTRA) -DPLAIN $(ROTWDIR)/chemins.eps > $(ROTWDIR)/minifonddecarte.clp
	@if grep ^Error: $(ROTWDIR)/minifonddecarte.clp; then grep -B 3 -A 8 ^Error: < $(ROTWDIR)/minifonddecarte.clp; rm $(ROTWDIR)/minifonddecarte.clp; false;fi

$(ROTWDIR)/text.eps: $(ROTWCOMMON) $(BINDIR)/analyse.pl $(ROTWDIR)/noms.utf
	@$(DISP) "$(ROTWCLASS)" "text"
	@$(BINDIR)/analyse.pl $(ROTWDIR)/noms.utf > $@

$(ROTWDIR)/ressource.eps: $(ROTWCOMMON) $(BINDIR)/createressources.pl $(RULESDIR)/ressources.gnumeric
	@$(DISP) "$(ROTWCLASS)" "ressources"
	@$(BINDIR)/createressources.pl $(RULESDIR)/ressources.gnumeric > $@

$(ROTWDIR)/activation.eps: $(ROTWCOMMON) $(RULESDIR)/engCorpsMineurs.tex
	@$(DISP) "$(ROTWCLASS)" "activations"
	@echo '/activationdict <<' > $@
	@grep ^.minoractivation $^|perl -pe 's/^.*minoractivation{([a-z]*)}{?([0-9]*)}?%? ?(.*)$$/\/\1 (\2\3)/g;s/ormus/perse/g;' >>$@
	@echo '>> def' >>$@

$(ROTWDIR)/clipped.pdf: $(ROTWCOMMON) $(GSCOLORMAPCOMMON) $(addprefix $(ROTWDIR)/,source.eps activation.eps carres.eps fonddecarte.clp clip1.clp clip2.clp clip3.clp images.eps portsandmines.eps ressource.eps text.eps) $(ROTWCOLORMAPEXTFILES)
	@$(DISP) "$(ROTWCLASS)" "map(clippable)"
	@-if [ ! -d "$(ROTWDIR)/targets" ]; then mkdir $(ROTWDIR)/targets; fi
	@$(GSEXEC) $(ROTWGSEXTRA) -DCLIP -sOutput=$@ -DPDFOUTPUT $(ROTWDIR)/source.eps
	@$(RMTARGETS) $(ROTWDIR)/targets

# Virtual actions

$(ROTWDIR)/view: $(ROTWDIR)/carterotw8.pdf
	@$(BINDIR)/acroread $^
$(ROTWDIR)/miniview: $(ROTWDIR)/rotwsmall.pdf
	@$(BINDIR)/acroread $^
$(ROTWDIR)/depends: $(ROTWDIR)/carterotw8.pdf
	@$(DISP) "Building depends" "rotw"
	@rm -f $(ROTWDIR)/depends.txt
	@touch -r $(ROTWDIR)/carterotw8.pdf $(ROTWDIR)/depends.txt
	@rm -f $(ROTWDIR)/carterotw8.pdf
	@DEPENDS=1 XID=$(XID) make -s $(ROTWDIR)/carterotw8.pdf
	@$(DISP) "Building depends" "rotw.mk"
	@touch -r $(ROTWDIR)/depends.txt $(ROTWDIR)/carterotw8.pdf
	@sed -ne '1,/^# Automatic section/ p' < $(ROTWDIR)/rotw.mk > $(ROTWDIR)/rotw.mk2;grep ^\* $(ROTWDIR)/depends.txt |cut -f2- -d/|grep ^blasons|grep -v pgm|cut -f2 -d_|cut -f1 -d.|sort -u|xargs echo "ROTWBLASONS =" >> $(ROTWDIR)/rotw.mk2;grep ^\* $(ROTWDIR)/depends.txt |cut -f2- -d/|grep ^shadow|cut -f2 -d/|cut -f1 -d.|sort -u|xargs echo "ROTWSHADOWS ="  >> $(ROTWDIR)/rotw.mk2; sed -ne '/^# End automatic/,$$ p' < $(ROTWDIR)/rotw.mk >> $(ROTWDIR)/rotw.mk2; mv $(ROTWDIR)/rotw.mk2 $(ROTWDIR)/rotw.mk

# Warning => gv does a cd to the dir containing the file viewed
$(ROTWDIR)/bs:
	@cd $(ROTWDIR);gv -nosafedir -scale=0 -noantialias -geometry 735x669+0+20 -nosafer --arguments="-SHOMEDIR=.. -SBOOTFILE=../library/bootstrap.eps -DSCHEMATIC" chemins.eps
