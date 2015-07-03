#!/bin/bash
set -e
set -x

package_names=(scorep)
compiler_names=(cray)

#for intel
#compiler_names=(intel)
#module swap PrgEnv-cray PrgEnv-intel

#for intel
compiler_names=(pgi)
module swap PrgEnv-cray PrgEnv-pgi

#DIRECTORY UNDER WHICH ALL SOFTWARES WILL BE DOWNLOADED AND INSTALLED
export INSTALL_DIR=$HOME/workarena/systems/daint/softwares/install/profilers/scorep-1.4.2
export SOURCE_DIR=$HOME/workarena/systems/daint/softwares/sources/profilers/scorep-1.4.2
export PAPI_PATH_ARCH=/opt/cray/papi/5.4.0.1

export CC=`which cc`
export CXX=`which CC`

for compiler in ${compiler_names[*]}
do
    export PDT_HOME=/users/kumbhar/workarena/systems/daint/softwares/install/profilers/pdtoolkit-3.20/$compiler/craycnl/bin
    for package in ${package_names[*]}
    do

        install_dir="$INSTALL_DIR/$compiler"

        mkdir -p $install_dir
        cd $SOURCE_DIR

        echo "Installing package ${package} under ${install_dir}"

        case "$package" in

            scorep)

                #with pdt
                #./configure --prefix=${install_dir}_with_pdt --with-papi-header=$PAPI_PATH_ARCH/include --with-papi-lib=$PAPI_PATH_ARCH/lib --disable-shared --enable-static --with-pdt=$PDT_HOME
                #with pgi + pdt
 #               ./configure --prefix=${install_dir}_with_pdt --with-papi-header=$PAPI_PATH_ARCH/include --with-papi-lib=$PAPI_PATH_ARCH/lib --disable-shared --enable-static --with-pdt=$PDT_HOME  --with-nocross-compiler-suite=pgi
 #               make clean
 #               make VERBOSE=1 -j8
 #               make install

                #without pdt
                #./configure --prefix=$install_dir/ --with-papi-header=$PAPI_PATH_ARCH/include --with-papi-lib=$PAPI_PATH_ARCH/lib --disable-shared --enable-static

                #with pgi + without pdt
                ./configure --prefix=$install_dir/ --with-papi-header=$PAPI_PATH_ARCH/include --with-papi-lib=$PAPI_PATH_ARCH/lib --disable-shared --enable-static  --with-nocross-compiler-suite=pgi
                make clean
                make VERBOSE=1 -j8 
                make install
                
#                ./configure --prefix=$install_dir/ --with-papi-header=$PAPI_PATH_ARCH/include --with-papi-lib=$PAPI_PATH_ARCH/lib --enable-shared --disable-static
#                make clean
#                make VERBOSE=1 -j8
#                make install
                ;;
        esac

    done
done
