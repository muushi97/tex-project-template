# ---------------------------------------------------------------------- #
#                                                                        #
#             __  __       _        _____ _ _                            #
#            |  \/  | __ _| | _____|  ___(_) | ___                       #
#            | |\/| |/ _` | |/ / _ \ |_  | | |/ _ \                      #
#            | |  | | (_| |   <  __/  _| | | |  __/                      #
#            |_|  |_|\__,_|_|\_\___|_|   |_|_|\___|                      #
#                                                                        #
# ---------------------------------------------------------------------- #

# コマンド類
LATEX           := uplatex -synctex=1 -halt-on-error -interaction=batchmode -file-line-error
BIBTEX          := pbibtex -kanji=utf8
BIBER           := biber --bblencoding=utf8 -u -U --output_safechars;
DVIPDF          := dvipdfmx
MAKEINDEX       := mendex

# ターゲットのディレクトリ
TARGETROOT      := .
TARGETS         :=

# TeX ファイルのディレクトリ
SRCROOT         := ./sources
SRCDIRS         := $(shell find $(SRCROOT) -type d)
TEXFILES        := $(foreach dir, $(SRCDIRS), $(wildcard $(dir)/*.tex))
LTXFILES        := $(foreach dir, $(SRCDIRS), $(wildcard $(dir)/*.ltx))

# 一時ファイルのディレクトリ
OBJROOT         := .temp
OBJECTS         := $(subst $(SRCROOT),$(OBJROOT),$(TEXFILES:.tex=.aux)) $(subst $(SRCROOT),$(OBJROOT),$(LTXFILES:.ltx=.aux))

# 参考文献のディレクトリ
BIBLIOGRAPHY    := ./bibliography
OTHERDIRS       := $(BIBLIOGRAPHY) ./images ./preambles

# 初回ビルドのフラグ
FLAG            := $(OBJROOT)/.already
# 最大繰り返し回数
MAXREPEAT       := 10

# PDF ビューア
VIEWER          := evince

# 出力関係ファイル
OUTPUT_PDF      := hoge.mk

# 自動依存ファイル生成で依存先から除外する拡張子
SOURCE_SUFF     := aux bbl out ind

# 除外拡張子が付く行を削除するコマンド生成
EXCLUDE_SUFF    := grep -v$(foreach s,$(SOURCE_SUFF), -e \".$(s)\")
# 依存関係生成関数
define mkdepends
grep -e "^INPUT" "$1" | $(EXCLUDE_SUFF) | sort | uniq | cut -d ' ' -f 2 | grep -v "^/" | awk '{ print $$0, "1"; print $$0, "2"; }' | sort -k 2n | tr '\n' ' ' | sed -e "s%$2 \+1%%g" | sed -e "s%^%$2: %" | sed -e "s/\([^ ]\+\)\( \+\)1/\1 /g; s/\([^ ]\+\)\( \+\)2/\n\1:/g;" | sed -e "s/  \+/ /g; s/ \+$$//g" | sed -e "s/\.ltx/\.aux/g"
endef

# not files
.PHONY: all rebuild clean view

# デフォルト
all:

# どの pdf を出力 pdf にするのか
define template
TARGETS         += $$(TARGETROOT)/$1
$$(TARGETROOT)/$1: $$(OBJROOT)/$2
	@mkdir -p $$(@D)
	cp $$< $$@
	@ln -f -s $$(subst .pdf,.synctex.gz,$$<) $$(subst .pdf,.synctex.gz,$$@)
endef
define template_samename
TARGETS         += $$(TARGETROOT)/$1
$$(TARGETROOT)/$1: $$(OBJROOT)/$1
	@mkdir -p $$(@D)
	cp $$< $$@
	@ln -f -s $$(subst .pdf,.synctex.gz,$$<) $$(subst .pdf,.synctex.gz,$$@)
endef

# 出力される PDF のリスト
$(eval $(call template_samename,master.pdf))


# 全てのターゲットに依存する擬似ターゲット
all: $(TARGETS)

# 一時ディレクトリとターゲットを全て削除
clean:
	-rm -r $(OBJROOT)
	-rm $(TARGETS)

rebuild: clean $(TARGETS)

# ターゲットのリストの先頭を表示
view: $(TARGETS)
	$(VIEWER) $(firstword $(TARGETS))

# dvi ファイルから pdf ファイルを生成する
$(OBJECTS:.aux=.pdf): %.pdf: %.dvi
	$(DVIPDF) -o $@ $<

# aux ファイルから dvi ファイルを生成する
$(OBJECTS:.aux=.dvi): %.dvi: %.aux# %.d

# aux ファイルと bib ファイルから bbl ファイルを生成する
$(OBJECTS:.aux=.bbl): %.bbl: %.aux $(BIBLIOGRAPHY)/*.bib
	cd $(OBJROOT) && $(BIBTEX) $(subst $(OBJROOT)/,,$(subst .bbl,,$@))

# idx ファイルから ind ファイルを生成する
$(OBJECTS:.aux=.ind): %.ind: %idx
	cd $(OBJROOT) && $(MENDEX) $(subst $(OBJROOT)/,,$(subst .ind,,$@))

# aux ファイルから idx ファイルを生成する
$(OBJECTS:.aux=.idx): %.idx: %.aux

# ltx ファイルから aux ファイルを生成する
$(OBJECTS): $(OBJROOT)/%.aux: $(SRCROOT)/%.ltx $(FLAG)
	@if [ $(MAKELEVEL) -lt $(MAXREPEAT) ]; then \
		mkdir -p $(@D); \
		$(LATEX) -output-directory=$(@D) -recorder $<; \
		$(call mkdepends,$(subst .aux,.fls,$@),$(subst .aux,.aux,$@)) > $(subst .aux,.d,$@); \
		if [ ! -f $@.prv ]; then \
			$(MAKE) $(subst .aux,.bbl,$@); \
			if [ -f $(subst .aux,.ind,$@) ]; then \
				$(MAKE) $(subst .aux,.ind,$@); \
			fi; \
			cp $@ $@.prv; \
			$(MAKE) $(subst .aux,.bbl,$@); \
			$(MAKE) -W $< $@; \
		elif [ $$(diff $@ $@.prv | wc -l) -ne 0 ]; then \
			cp $@ $@.prv; \
			$(MAKE) -W $< $@; \
		fi; \
	fi

# 一時ディレクトリ内に必要なリンクを貼る
define link
	if [ ! -e $(OBJROOT)/$1 ]; then \
		ln -s ../$1 $(OBJROOT); \
	fi;
endef
$(FLAG):
	@mkdir -p $(subst $(SRCROOT),$(OBJROOT),$(SRCDIRS))
	@$(foreach dirname,$(OTHERDIRS),$(call link,$(dirname)))
	@touch $(FLAG)

# 一時ディレクトリ内の依存関係ファイルを読み込む
-include $(OBJECTS:.aux=.d)

