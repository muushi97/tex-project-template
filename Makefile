# ---------------------------------------------------------------------- #
#                                                                        #
#             __  __       _        _____ _ _                            #
#            |  \/  | __ _| | _____|  ___(_) | ___                       #
#            | |\/| |/ _` | |/ / _ \ |_  | | |/ _ \                      #
#            | |  | | (_| |   <  __/  _| | | |  __/                      #
#            |_|  |_|\__,_|_|\_\___|_|   |_|_|\___|                      #
#                                                                        #
# ---------------------------------------------------------------------- #

# compiler
LATEX      = latexmk
# output
TARGETS    = $(shell basename $(shell pwd)).pdf
# output directory
TARGETDIR  = .
# source directory
SRCROOT    = ./sources
# all directoryes that have some .cpp files
SRCDIRS    = $(shell find $(SRCROOT) -type d)
# all source files
SOURCES    = $(foreach dir, $(SRCDIRS), $(wildcard $(dir)/*.ltx))
# object directory
OBJROOT    = ./.temp
# all directoryes that have some object files
OBJDIRS    = $(subst $(SRCROOT), $(OBJROOT), $(SRCDIRS))
# all object files
OBJECTS    = $(subst $(SRCROOT), $(OBJROOT), $(SOURCES:.ltx=.pdf))
# bibliography root
BIBROOT    = ./bibliography
# pdf directory
PDFROOT    = ./pdf
# all pdf directories
PDFDIRS    = $(subst $(SRCROOT), $(PDFROOT), $(SRCDIRS))
# all pdf files
PDFILES    = $(subst $(SRCROOT), $(PDFROOT), $(SOURCES:.ltx=.pdf))


# link
$(TARGETS): $(OBJECTS) $(PDFILES)
	cp $(OBJROOT)/master.pdf $(TARGETS)

# for pdf files
$(PDFROOT)/%.pdf: $(OBJROOT)/%.pdf
	mkdir -p $(dir $@)
	cp $< $@

# for object files
$(OBJROOT)/%.pdf: $(SRCROOT)/%.ltx
	mkdir -p $(dir $@)
	$(LATEX) $< -auxdir=$(dir $@) -outdir=$(dir $@)
	#$(LATEX) $< -cd $(SRCROOT) -auxdir=../$(OBJROOT) -outdir=../$(OBJROOT)

# rebuild
all: touch $(TARGETS)

touch:
	- touch $(SOURCES)

%.ltx:
	#- touch $(SRCROOT)/$@
	- cp .template/sub-template.ltx $(SRCROOT)/$@

%.bib:
	- mkdir -p $(BIBROOT)
	- cp .template/bib-template.bib $(BIBROOT)/$@

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

