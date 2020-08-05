# ---------------------------------------------------------------------- #
#                                                                        #
#             __  __       _        _____ _ _                            #
#            |  \/  | __ _| | _____|  ___(_) | ___                       #
#            | |\/| |/ _` | |/ / _ \ |_  | | |/ _ \                      #
#            | |  | | (_| |   <  __/  _| | | |  __/                      #
#            |_|  |_|\__,_|_|\_\___|_|   |_|_|\___|                      #
#                                                                        #
# ---------------------------------------------------------------------- #

LATEX      = latexmk

TARGETDIR  = .
TARGETS    = $(shell basename $(shell pwd)).pdf

SRCROOT    = ./sources
SRCDIRS    = $(shell find $(SRCROOT) -type d)
SOURCES    = $(foreach dir, $(SRCDIRS), $(wildcard $(dir)/*.ltx))

OBJROOT    = ./.temp
OBJDIRS    = $(subst $(SRCROOT), $(OBJROOT), $(SRCDIRS))
OBJECTS    = $(subst $(SRCROOT), $(OBJROOT), $(SOURCES:.ltx=.pdf))

IMAGEROOT  = ./images

SCRIPTROOT  = ./scripts
SCRIPTDIRS  = $(shell find $(SCRIPTROOT) -type d)
PLOTSCRIPTS = $(foreach dir, $(SCRIPTDIRS), $(wildcard $(dir)/*.plt))
PLOTIMAGES  = $(subst $(SCRIPTROOT), $(IMAGEROOT), $(PLOTSCRIPTS:.plt=.ltx))

BIBROOT    = ./bibliography

PDFROOT    = ./pdf
PDFDIRS    = $(subst $(SRCROOT), $(PDFROOT), $(SRCDIRS))
PDFILES    = $(subst $(SRCROOT), $(PDFROOT), $(SOURCES:.ltx=.pdf))


# link
$(TARGETS): $(OBJECTS) $(PDFILES)
	cp $(OBJROOT)/master.pdf $(TARGETS)

# for pdf files
$(PDFROOT)/%.pdf: $(OBJROOT)/%.pdf
	mkdir -p $(dir $@)
	cp $< $@

# for object files
$(OBJROOT)/%.pdf: $(SRCROOT)/%.ltx $(PLOTIMAGES)
	mkdir -p $(dir $@)
	(ls $(BIBROOT)/*.bib | xargs -I{} basename {}) | xargs -I{} ln -s -f -n .${BIBROOT}/{} $(OBJROOT)/{}
	$(LATEX) $< -auxdir=$(dir $@) -outdir=$(dir $@)
	#$(LATEX) $< -cd $(SRCROOT) -auxdir=../$(OBJROOT) -outdir=../$(OBJROOT)

$(IMAGEROOT)/%.ltx: $(SCRIPTROOT)/%.plt
	{ echo "set output '/dev/null'"; cat $<; echo "set term lua tikz size 12cm,12cm nopicenvironment tightboundingbox"; echo "set output '$@'"; echo "replot"; } | gnuplot

# rebuild
all: touch $(TARGETS)

touch:
	- touch $(SOURCES)

%.ltx:
	- mkdir -p $(SRCROOT)/$(@D)
	- cp .template/sub-template.ltx $(SRCROOT)/$@

article/%.bib:
	- mkdir -p $(BIBROOT)/$(*D)
	- cp .template/article-template.bib $(BIBROOT)/$*.bib
book/%.bib:
	- mkdir -p $(BIBROOT)/$(*D)
	- cp .template/book-template.bib $(BIBROOT)/$*.bib
url/%.bib:
	- mkdir -p $(BIBROOT)/$(*D)
	- cp .template/url-template.bib $(BIBROOT)/$*.bib

# clean build
clean:
	- rm $(TARGETS)
	- rm $(OBJECTS)
	- rm -r $(OBJDIRS)

# build and run
view: $(TARGETS)
	- evince $(TARGETS)

# not files
.PHONY: all clean touch view

