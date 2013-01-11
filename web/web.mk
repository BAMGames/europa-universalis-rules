# Local defs
FTPGENFILES = index.html changelog.txt players-changelog.txt contours.js counters.js
FTPOTHERFILES=
FTPSTATICFILES=js css map.html img
# Automatic section
$(WEBDIR)/Combat-rapide-fr.txt: $(HOMEDIR)/doc/Combat-rapide-fr.txt
FTPOTHERFILES+=Combat-rapide-fr.txt
$(WEBDIR)/Fast-battle-en.txt: $(HOMEDIR)/doc/Fast-battle-en.txt
FTPOTHERFILES+=Fast-battle-en.txt
$(WEBDIR)/accounting-economic.pdf: $(RECORDSDIR)/accounting-economic.pdf
FTPOTHERFILES+=accounting-economic.pdf
$(WEBDIR)/booklet.pdf: $(PRINTDIR)/booklet.pdf
FTPOTHERFILES+=booklet.pdf
$(WEBDIR)/booklet2.pdf: $(PRINTDIR)/booklet2.pdf
FTPOTHERFILES+=booklet2.pdf
$(WEBDIR)/carteeuropa8.pdf: $(CARTEDIR)/carteeuropa8.pdf
FTPOTHERFILES+=carteeuropa8.pdf
$(WEBDIR)/carterotw8.pdf: $(ROTWDIR)/carterotw8.pdf
FTPOTHERFILES+=carterotw8.pdf
$(WEBDIR)/colonies.pdf: $(RECORDSDIR)/colonies.pdf
FTPOTHERFILES+=colonies.pdf
$(WEBDIR)/counters.txt: $(PIONSDIR)/counters.txt
FTPOTHERFILES+=counters.txt
$(WEBDIR)/engAlpha.pdf: $(RULESDIR)/engAlpha.pdf
FTPOTHERFILES+=engAlpha.pdf
$(WEBDIR)/euMinors.pdf: $(RULESDIR)/euMinors.pdf
FTPOTHERFILES+=euMinors.pdf
$(WEBDIR)/euObjectives.pdf: $(RULESDIR)/euObjectives.pdf
FTPOTHERFILES+=euObjectives.pdf
$(WEBDIR)/euTables.pdf: $(RULESDIR)/euTables.pdf
FTPOTHERFILES+=euTables.pdf
$(WEBDIR)/europasmall.pdf: $(CARTEDIR)/europasmall.pdf
FTPOTHERFILES+=europasmall.pdf
$(WEBDIR)/exoticresources.pdf: $(RECORDSDIR)/exoticresources.pdf
FTPOTHERFILES+=exoticresources.pdf
$(WEBDIR)/monarch.pdf: $(RECORDSDIR)/monarch.pdf
FTPOTHERFILES+=monarch.pdf
$(WEBDIR)/moreadmin.txt: $(PIONSDIR)/moreadmin.txt
FTPOTHERFILES+=moreadmin.txt
$(WEBDIR)/oldchangelog.txt: $(HOMEDIR)/doc/oldchangelog.txt
FTPOTHERFILES+=oldchangelog.txt
$(WEBDIR)/pions.pdf: $(PIONSDIR)/pions.pdf
FTPOTHERFILES+=pions.pdf
$(WEBDIR)/print.zip: $(PRINTDIR)/print.zip
FTPOTHERFILES+=print.zip
$(WEBDIR)/rotwsmall.pdf: $(ROTWDIR)/rotwsmall.pdf
FTPOTHERFILES+=rotwsmall.pdf
$(WEBDIR)/spanishcolonies.pdf: $(RECORDSDIR)/spanishcolonies.pdf
FTPOTHERFILES+=spanishcolonies.pdf
$(WEBDIR)/tradefleets.pdf: $(RECORDSDIR)/tradefleets.pdf
FTPOTHERFILES+=tradefleets.pdf
# Not found:  changelog.txt map.html players-changelog.txt
# End automatic


FTPFILES = $(FTPGENFILES) $(FTPOTHERFILES)

# Local targets
WEBVIRTUALS=depends oldftpaction ftpaction
WEBFINALTARGETS=
WEBNOTALLTARGETS=
WEBTARGETS=script.ftp $(FTPFILES) $(XFTPMENUFILES)
WEBDEBUGTARGETS=nosync.ftp depends.txt
WEBSLOWTARGETS=$(WEBNOTALLTARGETS)

# Final files
$(WEBDIR)/ftpaction: $(addprefix $(WEBDIR)/,$(FTPFILES) $(FTPSTATICFILES))
	@$(DISP) "FTP transfer" "rsync"
	@branch=$$($(BINDIR)/displaybranch);touch $(WEBDIR)/nosync.ftp; echo $(filter-out $(addprefix $(WEBDIR)/,$(FTPFILES)), $(wildcard $(WEBDIR)/*))|fmt -w 1 > $(WEBDIR)/nosync.ftp; rsync --delete-after -az --exclude-from=$(WEBDIR)/nosync.ftp $(WEBDIR)/. bamgames@ftp.bamgames.org:www/old/Europa/EU8/$${branch}/.; cp $(WEBDIR)/nosync.ftp /tmp;rm -f $(WEBDIR)/nosync.ftp
	@$(DISP) "FTP transfer" "done"

$(WEBDIR)/nosync.ftp: $(addprefix $(WEBDIR)/,$(FTPFILES))

$(WEBDIR)/oldftpaction: $(WEBDIR)/script.ftp $(WEBDIR)/changelog.txt $(WEBDIR)/players-changelog.txt $(WEBDIR)/index.html $(HOMEDIR)/.stamp-lftp
	@$(DISP) "FTP transfer" "ftp"
	@lftp -f $(WEBDIR)/script.ftp

$(addprefix $(WEBDIR)/,$(FTPOTHERFILES)):
	@$(DISP) "FTP transfer" "$(notdir $@)"
	@cp $^ $@

$(WEBDIR)/changelog.txt: $(BINDIR)/changelog $(HOMEDIR)/doc/changelog.db
	@$(DISP) "FTP transfer" "changelog"
	@$(BINDIR)/changelog --text $(HOMEDIR)/doc/changelog.db > $@

$(WEBDIR)/players-changelog.txt: $(BINDIR)/changelog $(HOMEDIR)/doc/changelog.db
	@$(DISP) "FTP transfer" "players-changelog"
	@$(BINDIR)/changelog --text --category _rules_events_maps_text_ $(HOMEDIR)/doc/changelog.db > $@

$(WEBDIR)/index.html:
	@NAME=$$(whoami);case "$$NAME" in jcdubacq) FULLNAME="Jean-Christophe Dubacq";; jym|*moyen) FULLNAME="Jean-Yves Moyen"; NAME=moyen;; pborgnat) FULLNAME="Pierre Borgnat";;esac;cat $(HOMEDIR)/doc/index.html|sed -e "s/XXXX/Updated for release $$($(BINDIR)/displayrelease) on $$(date -u '+%F %T %Z') by $$FULLNAME./g;s/YYYY/$$($(BINDIR)/displaybranch 'Europa Universalis 8' 'Europa Universalis 8 (%s branch)')/g" > $@
.PHONY: $(WEBDIR)/index.html

$(WEBDIR)/contours.js: $(CARTEDIR)/traces.js $(CARTEDIR)/moretraces.js $(ROTWDIR)/moretraces.js
	@$(DISP) "FTP transfer" "contours"
	@cat $^ > $@; echo 'var contourshooks; if (contourshooks != undefined) {for (var contourshook in contourshooks) {(contourshooks[contourhook])()}}'>> $@

$(WEBDIR)/counters.js: $(PIONSDIR)/counters.txt $(BINDIR)/countershierarchy
	@$(DISP) "FTP transfer" "counters"
	@$(BINDIR)/countershierarchy $@ $(HOMEDIR)/doc/serve/counters.php $(PIONSDIR)/counters.txt

$(WEBDIR)/script.ftp: $(BINDIR)/ftpscript $(WEBDIR)/web.mk $(HOMEDIR)/conf.mk
	@$(DISP) "FTP transfer" "ftp script"
	@$(BINDIR)/ftpscript $(addprefix $(WEBDIR)/, $(FTPFILES)) > $@

$(WEBDIR)/depends: $(WEBDIR)/index.html
	@$(DISP) "Building depends" "web"
	@sed -ne '1,/^# Automatic section/ p' < $(WEBDIR)/web.mk > $(WEBDIR)/depends.txt;x="";for a in $$(grep 'a href' $(WEBDIR)/index.html|fmt -w 1|grep href|cut -f2 -d\"|grep -v /|sort); do b=""; for i in '(HOMEDIR)/doc:doc' '(ROTWDIR):rotw' "(CARTEDIR):carte" "(RULESDIR):rules" "(RECORDSDIR):records" '(PIONSDIR):pions' '(PRINTDIR):print' ; do c=$${i#*:}; if [ -z "$$b" ]&&[ -f "$(WEBDIR)/../$$c/$$a" ]; then b=$${i%:*}; fi; done ; if [ -n "$$b" ]; then echo "\$$(WEBDIR)/$$a: \$$$$b/$$a">> $(WEBDIR)/depends.txt;echo "FTPOTHERFILES+=$$a">> $(WEBDIR)/depends.txt;else x="$$x $$a";fi; done; echo "# Not found: $$x">> $(WEBDIR)/depends.txt ;sed -ne '/^# End automatic/,$$ p' < $(WEBDIR)/web.mk >> $(WEBDIR)/depends.txt; mv $(WEBDIR)/depends.txt $(WEBDIR)/web.mk
