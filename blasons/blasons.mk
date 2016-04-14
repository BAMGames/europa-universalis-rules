# Local defs
PNMBLASONSTARGETS=$(addprefix shield_,$(addsuffix .pnm,$(BLASONSSTEMS)))
PNGBLASONSTARGETS=$(addprefix shield_,$(addsuffix .png,$(BLASONSSTEMS)))
MAKESHIELDFILES=$(addprefix $(BLASONSDIR)/,$(PNMBLASONSTARGETS) $(PNGBLASONSTARGETS))
MAKESHIELDFILESCMD=$(GIMPIT) --third "$(BLASONSDIR)/templates/" --logfile $(LOGFILE) --script $(LIBDIR)/makeshield.scm --input "$(BLASONSDIR)/src" --output "$(BLASONSDIR)" --class "Building shields" --prefix shield_ --marker MAKESHIELDFILES --
MAKESHIELDCOMMON=$(GIMPITDEP) $(LIBDIR)/makeshield.scm $(BLASONSDIR)/templates/blason.pgm $(BLASONSDIR)/templates/modele.xcf

# Automatic section
BLASONSSTEMS=\
aceh\
aden\
afghans\
algerie\
alliance\
alsace\
angleterre\
arabie\
astrakhan\
azteque\
bade\
balkans\
baviere\
belgique\
berg\
blanc\
boheme\
bourgogne\
brandebourg\
bretagne\
brunswick\
catalogne\
chevaliers\
chine\
cologne\
corse\
cosaquesdon\
courlande\
crimee\
croises\
cyrenaique\
damas\
danemark\
eastprussia\
ecosse\
espagne\
finlande\
flandrebrabant\
france\
francec\
francep\
genes\
georgie\
grenade\
gujarat\
habsbourg\
hanovre\
hanse\
hesse\
hollande\
hongrie\
huguenots\
hyderabad\
inca\
irak\
irlande\
iroquois\
japon\
kazan\
liege\
liflandie\
ligue\
lithuanie\
lorraine\
lucca\
mamelouks\
maroc\
mayence\
mazovie\
mercenaires\
milan\
modene\
mogol\
moldavie\
montferrat\
mysore\
naples\
natives\
neutre\
norvege\
oldenburg\
oman\
oresund\
palatinat\
papaute\
parme\
perse\
pirates\
pise\
pologne\
pommeranie\
portugal\
prusse\
pskov\
rebelles\
revolutionnaires\
royalistes\
russie\
ryazan\
saint-empire\
sainte-ligue\
savoie\
saxe\
siberie\
sienne\
soudan\
steppes\
suede\
suisse\
teutoniques1\
teutoniques2\
thuringe\
tordesillas\
toscane\
transylvanie\
treves\
tripoli\
tunisie\
turquie\
ukraine\
usa\
valachie\
venise\
vijayanagar\
wurtemberg\
chineespagne\
turquievenise\
caraibes\
# End automatic


# Local targets
BLASONSVIRTUALS=depends
BLASONSFINALTARGETS=
BLASONSNOTALLTARGETS=$(PNMBLASONSTARGETS) $(PNGBLASONSTARGETS)
BLASONSTARGETS=
BLASONSDEBUGTARGETS=depends.txt
BLASONSSLOWTARGETS=$(BLASONSNOTALLTARGETS)

# Cruft
BLASONSDEBUGTARGETS+=shield_francec.pnm shield_francec.png shield_francep.pnm shield_francep.png

# Other files
$(addprefix $(BLASONSDIR)/,$(PNMBLASONSTARGETS)): $(BLASONSDIR)/%.pnm: $(MAKESHIELDCOMMON) $(BLASONSDIR)/src/%.xcf
	@$(MAKESHIELDFILESCMD) $*
$(addprefix $(BLASONSDIR)/,$(PNGBLASONSTARGETS)): $(BLASONSDIR)/%.png: $(MAKESHIELDCOMMON) $(BLASONSDIR)/src/%.xcf
	@$(MAKESHIELDFILESCMD) $*

# Virtual actions

$(BLASONSDIR)/all: $(GIMPITDEP)
	@targets=$$($(MAKE) -n -s $(MAKESHIELDFILES)|grep -- "--marker MAKESHIELDFILES"|perl -pi -e 's/ /\n/g'|grep -A 1 ^--$$|grep -v ^--$$|sort|uniq);if [ -n "$$targets" ]; then $(MAKESHIELDFILESCMD) $$targets; fi

$(BLASONSDIR)/depends:
	@$(DISP) "Building depends" "blasons"
	@sed -ne '1,/^# Automatic section/ p' < $(BLASONSDIR)/blasons.mk > $(BLASONSDIR)/depends.txt;echo "BLASONSSTEMS=\\" >> $(BLASONSDIR)/depends.txt; ls $(BLASONSDIR)/src/shield_*.xcf|cut -f2 -d_|cut -f1 -d.|sed -e 's/$$/\\/g'|LC_ALL=C sort>> $(BLASONSDIR)/depends.txt; sed -ne '/^# End automatic/,$$ p' < $(BLASONSDIR)/blasons.mk >> $(BLASONSDIR)/depends.txt; mv $(BLASONSDIR)/depends.txt $(BLASONSDIR)/blasons.mk
