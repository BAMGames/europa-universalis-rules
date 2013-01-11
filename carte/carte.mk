# Local defs
CARTECLASS=Building Europe maps
ifdef DEPENDS
CARTEGSEXTRA = -SDEPENDS=$(CARTEDIR)/depends.txt
CARTEMAPEXTRA = +depends
CARTECLASS=Building depends
endif
CARTEGSEXTRA += -SCURRENTDIR=$(CARTEDIR)
# Automatic section
CARTEBLASONS = algerie alsace angleterre arabie astrakhan bade balkans baviere berg boheme bourgogne brandebourg brunswick catalogne chevaliers cologne corse cosaquesdon courlande crimee crimee cyrenaique damas danemark ecosse espagne espagne finlande flandrebrabant france genes georgie grenade habsbourg habsbourg hanovre hanse hanse hesse hollande hongrie huguenots irak irlande kazan liege ligue lithuanie lorraine lucca mamelouks maroc maroc mayence mazovie milan modene moldavie montferrat naples naples norvege oldenburg oresund palatinat papaute parme perse pologne pologne portugal prusse pskov russie russie ryazan savoie savoie saxe sienne steppes suede suisse teutoniques1 teutoniques2 thuringe toscane treves tripoli tunisie turquie ukraine ukraine valachie venise venise wurtemberg
CARTESHADOWS = anchor anchor2 anchor4 anchor5 bateau blocus capitale1 capitale1jaune capitale2 drapeauplaine mine sel ville1 ville2
# End automatic
CARTECOLORMAPEXTFILES=$(addprefix $(BLASONSDIR)/shield_,$(addsuffix .pnm,$(CARTEBLASONS))) $(addprefix $(SHADOWDIR)/,$(addsuffix .pnm,$(CARTESHADOWS))) $(addprefix $(SHADOWDIR)/,$(addsuffix .pgm,$(CARTESHADOWS)))

# Local targets
CARTEVIRTUALS=view miniview bs update-highres update-lowres bitmaprelease bitmapdownload
CARTEFINALTARGETS=carteeuropa8.pdf europasmall.pdf
CARTENOTALLTARGETS=clipped.pdf traces.dot
CARTETARGETS=carres.eps text.eps fonddecarte.clp minifonddecarte.clp manifest.txt traces.js moretraces.js
CARTEDEBUGTARGETS=carte.mk2 depends.txt targets bitmap backup
CARTESLOWTARGETS=fonddecarte.clp minifonddecarte.clp carres.eps bitmap

# Final files

$(CARTEDIR)/moretraces.js $(CARTEDIR)/carteeuropa8.pdf: $(CARTECOMMON) $(GSCOLORMAPCOMMON) $(addprefix $(CARTEDIR)/,source.eps carres.eps fonddecarte.clp images.eps portsandmines.eps text.eps) $(CARTECOLORMAPEXTFILES)
	@$(DISP) "$(CARTECLASS)" "map$(CARTEMAPEXTRA)"
	@-if [ ! -d "$(CARTEDIR)/targets" ]; then mkdir $(CARTEDIR)/targets; fi
	@$(GSEXEC) $(CARTEGSEXTRA) -sOutput=$(CARTEDIR)/carteeuropa8.pdf -sTraces=$(CARTEDIR)/moretraces.js -DPDFOUTPUT $(CARTEDIR)/source.eps
	@$(RMTARGETS) $(CARTEDIR)/targets

$(CARTEDIR)/europasmall.pdf: $(CARTECOMMON) $(GSMAPCOMMON) $(addprefix $(CARTEDIR)/,mini.eps minifonddecarte.clp)
	@$(DISP) "$(CARTECLASS)" "minimap"
	@-if [ ! -d "$(CARTEDIR)/targets" ]; then mkdir $(CARTEDIR)/targets; fi
	@$(GSEXEC) $(CARTEGSEXTRA) -sOutput=$@ -DPDFOUTPUT $(CARTEDIR)/mini.eps
	@$(RMTARGETS) $(CARTEDIR)/targets

# Other files

$(CARTEDIR)/traces.js: $(CARTECOMMON) $(GSCHEMINCOMMON) $(CARTEDIR)/chemins.eps
	@$(DISP) "$(CARTECLASS)" "profile"
	@$(GSEXEC) $(CARTEGSEXTRA) -sOutput=$@ -sSUFFIX=carte -DTRACES $(CARTEDIR)/chemins.eps
	@

$(CARTEDIR)/traces.dot: $(CARTECOMMON) $(GSCHEMINCOMMON) $(CARTEDIR)/chemins.eps
	@$(DISP) "$(CARTECLASS)" "graph"
	@$(GSEXEC) $(CARTEGSEXTRA) -sOutput=$@ -sSUFFIX=carte -DTRACES -DGRAPH $(CARTEDIR)/chemins.eps

$(CARTEDIR)/carres.eps $(CARTEDIR)/fonddecarte.clp: $(CARTECOMMON) $(GSCHEMINCOMMON) $(CARTEDIR)/chemins.eps
	@$(DISP) "$(CARTECLASS)" "map background"
	@-$(GSEXEC) $(CARTEGSEXTRA) -DPDFOUTPUT $(CARTEDIR)/chemins.eps > $(CARTEDIR)/fonddecarte.clp
	@if grep ^Error: $(CARTEDIR)/fonddecarte.clp; then grep -B 3 -A 8 ^Error: < $(CARTEDIR)/fonddecarte.clp; rm $(CARTEDIR)/fonddecarte.clp; false;fi

$(CARTEDIR)/minifonddecarte.clp: $(CARTECOMMON) $(GSCHEMINCOMMON) $(CARTEDIR)/chemins.eps
	@$(DISP) "$(CARTECLASS)" "minimap background"
	@-$(GSEXEC) $(CARTEGSEXTRA) -DPLAIN $(CARTEDIR)/chemins.eps > $(CARTEDIR)/minifonddecarte.clp
	@if grep ^Error: $(CARTEDIR)/minifonddecarte.clp; then grep -B 3 -A 8 ^Error: < $(CARTEDIR)/minifonddecarte.clp; rm $(CARTEDIR)/minifonddecarte.clp; false;fi

$(CARTEDIR)/text.eps: $(CARTECOMMON) $(BINDIR)/analyse.pl $(CARTEDIR)/noms.utf
	@$(DISP) "$(CARTECLASS)" "text"
	@$(BINDIR)/analyse.pl $(CARTEDIR)/noms.utf > $@


$(CARTEDIR)/clipped.pdf: $(CARTECOMMON) $(GSCOLORMAPCOMMON) $(addprefix $(CARTEDIR)/,source.eps carres.eps fonddecarte.clp images.eps portsandmines.eps text.eps) $(CARTECOLORMAPEXTFILES)
	@$(DISP) "$(CARTECLASS)" "map(clippable)"
	@-if [ ! -d "$(CARTEDIR)/targets" ]; then mkdir $(CARTEDIR)/targets; fi
	@$(GSEXEC) $(CARTEGSEXTRA) -DCLIP -sOutput=$@ -DPDFOUTPUT $(CARTEDIR)/source.eps
	@$(RMTARGETS) $(CARTEDIR)/targets

$(CARTEDIR)/manifest.txt: $(CARTEDIR)/manifest.txt.bz2
	@$(DISP) "$(CARTECLASS)" "manifest"
	@rm -f $(CARTEDIR)/manifest.txt;bunzip2 -k $(CARTEDIR)/manifest.txt.bz2; touch $@


# Virtual actions

$(CARTEDIR)/view: $(CARTEDIR)/carteeuropa8.pdf
	@$(BINDIR)/acroread $^
$(CARTEDIR)/miniview: $(CARTEDIR)/europasmall.pdf
	@$(BINDIR)/acroread $^

$(CARTEDIR)/depends: $(CARTEDIR)/carteeuropa8.pdf
	@$(DISP) "Building depends" "carte"
	@rm -f $(CARTEDIR)/depends.txt
	@touch -r $(CARTEDIR)/carteeuropa8.pdf $(CARTEDIR)/depends.txt
	@rm -f $(CARTEDIR)/carteeuropa8.pdf
	@DEPENDS=1 XID=$(XID) make -s $(CARTEDIR)/carteeuropa8.pdf
	@$(DISP) "Building depends" "carte.mk"
	@touch -r $(CARTEDIR)/depends.txt $(CARTEDIR)/carteeuropa8.pdf
	@sed -ne '1,/^# Automatic section/ p' < $(CARTEDIR)/carte.mk > $(CARTEDIR)/carte.mk2;grep ^\* $(CARTEDIR)/depends.txt |cut -f2- -d/|grep ^blasons|grep -v pgm|cut -f2 -d_|cut -f1 -d.|sort|xargs echo "CARTEBLASONS =" >> $(CARTEDIR)/carte.mk2;grep ^\* $(CARTEDIR)/depends.txt |cut -f2- -d/|grep ^shadow|cut -f2 -d/|cut -f1 -d.|sort|uniq|xargs echo "CARTESHADOWS ="  >> $(CARTEDIR)/carte.mk2; sed -ne '/^# End automatic/,$$ p' < $(CARTEDIR)/carte.mk >> $(CARTEDIR)/carte.mk2; mv $(CARTEDIR)/carte.mk2 $(CARTEDIR)/carte.mk

# Warning => gv does a cd to the dir containing the file viewed
$(CARTEDIR)/bs:
	@cd $(CARTEDIR);gv -nosafedir -scale=0 -noantialias -geometry 735x669+0+20 -nosafer --arguments="-SHOMEDIR=.. -SBOOTFILE=../library/bootstrap.eps -DSCHEMATIC" chemins.eps

$(CARTEDIR)/bitmaprelease:
	@if [ $$(whoami) = "jcdubacq" ]; then $(DISP) "Releasing" "bitmap map";cd $(CARTEDIR);rsync -qavz --delete --exclude index.txt bitmap/. jcdubacq@lipnssh.univ-paris13.fr:public_html/europa/carte/.;fi

$(CARTEDIR)/bitmapdownload $(CARTEDIR)/bitmap/index.txt: $(CARTEDIR)/manifest.txt
	@$(BINDIR)/filedownloader --logfile $(LOGFILE) --category carte --manifest $(CARTEDIR)/manifest.txt --index $(CARTEDIR)/bitmap/index.txt --all --

$(CARTEDIR)/bitmap/%.png: $(CARTEDIR)/manifest.txt
	@$(BINDIR)/filedownloader --logfile $(LOGFILE) --category carte --manifest $(CARTEDIR)/manifest.txt --index $(CARTEDIR)/bitmap/index.txt -- $*.png

ifeq "$(CURRENTDIR)" "$(CARTEDIR)"
bitmap/%.png: $(CARTEDIR)/manifest.txt
	@$(BINDIR)/filedownloader --logfile $(LOGFILE) --category carte --manifest $(CARTEDIR)/manifest.txt --index $(CARTEDIR)/bitmap/index.txt -- $*.png
endif

define CRES_template

CARTEVIRTUALS+=update-$(1)res

$(CARTEDIR)/update-$(1)res: $(CARTEDIR)/clipped.pdf $(ROTWDIR)/clipped.pdf $(CARTEDIR)/manifest.txt
	@$(BINDIR)/cartetopng.sh -r "$(1)res" $(CARTEDIR)/clipped.pdf $(ROTWDIR)/clipped.pdf

endef

$(foreach res,high low pix,$(eval $(call CRES_template,$(res))))

