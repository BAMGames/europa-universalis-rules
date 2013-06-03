HOMEDIR ?= .
TARGETS=all\
clean\
distclean\
help\
how\
ignore\
sweep\
what\
why\
Makefile\
finals\
maps\
pions\
reboot
$(TARGETS): %:
	$(HOMEDIR)/bin/plan "$@"
%:
	$(HOMEDIR)/bin/plan "$@"
.PHONY: $(TARGETS)
