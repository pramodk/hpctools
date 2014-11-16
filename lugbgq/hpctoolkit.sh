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

set -x
set -e

: ${HPCTOOLKIT_HOME:="${HOME}/workarena/systems/lugbgq/softwares/sources/profilers/hpctoolkit"}
echo "Creating HPCTOOLKIT_HOME: '${HPCTOOLKIT_HOME}'" 
mkdir -p "${HPCTOOLKIT_HOME}" || exit 1

export PATH=/bgsys/drivers/ppcfloor/gnu-linux/bin/:$PATH
 
HPCTOOLKIT_HOME="$(cd $HPCTOOLKIT_HOME && pwd)" 
 
##
## Useful variables
##
HPCTOOLKIT_WORKSPACE="${HPCTOOLKIT_HOME}/" 
HPCTOOLKIT_INSTALL="${HOME}/workarena/systems/lugbgq/softwares/install/profilers/hpctoolkit" 
 
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

# DO CHECKOUT YOURSELF, SCRIPT IS FAILING 
#svn co http://hpctoolkit.googlecode.com/svn/trunk hpctoolkit|| exit 1
#svn co http://hpctoolkit.googlecode.com/svn/externals hpctoolkit-externals| exit 1

wget http://hpctoolkit.org/download/hpcviewer/hpctraceviewer-5.3.2-r1791-linux.gtk.ppc64.tgz || exit 1
wget http://hpctoolkit.org/download/hpcviewer/hpcviewer-5.3.2-r1779-linux.gtk.ppc64.tgz || exit 1
 
##
## Install external dependencies
##
echo "Stage 2 of 5: Installing hpctoolkit external dependencies to $HPCTOOLKIT_INSTALL" 
 
cd "$HPCTOOLKIT_WORKSPACE" 
 
cd hpctoolkit-externals
 
mkdir -p build_tree
cd build_tree
../configure --prefix="${HPCTOOLKIT_INSTALL}/externals"  --enable-bgq
make -j24 install
 
##
## Install core software
##
echo "Stage 3 of 5: Installing hpctoolkit core to $HPCTOOLKIT_INSTALL" 
cd "$HPCTOOLKIT_WORKSPACE" 
 
cd hpctoolkit
 
mkdir -p build_tree
cd build_tree
../configure --prefix="${HPCTOOLKIT_INSTALL}/core" --with-externals="${HPCTOOLKIT_INSTALL}/externals" MPICXX=/bgsys/drivers/ppcfloor/comm/gcc/bin/mpicxx  HPCPROFMPI_LT_LDFLAGS="-all-static" --with-externals="${HPCTOOLKIT_INSTALL}/externals/" --with-papi=/gpfs/bbp.cscs.ch/apps/bgq/external/papi/papi-5.2.0/install 
make -j24 install
 
##
## Install hpctraceviewer
##
echo "Stage 4 of 5: Installing hpctraceviewer to $HPCTOOLKIT_INSTALL" 
cd "$HPCTOOLKIT_WORKSPACE" 
 
tar xzvf hpctraceviewer-5.3.2-r1791-linux.gtk.ppc64.tgz
cd hpctraceviewer
 
./install "${HPCTOOLKIT_INSTALL}/core" 
 
##
## Install hpcviewer
##
echo "Stage 5 of 5: Installing hpcviewer to $HPCTOOLKIT_INSTALL" 
cd "$HPCTOOLKIT_WORKSPACE" 
 
tar xzvf hpcviewer-5.3.2-r1779-linux.gtk.ppc64.tgz
cd hpcviewer
 
./install "${HPCTOOLKIT_INSTALL}/core" 
 
echo "HPCToolkit successfully installed to ${HPCTOOLKIT_INSTALL}" 
