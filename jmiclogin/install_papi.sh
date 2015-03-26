#!/bin/bash
set -e
set -x

#LOAD DEFAULT MODULES: FOR INTEL COMPILER
module load intel impi

#DEFAULT COMPILER FOR INSTALLATION
export CC=icc
export CXX=icpc

#DIRECTORY UNDER WHICH ALL SOFTWARES WILL BE DOWNLOADED AND INSTALLED
export INSTALL_DIR=$HOME/workarena/systems/jknc/softwares/install/profilers/papi-5.3.2/
export SOURCE_DIR=$HOME/workarena/systems/jknc/softwares/sources/profilers/papi-5.3.2/src/

mkdir -p $SOURCE_DIR

#SOURCE DIRECTORY
mkdir -p $INSTALL_DIR
cd $SOURCE_DIR


#MIC
#make clean
./configure --prefix=$INSTALL_DIR/mic_linux --with-shared-lib=no --with-static-lib=yes  FC=ifort --with-mic --host=x86_64-k1om-linux --with-arch=k1om --with-ffsll --with-walltimer=cycle --with-tls=__thread --with-virtualtimer=clock_thread_cputime_id CC=$CC CXX=$CXX --with-tests=ftests
make clean
CFLAGS=-mmic make -j12
make install

#x86
make distclean

./configure --prefix=$INSTALL_DIR/x86_64 --with-shared-lib=no --with-static-lib=yes --with-ffsll --with-walltimer=cycle --with-tls=__thread --with-virtualtimer=clock_thread_cputime_id FC=ifort CC=icc CXX=icpc --with-tests=ftests 
make -j12
make install


