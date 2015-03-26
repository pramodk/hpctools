###TAU @ MICLOGIN - Pramod Kumbhar, Blue Brain Project @ EPFL######

#!/bin/bash
set -e

#MODULES NEEDED FOR Tau
package_names=(scorep)
arch_names=(mic_linux x86_64)

#LOAD DEFAULT MODULE
module load intel impi

#DIRECTORY UNDER WHICH ALL SOFTWARES WILL BE DOWNLOADED AND INSTALLED
export INSTALL_DIR=$HOME/workarena/systems/jknc/softwares/install/profilers/scorep-1.4
export SOURCE_DIR=$HOME/workarena/systems/jknc/softwares/sources/profilers/scorep-1.4

export PAPI_PATH=$HOME/workarena/systems/jknc/softwares/install/profilers/papi-5.3.2

for arch in ${arch_names[*]}
do
    for package in ${package_names[*]}
    do

        #SOURCE AND INSTALL DIRECTORY
        source_dir="$SOURCE_DIR/"
        install_dir="$INSTALL_DIR/$arch/"

        #SOURCE DIRECTORY
        mkdir -p $source_dir
        mkdir -p $install_dir
        cd $source_dir

        echo "Installing package ${package^^} under ${install_dir}"

        export PAPI_PATH_ARCH=$PAPI_PATH/$arch/

         if [ "$arch" == "mic_linux" ];
         then
              ARCH_BUILD_OPTS=" --enable-platform-mic "
         else
              ARCH_BUILD_OPTS=" "
         fi


        case "$package" in


            scorep)
                ./configure $ARCH_BUILD_OPTS --with-mpi=intel --prefix=$install_dir/ --with-papi-header=$PAPI_PATH_ARCH/include --with-papi-lib=$PAPI_PATH_ARCH/lib
                make clean
                make VERBOSE=1
                make install
                ;;

        esac

    done

done
