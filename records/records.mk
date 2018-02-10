# Local defs
RECORDSCOUNTRY = ANG DAN FRA HIS POL POR RUS TUR VEN
RECORDSCOUNTRYINCSTEM=$(addprefix accounting-income-,$(RECORDSCOUNTRY))
RECORDSCOUNTRYRTSTEM=$(addprefix accounting-rt-,$(RECORDSCOUNTRY))

RECORDSCOUNTRYMONSTEM=$(addprefix monarch-,$(RECORDSCOUNTRY))

RECORDSGSEXTRA = -SCURRENTDIR=$(RECORDSDIR)

RECORDSCOLSTEMS=spanishcolonies colonies colonies-POR monarch monarch-start $(RECORDSCOUNTRYMONSTEM)
RECORDSACCSTEMS=accounting-rt accounting-income accounting-rt-start accounting-income-start $(RECORDSCOUNTRYINCSTEM) $(RECORDSCOUNTRYRTSTEM)
RECORDSTEXSTEMS=exoticresources tradefleets

COLRECORDSFILES=$(addprefix $(RECORDSDIR)/,$(addsuffix .pdf,$(RECORDSCOLSTEMS)))
ACCRECORDSFILES=$(addprefix $(RECORDSDIR)/,$(addsuffix .pdf,$(RECORDSACCSTEMS)))

$(COLRECORDSFILES): $(LIBDIR)/libcolonial.eps
$(ACCRECORDSFILES): $(LIBDIR)/librecord.eps

# Local targets
RECORDSVIRTUALS=
RECORDSFINALTARGETS=$(addsuffix .pdf,$(RECORDSCOLSTEMS) $(RECORDSACCSTEMS) $(RECORDSTEXSTEMS))
RECORDSNOTALLTARGETS=
RECORDSTARGETS=
RECORDSDEBUGTARGETS=$(addsuffix .log,$(RECORDSTEXSTEMS)) $(addsuffix .aux,$(RECORDSTEXSTEMS)) missfont.log targets
RECORDSSLOWTARGETS=$(RECORDSNOTALLTARGETS)

# Final files
$(RECORDSDIR)/%.pdf: $(RECORDSCOMMON) $(HOMEDIR)/.stamp-tex $(RECORDSDIR)/%.tex
	@$(DISP) "Building record sheets" "$*"
	@pwdorig=$$(pwd);cd $(RECORDSDIR);pdflatex $* >> $${pwdorig}/$(LOGFILE) 2>&1 && rm -f $*.aux $*.log || echo "Something went wrong"
$(RECORDSDIR)/%.pdf: $(RECORDSCOMMON) $(RECORDSDIR)/%.eps
	@-if [ ! -d "$(RECORDSDIR)/targets" ]; then mkdir $(RECORDSDIR)/targets; fi
	@$(DISP) "Building record sheets" "$*"
	@$(GSEXEC) $(RECORDSGSEXTRA) -sOutput=$@ $(RECORDSDIR)/$*.eps 2>> $(LOGFILE)
	@$(RMTARGETS) $(RECORDSDIR)/targets
