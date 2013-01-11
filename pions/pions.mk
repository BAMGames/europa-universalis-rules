# Local defs
PIONSCLASS=Building counters
ifdef DEPENDS
PIONSGSEXTRA = -SDEPENDS=$(PIONSDIR)/depends.txt
PIONSMAPEXTRA = +depends
PIONSCLASS=Building depends
PIONSBLASONSEXTRA = bretagne
endif
PIONSGSEXTRA += -SCURRENTDIR=$(PIONSDIR)
# Automatic section
PIONSBLASONS = aceh aden afghans algerie alliance alsace angleterre arabie astrakhan azteque bade baviere belgique berg blanc boheme bourgogne brandebourg brunswick chevaliers chine cologne corse cosaquesdon courlande crimee croises cyrenaique damas danemark ecosse espagne finlande france genes georgie grenade gujarat habsbourg hanovre hanse hesse hollande hongrie huguenots hyderabad inca irak irlande iroquois japon kazan liege liflandie ligue lithuanie lorraine lucca mamelouks maroc mayence mazovie mercenaires milan modene mogol moldavie montferrat mysore naples natives neutre norvege oldenburg oman palatinat papaute parme perse pirates pologne pommeranie portugal prusse pskov rebelles revolutionnaires royalistes russie ryazan saint-empire sainte-ligue savoie saxe siberie soudan steppes suede suisse teutoniques1 teutoniques2 thuringe toscane transylvanie treves tripoli tunisie turquie ukraine usa valachie venise vijayanagar wurtemberg
PIONSSHADOWS = america anchor2 arbre badweather canon centredecommerce colonie comptoir construction convoi coton detgalere detnaval dettransport dn-explorateur dt-explorateur epices esclaves flottedecommerce inflation inflationfaible manuart manubois manucereales manuinstruments manumetal manupeche manusel manutissus manuvin mine mission missionnaire orient peaux peche pillage sel soie soldatazteque soldatchinois soldatcosaque soldathindou soldatinca soldatindien soldatislam soldatjaponais soldatlatin soldatlatin2 soldatpolonais soldatrebelle soldatrevolution soldatrusse soldattatar soldatteuton soldatzulu sucre sunny ville0 ville1 ville2 ville3 ville4 ville5 windmill
# End automatic
PIONSBLASONS += $(PIONSBLASONSEXTRA)
PIONSNUMERIC = $(addprefix $(PIONSDIR)/,admin.txt diplomatie.txt anonymes.txt generiques.txt virtuels.txt armees.txt leaders.txt commerce.txt)
PIONSNOTPRINTED = $(addprefix $(PIONSDIR)/,moreadmin.txt)
PIONSEXTFILES=$(GSCOMMON) $(GSLIBCOMMON) $(GSCOMCOMMON) $(LIBDIR)/libpions.eps $(PIONSDIR)/images.eps $(PIONSDIR)/pays.eps $(PIONSDIR)/translation.eps $(addprefix $(BLASONSDIR)/shield_,$(addsuffix .pnm,$(PIONSBLASONS))) $(addprefix $(SHADOWDIR)/,$(addsuffix .pnm,$(PIONSSHADOWS))) $(addprefix $(SHADOWDIR)/,$(addsuffix .pgm,$(PIONSSHADOWS))) $(BLASONSDIR)/templates/blason.pgm

# Local targets
PIONSVIRTUALS=view bitmaprelease bitmapdownload
PIONSFINALTARGETS=pions.pdf planchecontact.pdf
PIONSNOTALLTARGETS=pions-ops.eps pions-ops.pdf
PIONSTARGETS=pions.eps manifest.txt
PIONSDEBUGTARGETS=pions.mk2 depends.txt targets bitmap
PIONSSLOWTARGETS=pions.eps bitmap

# Cruft
PIONSDEBUGTARGETS+=bitmap-lowres bitmap-highres

# Final files

# This method updates counters.txt when building pions-ops.pdf
# Building pions-ops.pdf is long (>30')

$(PIONSDIR)/pions.pdf $(PIONSDIR)/planchecontact.pdf $(PIONSDIR)/pions-ops.pdf: $(PIONSDIR)/%.pdf: $(PIONSCOMMON) $(PIONSDIR)/%.eps $(PIONSEXTFILES)
	@-if [ ! -d "$(PIONSDIR)/targets" ]; then mkdir $(PIONSDIR)/targets; fi
	@l=$$(wc -l $(PIONSDIR)/$*.eps|cut -f1 -d' ');l=$$((l-10));a=$$($(DISP) "multiple" "$(PIONSCLASS)" "0000/0000");$(DISP) "$(PIONSCLASS)" "$*:_init:0000/0000";$(GSEXEC) $(PIONSGSEXTRA) -sSUFFIX="/$$l" -sPREFIX="$$a[$*:" -sOutput=$@ -DPDFOUTPUT $(PIONSDIR)/$*.eps 2>> $(LOGFILE)
	@$(RMTARGETS) $(PIONSDIR)/targets

# Other files

$(PIONSDIR)/pions.eps: $(PIONSCOMMON) $(BINDIR)/extract $(PIONSNUMERIC)
	@$(DISP) "$(PIONSCLASS)" "template"
	@$(BINDIR)/extract $(PIONSNUMERIC) > $@
$(PIONSDIR)/pions-ops.eps: $(PIONSCOMMON) $(BINDIR)/extract $(PIONSNUMERIC) $(PIONSNOTPRINTED)
	@$(DISP) "$(PIONSCLASS)" "OPS template"
	@echo "%!PS" > $@
	@echo -n "BOOTFILE (r) file run" >> $@
	@echo "/counteralone true def/pageheight 100 def/pagewidth 100 def">>$@
	@$(BINDIR)/extract $(PIONSNUMERIC) $(PIONSNOTPRINTED) | tail -n +3 >> $@
$(PIONSDIR)/manifest.txt: $(PIONSDIR)/manifest.txt.bz2
	@$(DISP) "$(PIONSCLASS)" "manifest"
	@rm -f $(PIONSDIR)/manifest.txt;bunzip2 -k $(PIONSDIR)/manifest.txt.bz2; touch $@

# Virtual actions

$(PIONSDIR)/view: $(PIONSDIR)/pions.pdf
	@$(BINDIR)/acroread $^
$(PIONSDIR)/depends: $(PIONSDIR)/pions.pdf
	@$(DISP) "Building depends" "pions"
	@rm -f $(PIONSDIR)/depends.txt
	@touch -r $(PIONSDIR)/pions.pdf $(PIONSDIR)/depends.txt
	@rm -f $(PIONSDIR)/pions.pdf
	@DEPENDS=1 XID=$(XID) make -s $(PIONSDIR)/pions.pdf
	@$(DISP) "Building depends" "pions.mk"
	@touch -r $(PIONSDIR)/depends.txt $(PIONSDIR)/pions.pdf
	@sed -ne '1,/^# Automatic section/ p' < $(PIONSDIR)/pions.mk > $(PIONSDIR)/pions.mk2;grep ^\* $(PIONSDIR)/depends.txt |cut -f2- -d/|grep ^blasons|grep -v pgm|cut -f2 -d_|cut -f1 -d.|sort|xargs echo "PIONSBLASONS =" >> $(PIONSDIR)/pions.mk2;grep ^\* $(PIONSDIR)/depends.txt |cut -f2- -d/|grep ^shadow|cut -f2 -d/|cut -f1 -d.|sort|uniq|xargs echo "PIONSSHADOWS ="  >> $(PIONSDIR)/pions.mk2; sed -ne '/^# End automatic/,$$ p' < $(PIONSDIR)/pions.mk >> $(PIONSDIR)/pions.mk2; mv $(PIONSDIR)/pions.mk2 $(PIONSDIR)/pions.mk

$(PIONSDIR)/bitmaprelease:
	@if [ $$(whoami) = "jcdubacq" ]; then $(DISP) "Releasing" "bitmap counters";cd $(PIONSDIR);rsync -qavz --delete --exclude index.txt bitmap/. jcdubacq@lipnssh.univ-paris13.fr:public_html/europa/pions/.;fi

$(PIONSDIR)/bitmapdownload $(PIONSDIR)/bitmap/index.txt: $(PIONSDIR)/manifest.txt
	@$(BINDIR)/filedownloader --logfile $(LOGFILE) --category pions --manifest $(PIONSDIR)/manifest.txt --index $(PIONSDIR)/bitmap/index.txt --all --

$(PIONSDIR)/bitmap/%.png: $(PIONSDIR)/manifest.txt
	@$(BINDIR)/filedownloader --logfile $(LOGFILE) --category pions --manifest $(PIONSDIR)/manifest.txt --index $(PIONSDIR)/bitmap/index.txt -- $*.png

ifeq "$(CURRENTDIR)" "$(PIONSDIR)"
bitmap/%.png: $(PIONSDIR)/manifest.txt
	@$(BINDIR)/filedownloader --logfile $(LOGFILE) --category pions --manifest $(PIONSDIR)/manifest.txt --index $(PIONSDIR)/bitmap/index.txt -- $*.png
endif

# Template: resolution

define RES_template

PIONSVIRTUALS+=update-$(1)res

## These methods requires several unix utilities, approx. 19 Go of free space
## and much CPU power (and more than 1h).

$(PIONSDIR)/update-$(1)res: $(PIONSDIR)/pions-ops.pdf $(PIONSDIR)/manifest.txt
	@if [ ! -f "$(PIONSDIR)/counters.txt" ]; then echo "$(PIONSDIR)/counters.txt is missing. Please remove $(PIONSDIR)/pions-ops.pdf";false;fi
	@$(BINDIR)/pionstopng.sh -r "$(1)res"
endef

$(foreach res,high low,$(eval $(call RES_template,$(res))))

