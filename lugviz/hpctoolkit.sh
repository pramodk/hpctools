#!/bin/bash
#
# Usage: [HPCTOOLKIT_HOME=/path/for/hpctoolkit/home] ./install-hpctoolkit.sh
#
# Environment Variables
#
#   HPCTOOLKIT_HOME   (Optional) To specify a location to build and
#                     install the HPCToolkit software.
#                     Default: $HOME/opt/hpctoolkit
 
##
## Default HPCToolkit $HOME
##
: ${HPCTOOLKIT_HOME:="${HOME}/workarena/systems/lugviz/softwares/sources/profilers/hpctoolkit"}
echo "Creating HPCTOOLKIT_HOME: '${HPCTOOLKIT_HOME}'" 
mkdir -p "${HPCTOOLKIT_HOME}" || exit 1
 
HPCTOOLKIT_HOME="$(cd $HPCTOOLKIT_HOME && pwd)" 
 
##
## Useful variables
##
HPCTOOLKIT_WORKSPACE="${HPCTOOLKIT_HOME}/" 
HPCTOOLKIT_INSTALL="${HOME}/workarena/systems/lugviz/softwares/install/profilers/hpctoolkit" 
 
module load gcc/4.8.2   
module load mvapich2/2.0

##
## Create directories
##
 
echo "Creating install '${HPCTOOLKIT_INSTALL}'" 
mkdir -p "$HPCTOOLKIT_INSTALL" || exit 1
 
##
## Download software
##
echo "Stage 1 of 5: Downloading software tarballs to $HPCTOOLKIT_WORKSPACE" 
 
cd "$HPCTOOLKIT_WORKSPACE" 

#manuall checkout below two 
#svn co http://hpctoolkit.googlecode.com/svn/trunk hpctoolkit|| exit 1
#svn co http://hpctoolkit.googlecode.com/svn/externals hpctoolkit-externals| exit 1
wget http://hpctoolkit.org/download/hpcviewer/hpctraceviewer-5.3.2-r1791-linux.gtk.x86_64.tgz || exit 1
wget http://hpctoolkit.org/download/hpcviewer/hpcviewer-5.3.2-r1779-linux.gtk.x86_64.tgz || exit 1
 
##
## Install external dependencies
##
echo "Stage 2 of 5: Installing hpctoolkit external dependencies to $HPCTOOLKIT_INSTALL" 
 
cd "$HPCTOOLKIT_WORKSPACE" 
 
cd hpctoolkit-externals
 
mkdir -p build_tree
cd build_tree
rm -rf build_tree/*
../configure --prefix="${HPCTOOLKIT_INSTALL}/externals" 
make -j24 install
 
##
## Install core software
##
echo "Stage 3 of 5: Installing hpctoolkit core to $HPCTOOLKIT_INSTALL" 
cd "$HPCTOOLKIT_WORKSPACE" 
 
cd hpctoolkit
 
mkdir -p build_tree
rm -rf build_tree/*
cd build_tree
../configure --prefix="${HPCTOOLKIT_INSTALL}/core" --with-externals="${HPCTOOLKIT_INSTALL}/externals" --with-papi=/gpfs/bbp.cscs.ch/home/kumbhar/workarena/systems/lugviz/softwares/install/profilers/papi-5.3.0_gcc
make -j24 install
 
##
## Install hpctraceviewer
##
echo "Stage 4 of 5: Installing hpctraceviewer to $HPCTOOLKIT_INSTALL" 
cd "$HPCTOOLKIT_WORKSPACE" 
 
tar xzvf hpctraceviewer-5.3.2-r1791-linux.gtk.x86_64.tgz
cd hpctraceviewer
 
./install "${HPCTOOLKIT_INSTALL}/core" 
 
##
## Install hpcviewer
##
echo "Stage 5 of 5: Installing hpcviewer to $HPCTOOLKIT_INSTALL" 
cd "$HPCTOOLKIT_WORKSPACE" 
 
tar xzvf hpcviewer-5.3.2-r1779-linux.gtk.x86_64.tgz
cd hpcviewer
 
./install "${HPCTOOLKIT_INSTALL}/core" 
 
echo "HPCToolkit successfully installed to ${HPCTOOLKIT_INSTALL}" 
