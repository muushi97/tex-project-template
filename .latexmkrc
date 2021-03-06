#!/usr/bin/env perl
#$aux_dir            = '../.temp'
#$out_dir            = '../.temp'
$latex              = 'uplatex -synctex=1 -halt-on-error';
$latex_silent       = 'uplatex -synctex=1 -halt-on-error -interaction=batchmode';
$bibtex             = 'pbibtex %O %B -kanji=utf8';
$biber              = 'biber %O --bblencoding=utf8 -u -U --output_safechars %B';
$dvipdf             = 'dvipdfmx %O -o %D %S';
$makeindex          = 'mendex %O -o %D %S';
$max_repeat         = 5;
$pdf_mode           = 3; # generates pdf via dvipdfmx

# Prevent latexmk from removing PDF after typeset.
$pvc_view_file_via_temporary = 0;

# Use Evince editor
$pdf_previewer    = "evince %O %S";

