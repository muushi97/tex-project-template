#!/bin/sh

PROJECT_DIRECTORY=..

TEMPLATE_DIRECTORY=`dirname $0`

cd ${TEMPLATE_DIRECTORY}

PROJECT_SOURCES_DIRECTORY="sources"
PROJECT_BIBLIOGRAPHIES_DIRECTORY="bibliographies"
PROJECT_IMAGES_DIRECTORY="images"

ln -s ${TEMPLATE_DIRECTORY}/preambles ${PROJECT_DIRECTORY}/preambles
mkdir -p ${PROJECT_DIRECTORY}/${PROJECT_SOURCES_DIRECTORY}
mkdir -p ${PROJECT_DIRECTORY}/${PROJECT_BIBLIOGRAPHIES_DIRECTORY}
mkdir -p ${PROJECT_DIRECTORY}/${PROJECT_IMAGES_DIRECTORY}

cat <<EOS > "${PROJECT_DIRECTORY}/${PROJECT_SOURCES_DIRECTORY}/master.ltx"
\documentclass[uplatex,11ptj,a4j,dvipdfmx]{jsarticle}

\input{./preambles/package.ltx}
\input{./preambles/listing.ltx}
\input{./preambles/othersetting.ltx}
\input{./preambles/macro.ltx}
\input{./preambles/referencemacro.ltx}

\author{}
\date{}
EOS

