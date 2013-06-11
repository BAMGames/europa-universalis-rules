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
bitmap_pions\
finals\
maps\
pions\
reboot
$(TARGETS): %:
	$(HOMEDIR)/bin/plan "$@"
%:
	$(HOMEDIR)/bin/plan "$@"
.PHONY: $(TARGETS)
