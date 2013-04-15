inclusion.pdf: inclusion.dot
	dot -Tpdf $< > $@
inclusion.dot:
	echo "digraph inclusion {" > $@
	echo " rankdir=LR;" >> $@
	for j in ../*/*.ps; do k=$$(basename $$(dirname $$j));i=$$(basename $$j .ps|sed -e 's/-/_/g');grep DIR $$j|grep \!\ include|sed -e 's|HOMEDIR(/library/|library_|g' -e "s|CURRENTDIR(/|$${k}_|g" -e 's|FONTDIR(/|fonts_|g' -e 's/\.ps.*$$/;/g' -e '/.clp/ d' -e 's/\.clp.*$$/;/g' -e "s/^/$${k}_$$i -> /g"; done >> $@
	a=$$(cat $@ |perl -pi -e 's/ /\n/g'|grep '^[a-z_]*_[a-z_;]*$$'|sed -e 's/;//g' -e 's/$$/;/g'|grep -v ^cluster|sort|uniq); for i in $$(echo "$$a"|cut -f1 -d_|uniq); do echo "subgraph cluster_$${i} {"; echo "$$a"|grep "^$${i}_"; echo "}";done >> $@
	for j in ../*/*.ps; do k=$$(basename $$(dirname $$j));i=$$(basename $$j .ps|sed -e 's/-/_/g');grep BOOTFILE $$j|sed -e "s/^.*$$/$${k}_$$i [shape=box];/g"; done >> $@
	echo "}" >> $@
dist-clean: clean
clean: fast-clean
fast-clean:
	@rm -f inclusion.pdf inclusion.dot