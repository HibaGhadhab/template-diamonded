TPLDIR=~/dev/src/github.com/humboldtux/asciidoctor-diamonded
DIRDEST=builds
SRCFILE=article.adoc

HTMLFILE=$(SRCFILE:.adoc=.html)
FODTFILE=$(SRCFILE:.adoc=.fodt)
ODTFILE=$(FODTFILE:.fodt=.odt)
IMAGES=$(shell ls *jpg *png)

.PHONY: all clean default guard prebuild tgz

default: fodt

all: clean odt ebooks

tgz: clean prebuild odt
	tar czf $(DIRDEST)/article.tgz -C $(DIRDEST) $(ODTFILE) $(IMAGES)

prebuild:
	-cp -a $(IMAGES) $(DIRDEST)

guard: clean html
	xdg-open $(DIRDEST)/$(HTMLFILE)
	bundle exec guard

clean:
	-rm $(DIRDEST)/*

pdf:
	bundle exec asciidoctor-pdf -D $(DIRDEST) article.adoc

epub3:
	bundle exec asciidoctor-epub3 -D $(DIRDEST) article.adoc

epub3-kf8:
	bundle exec asciidoctor-epub3 -a ebook-format=kf8 -D $(DIRDEST) article.adoc

ebooks: epub3 epub3-kf8 pdf

html: prebuild
	bundle exec asciidoctor -D $(DIRDEST) --attribute lang=fr --trace -T $(TPLDIR)/slim $(SRCFILE)

fodt:
	bundle exec asciidoctor -D $(DIRDEST) --trace -T $(TPLDIR)/slim -b fodt $(SRCFILE)
	xmllint --format $(DIRDEST)/$(FODTFILE) > $(DIRDEST)/$(FODTFILE).tmp
	mv $(DIRDEST)/$(FODTFILE).tmp $(DIRDEST)/$(FODTFILE)

odt: fodt
	soffice --headless --invisible --convert-to odt --outdir $(DIRDEST) $(DIRDEST)/$(FODTFILE)
	-rm -f $(DIRDEST)/$(FODTFILE)
