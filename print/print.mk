# Local defs
MAJORS=POR SUE RUS ANG FRA HIS TUR VEN HOL HAB POL PRU
MAJORSSTEM=$(addprefix sheets-,$(MAJORS))
ALTMAJORSSTEM=$(addprefix ALT-sheets-,$(MAJORS))
PRINTTEXSTEMS=booklet booklet2 management global $(MAJORSSTEM) $(ALTMAJORSSTEM)
TEXFILES=$(addsuffix .tex,$(MAJORSSTEM) $(ALTMAJORSSTEM))
MAJORPDFFILES=$(addsuffix .tex,$(MAJORSSTEM) $(ALTMAJORSSTEM))

# Local targets
PRINTVIRTUALS=
PRINTFINALTARGETS=$(addsuffix .pdf, $(PRINTTEXSTEMS))
PRINTNOTALLTARGETS=
PRINTTARGETS=global.tex print.zip
PRINTDEBUGTARGETS=$(addsuffix .log,$(PRINTTEXSTEMS)) $(addsuffix .aux,$(PRINTTEXSTEMS)) missfont.log targets $(TEXFILES) 
PRINTSLOWTARGETS=$(PRINTNOTALLTARGETS)

# Dependencies
$(PRINTDIR)/booklet2.pdf $(PRINTDIR)/booklet.pdf $(PRINTDIR)/global.pdf $(PRINTDIR)/global.tex: $(RULESDIR)/engAlpha.pdf
$(PRINTDIR)/global.pdf: $(RECORDSDIR)/exoticresources.pdf $(RECORDSDIR)/tradefleets.pdf $(RULESDIR)/euMinors.pdf $(RULESDIR)/euObjectives.pdf
$(PRINTDIR)/management.pdf: $(addprefix $(RECORDSDIR)/,accounting-rt.pdf accounting-income.pdf monarch.pdf)
$(addprefix $(PRINTDIR)/,$(MAJORPDFFILES)): $(RULESDIR)/euTables.pdf $(RECORDSDIR)/colonies.pdf
$(PRINTDIR)/sheets-HIS.pdf $(PRINTDIR)/ALT-sheets-HIS.pdf: $(RECORDSDIR)/spanishcolonies.pdf
$(PRINTDIR)/print.zip: $(addprefix $(PRINTDIR)/,$(PRINTFINALTARGETS))
	@$(DISP) "Archiving printing sheets" "zip"
	@cd $(PRINTDIR);rm -f print.zip;zip -qr print.zip $(PRINTFINALTARGETS)

# Final files
$(PRINTDIR)/%.pdf: $(PRINTCOMMON) $(HOMEDIR)/.stamp-tex $(PRINTDIR)/%.tex
	@$(DISP) "Building printing sheets" "$*"
	@pwdorig=$$(pwd);cd $(PRINTDIR);pdflatex -halt-on-error $* >> $${pwdorig}/$(LOGFILE) 2>&1 && rm -f $*.aux $*.log || echo "Something went wrong"

$(addprefix $(PRINTDIR)/,$(TEXFILES)): %.tex: $(PRINTDIR)/country 
	@$(PRINTDIR)/country $*
$(PRINTDIR)/global.tex: $(PRINTDIR)/global
	@$(PRINTDIR)/global
