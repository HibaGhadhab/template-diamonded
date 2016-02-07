TPLDIR=~/dev/src/github.com/humboldtux/asciidoctor-diamonded
DIRDEST=builds
SRCFILES=article.adoc

HTMLFILES=$(SRCFILES:.adoc=.html)
FODTFILES=$(SRCFILES:.adoc=.fodt)
ODTFILES=$(FODTFILES:.fodt=.odt)

.PHONY : all clean html guard

all : clean $(FODTFILES) $(ODTFILES)

guard: clean html
	xdg-open $(DIRDEST)/$(HTMLFILES)
	bundle exec guard

clean :
	-rm $(DIRDEST)/*odt $(DIRDEST)/*html

html: $(HTMLFILES)

%.html: %.adoc
	bundle exec asciidoctor --destination-dir $(DIRDEST) --attribute lang=fr --trace -T $(TPLDIR)/slim $<

%.fodt: %.adoc
	bundle exec asciidoctor --destination-dir $(DIRDEST) --trace -T $(TPLDIR)/slim -b fodt $<
	xmllint --format $(DIRDEST)/$@ > $(DIRDEST)/$@.tmp
	mv $(DIRDEST)/$@.tmp $(DIRDEST)/$@

%.odt : %.fodt
	soffice --headless --invisible --convert-to odt --outdir $(DIRDEST) $(DIRDEST)/$<
