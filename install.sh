#!/bin/sh

PROJECT_DIRECTORY=..

TEMPLATE_DIRECTORY=`dirname $0`

cd ${TEMPLATE_DIRECTORY}

ln -s ${TEMPLATE_DIRECTORY}/.latexmkrc ${PROJECT_DIRECTORY}/.latexmkrc
ln -s ${TEMPLATE_DIRECTORY}/preambles ${PROJECT_DIRECTORY}/preambles
ln -s ${TEMPLATE_DIRECTORY}/Makefile ${PROJECT_DIRECTORY}/Makefile
ln -s ${TEMPLATE_DIRECTORY}/.gitignore ${PROJECT_DIRECTORY}/.gitignore
mkdir -p ${PROJECT_DIRECTORY}/images
mkdir -p ${PROJECT_DIRECTORY}/sources
mkdir -p ${PROJECT_DIRECTORY}/scripts
mkdir -p ${PROJECT_DIRECTORY}/bibliography
cp -b ./master-template.ltx ${PROJECT_DIRECTORY}/sources/master.ltx

cd ${PROJECT_DIRECTORY}
ln -s ./sources/master.ltx ./master.ltx

