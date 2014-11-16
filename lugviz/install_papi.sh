#!/bin/bash

set -e

#installation directories
export SOURCE_DIR=/gpfs/bbp.cscs.ch/home/kumbhar/workarena/systems/lugviz/softwares/sources/profilers
export INSTALL_DIR=/gpfs/bbp.cscs.ch/home/kumbhar/workarena/systems/lugviz/softwares/install/profilers/papi-5.3.0

#load intel modules
module load intel
 
#setup directories
mkdir -p $SOURCE_DIR
mkdir -p $INSTALL_DIR

cd $SOURCE_DIR
wget http://icl.cs.utk.edu/projects/papi/downloads/papi-5.3.0.tar.gz
tar -xvzf papi-5.3.0.tar.gz 
cd papi-5.3.0 && cd src

./configure --prefix=$INSTALL_DIR --with-tests=ctests --with-shared-lib=no  --with-static-lib=yes
make -j12
make install
 
