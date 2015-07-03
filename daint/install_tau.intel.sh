#!/bin/bash
set -e
set -x

package_names=(pdtoolkit-3.20 tau-2.24.1)
package_names=(tau-2.24.1)
package_names=(pdtoolkit-3.20)
compiler_names=(intel)

module swap PrgEnv-cray PrgEnv-intel

#DIRECTORY UNDER WHICH ALL SOFTWARES WILL BE DOWNLOADED AND INSTALLED
export TAU_INSTALL_DIR=$HOME/workarena/systems/daint/softwares/install/profilers/tau-2.24.1/
export PDT_INSTALL_DIR=$HOME/workarena/systems/daint/softwares/install/profilers/pdtoolkit-3.20/
export SOURCE_DIR=$HOME/workarena/systems/daint/softwares/sources/profilers/
export PAPI_PATH_ARCH=/opt/cray/papi/5.4.0.1


for compiler in ${compiler_names[*]}
do
    export scorep_dir=/users/kumbhar/workarena/systems/daint/softwares/install/profilers/scorep-1.4.2/$compiler
    export scorep_dir=/users/kumbhar/workarena/systems/daint/softwares/install/profilers/scorep-1.4.2/intel_with_pdt

    for package in ${package_names[*]}
    do

        #SOURCE AND INSTALL DIRECTORY
        source_dir="$SOURCE_DIR/$package"
 
        pdt_install_dir="$PDT_INSTALL_DIR/$compiler"
        tau_install_dir="$TAU_INSTALL_DIR/$compiler"

        #SOURCE DIRECTORY
        mkdir -p $source_dir
        mkdir -p $pdt_install_dir
        mkdir -p $tau_install_dir

        cd $source_dir

        echo "Installing package ${package} under ${install_dir}"

        case "$package" in

            pdtoolkit-3.20)
                ./configure -ICPC -prefix=$pdt_install_dir 
                make install
                ;;

            tau-2.24.1)
                
                ./configure -prefix=$tau_install_dir -arch=craycnl  -c++=CC -cc=cc  -bfd=download -unwind=download -pdt=$pdt_install_dir  -papi=$PAPI_PATH_ARCH 
                make -j12
                make install

                ./configure -prefix=$tau_install_dir -arch=craycnl  -c++=CC -cc=cc  -bfd=download -unwind=download -pdt=$pdt_install_dir  -papi=$PAPI_PATH_ARCH -mpi 
                make -j12
                make install

                ./configure -prefix=$tau_install_dir -arch=craycnl  -c++=CC -cc=cc  -bfd=download -unwind=download -pdt=$pdt_install_dir  -papi=$PAPI_PATH_ARCH -mpi -pthread 
                make -j12
                make install

                ./configure -prefix=$tau_install_dir -arch=craycnl  -c++=CC -cc=cc  -bfd=download -unwind=download -pdt=$pdt_install_dir  -papi=$PAPI_PATH_ARCH -mpi -openmp -opari 
                make -j12
                make install

    
                #with scorep

#                ./configure -prefix=$tau_install_dir -arch=craycnl  -c++=CC -cc=cc  -bfd=download -unwind=download -pdt=$pdt_install_dir -scorep=$scorep_dir -papi=$PAPI_PATH_ARCH -DISABLESHARED
#                make -j12
#                make install
#
#                ./configure -prefix=$tau_install_dir -arch=craycnl  -c++=CC -cc=cc  -bfd=download -unwind=download -pdt=$pdt_install_dir -scorep=$scorep_dir -papi=$PAPI_PATH_ARCH -mpi  -DISABLESHARED
#                make -j12
#                make install
#
#                ./configure -prefix=$tau_install_dir -arch=craycnl  -c++=CC -cc=cc  -bfd=download -unwind=download -pdt=$pdt_install_dir -scorep=$scorep_dir  -papi=$PAPI_PATH_ARCH -mpi -pthread -DISABLESHARED
#                make -j12
#                make install
#
#                ./configure -prefix=$tau_install_dir -arch=craycnl  -c++=CC -cc=cc  -bfd=download -unwind=download -pdt=$pdt_install_dir -scorep=$scorep_dir -papi=$PAPI_PATH_ARCH -mpi -openmp -opari -DISABLESHARED
#                make -j12
#                make install
#
                #no success
                #./configure --prefix=/users/kumbhar/workarena/systems/daint/softwares/install/profilers/scorep-1.4.2/cray/ --with-papi-header=/opt/cray/papi/5.4.0.1/include --with-papi-lib=/opt/cray/papi/5.4.0.1/lib --with-libcudart=/opt/nvidia/cudatoolkit6.5/6.5.14-1.0502.9613.6.1 --enable-cuda  --with-libcupti=/opt/nvidia/cudatoolkit6.5/6.5.14-1.0502.9613.6.1/extras/CUPTI/
                ;;

        esac

    done
done
