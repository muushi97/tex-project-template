#!/bin/sh

PROJECT_DIRECTORY=..

TEMPLATE_DIRECTORY=`dirname $0`

cd ${TEMPLATE_DIRECTORY}

ln -s ${TEMPLATE_DIRECTORY}/.latexmkrc ${PROJECT_DIRECTORY}/.latexmkrc
ln -s ${TEMPLATE_DIRECTORY}/preambles ${PROJECT_DIRECTORY}/preambles
ln -s ${TEMPLATE_DIRECTORY}/Makefile ${PROJECT_DIRECTORY}/Makefile
ln -s ${TEMPLATE_DIRECTORY}/.gitignore ${PROJECT_DIRECTORY}/.gitignore
#mkdir -p ${PROJECT_DIRECTORY}/images
cp -r ./images ${PROJECT_DIRECTORY}/images
cp ./master.tex ${PROJECT_DIRECTORY}/master.tex


