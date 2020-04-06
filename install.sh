#!/bin/sh

PROJECT_DIRECTORY=..

TEMPLATE_DIRECTORY=`dirname $0`

cd ${TEMPLATE_DIRECTORY}

ln -s ${TEMPLATE_DIRECTORY}/.latexmkrc ${PROJECT_DIRECTORY}/.latexmkrc
ln -s ${TEMPLATE_DIRECTORY}/preambles ${PROJECT_DIRECTORY}/preambles
ln -s ${TEMPLATE_DIRECTORY}/Makefile ${PROJECT_DIRECTORY}/Makefile
ln -s ${TEMPLATE_DIRECTORY}/.gitignore ${PROJECT_DIRECTORY}/.gitignore
#mkdir -p ${PROJECT_DIRECTORY}/images
cp -rb ./images ${PROJECT_DIRECTORY}/images
cp -b ./master.ltx ${PROJECT_DIRECTORY}/master.ltx


