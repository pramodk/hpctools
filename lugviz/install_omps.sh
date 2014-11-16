#!/bin/bash

##BBP-EPFL

set -e

#MODULES NEEDED FOR SCALASCA TOOLCHAIN
package_names=(sqlite gperf extrae nanox mcxx)
package_names=(sqlite gperf nanox mcxx)

#LOAD DEFAULT MODULES: FOR GNU COMPILER
#module load intel/icomposer-2013.3.163-intel64
#export CC=icc
#export CXX=icpc

#DIRECTORY UNDER WHICH ALL SOFTWARES WILL BE DOWNLOADED AND INSTALLED
export INSTALL_DIR=/gpfs/bbp.cscs.ch/home/kumbhar/workarena/systems/lugviz/softwares/install/progmodels/ompss
export SOURCE_DIR=/gpfs/bbp.cscs.ch/home/kumbhar/workarena/systems/lugviz/softwares/sources/progmodels/ompss

#INSTALL ALL DEPENDENCIES
for package in ${package_names[*]}
do

    #SOURCE AND INSTALL DIRECTORY
    source_dir="$SOURCE_DIR/"
    install_dir="$INSTALL_DIR/"

    #SET ENV VARIABLE FOR THAT SOFTWARE MODULE
    env_prefix="${package^^}_INSTALL_DIR"
    export ${env_prefix}="$install_dir"

    #SOURCE DIRECTORY
    mkdir -p $source_dir
    mkdir -p $install_dir
    cd $source_dir
        
    echo "Installing package ${package^^} under ${install_dir}"

    #INSTALLATION OF INDIVIDUAL PACKAGE:
        #DOWNLOAD AND EXTRACT
        #CONFIGURE
        #MAKE AND MAKE INSTALL

    case "$package" in


    mcxx)

        cd mcxx-git
        autoreconf -f -i -v
 
        mkdir -p build
        cd build
 
        ../configure --prefix=$install_dir --enable-ompss --with-nanox=$NANOX_INSTALL_DIR PKG_CONFIG_PATH=$SQLITE_INSTALL_DIR/lib/pkgconfig GPERF=$GPERF_INSTALL_DIR/bin/gperf
        make -j12
        make install

        ;;
    esac

done

#POST PROCESSING

# 1039  cd softwarestest/install/mcxx_/bin/
# 1041  ln -s powerpc64-bgq-linux-plaincxx mpimcc
# 1042  ln -s powerpc64-bgq-linux-plaincxx mpimcxx
# 1043  ln -s powerpc64-bgq-linux-plaincxx mpimfc
# 1044  cd ../share/mcxx/config.d/
# 1045  vim 60.config.bgq
# 1057  export PATH=/home/kumbhar/softwarestest/install/mcxx_/bin:$PATH
# 1063  export PATH=$PATH:/bgsys/drivers/ppcfloor/gnu-linux/bin
# 1062  mpimcc --ompss hello.c 


