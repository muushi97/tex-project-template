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
SRCROOT    = .
# all directoryes that have some .cpp files
SRCDIRS    = $(shell find $(SRCROOT) -type d)
# all source files
SOURCES    = $(foreach dir, $(SRCDIRS), $(wildcard $(dir)/*.tex))


# link
$(TARGETS): $(SOURCES)
	$(LATEX) master.tex
	- mv master.pdf $(TARGETS)

# rebuild
all: clean $(TARGETS)

# clean build
clean:
	$(LATEX) -C master.tex
	- rm $(TARGETS)

# build and run
view: $(TARGETS)
	- evince $(TARGETS)

# not files
.PHONY: all clean

