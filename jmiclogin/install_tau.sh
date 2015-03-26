###TAU @ MICLOGIN - Pramod Kumbhar, Blue Brain Project @ EPFL######

#!/bin/bash
set -e

#MODULES NEEDED FOR Tau
package_names=(pdt tau)
arch_names=(mic_linux x86_64)

#LOAD DEFAULT MODULE
module load intel impi

#DIRECTORY UNDER WHICH ALL SOFTWARES WILL BE DOWNLOADED AND INSTALLED
export INSTALL_DIR=$HOME/workarena/systems/jknc/softwares/install/profilers/tau
export SOURCE_DIR=$HOME/workarena/systems/jknc/softwares/sources/profilers/tau-devel

export SCOREP_PATH=$HOME/workarena/systems/jknc/softwares/install/profilers/scorep-1.4/
export PAPI_PATH=$HOME/workarena/systems/jknc/softwares/install/profilers/papi-5.3.2


for arch in ${arch_names[*]}
do
    for package in ${package_names[*]}
    do

        #SOURCE AND INSTALL DIRECTORY
        source_dir="$SOURCE_DIR"
        install_dir="$INSTALL_DIR/$arch"

        export PAPI_PATH_ARCH=$PAPI_PATH/$arch
        export SCOREP_PATH_ARCH=$SCOREP_PATH/$arch

        mkdir -p $source_dir
        mkdir -p $install_dir

        cd $source_dir

        echo "Installing package ${package^^} under ${install_dir}"

        if [ "$arch" == "mic_linux" ];
        then
            ARCH_BUILD_OPTS=" -arch=mic_linux "
            export MPI_PATH=$I_MPI_ROOT/mic
        else
            ARCH_BUILD_OPTS=" "
            export MPI_PATH=$I_MPI_ROOT/intel64
        fi


        case "$package" in


            pdt)
                #tar -xvzf pdt_latest.tar.gz
                cd pdtoolkit-3.20

                ./configure -ICPC -prefix=$install_dir
                make -j12
                make install
                ;;

            tau)
                #wget http://tau.uoregon.edu/tau2.tgz
                #tar -xvzf tau2.tgz
                cd tau2

                ./configure -prefix=$install_dir $ARCH_BUILD_OPTS -cc=mpiicc -c++=mpiicpc -iowrapper -pdt=$install_dir -pdt_c++=mpiicpc -mpi -openmp -opari -mpiinc=$MPI_PATH/include -mpilib=$MPI_PATH/lib -mpilibrary=-lmpi_mt -scorep=$SCOREP_PATH_ARCH -papi=$PAPI_PATH_ARCH -DISABLESHARED -iowrapper -PROFILEPHASE -PROFILEPARAM
                make clean
                make -j12 install


                ./configure -prefix=$install_dir  $ARCH_BUILD_OPTS -cc=mpiicc -c++=mpiicpc -pdt=$install_dir -pdt_c++=mpiicpc -mpi -mpiinc=$MPI_PATH/include -mpilib=$MPI_PATH/lib -mpilibrary=-lmpi_mt -scorep=$SCOREP_PATH_ARCH -papi=$PAPI_PATH_ARCH -DISABLESHARED 
                make clean
                make -j12 install

                ./configure -prefix=$install_dir  $ARCH_BUILD_OPTS -cc=mpiicc -c++=mpiicpc -iowrapper -pdt=$install_dir -pdt_c++=mpiicpc -mpi -openmp -opari -mpiinc=$MPI_PATH/include -mpilib=$MPI_PATH/lib -mpilibrary=-lmpi_mt -scorep=$SCOREP_PATH_ARCH -papi=$PAPI_PATH_ARCH -DISABLESHARED
                make clean
                make -j12 install

                ./configure -prefix=$install_dir  $ARCH_BUILD_OPTS -cc=mpiicc -c++=mpiicpc -iowrapper -pdt=$install_dir -pdt_c++=mpiicpc -mpi -openmp -opari -mpiinc=$MPI_PATH/include -mpilib=$MPI_PATH/lib -mpilibrary=-lmpi_mt -papi=$PAPI_PATH_ARCH -DISABLESHARED
                make clean
                make -j12 install

                ./configure -prefix=$install_dir  $ARCH_BUILD_OPTS -cc=mpiicc -c++=mpiicpc -iowrapper -pdt=$install_dir -pdt_c++=mpiicpc -mpi -openmp -opari -mpiinc=$MPI_PATH/include -mpilib=$MPI_PATH/lib -mpilibrary=-lmpi_mt -papi=$PAPI_PATH_ARCH -DISABLESHARED -iowrapper -PROFILEPHASE -PROFILEPARAM
                make clean
                make -j12 install
                ;;
        esac

    done

done
