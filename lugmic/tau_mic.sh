
#install on dommic

module load icc impi

#pdt
./configure -ICPC -prefix=/users/kumbhar/workarena/softwares/install/x86/pdt/

#on mic
./configure -arch=mic_linux -cc=mpiicc -c++=mpiicpc     -prefix=/users/kumbhar/workarena/softwares/install/mic/tau_mpi_pdt_opari  -iowrapper -pdt=/users/kumbhar/workarena/softwares/install/mic/pdt -pdt_c++=mpiicpc  -mpi -mpiinc=/apps/dommic/intel/impi/4.1.3.048/mic/include -mpilib=/apps/dommic/intel/impi/4.1.3.048/mic/lib  -papi=/users/kumbhar/papi-5.3.0/mic 

make -j12 VERBOSE=1
make install

export TAU_MAKEFILE=~/workarena/softwares/install/mic/tau_mpi_pdt_opari/mic_linux/lib/Makefile.tau-icpc-papi-mpi-pdt
export PATH=/users/kumbhar/workarena/softwares/install/mic/tau_mpi_pdt_opari/mic_linux/bin:$PATH


#on x86
./configure -cc=mpiicc -c++=mpiicpc     -prefix=/users/kumbhar/workarena/softwares/install/x86/tau_mpi_pdt_opari  -iowrapper -pdt=/users/kumbhar/workarena/softwares/install/x86/pdt -pdt_c++=mpiicpc  -mpi -mpiinc=/apps/dommic/intel/impi/4.1.3.048/intel64/include -mpilib=/apps/dommic/intel/impi/4.1.3.048/intel64/lib -unwind=download -bfd=download -papi=/users/kumbhar/papi-5.3.0/x86 -opari -mpilibrary=-lmpi_mt
make install



From KNC-Login

###TAU @ MICLOGIN - Pramod Kumbhar, Blue Brain Project @ EPFL######

#!/bin/bash
set -e

#MODULES NEEDED FOR Tau
package_names=(pdt tau)

#LOAD DEFAULT MODULE
module load intel impi

#DIRECTORY UNDER WHICH ALL SOFTWARES WILL BE DOWNLOADED AND INSTALLED
export INSTALL_DIR=$HOME/workarena/systems/jknc/softwares/install/profilers/tau
export SOURCE_DIR=$HOME/workarena/systems/jknc/softwares/sources/profilers


#INSTALL ALL DEPENDENCIES AND SCALASCA
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

    #INSTALLATION STEPS OF INDIVIDUAL PACKAGE:
        #DOWNLOAD AND EXTRACT
        #CONFIGURE
        #MAKE AND MAKE INSTALL

    case "$package" in


        pdt)
            wget http://www.cs.uoregon.edu/research/paracomp/pdtoolkit/Download/pdt_latest.tar.gz
            tar -xvzf pdt_latest.tar.gz
            cd pdtoolkit-3.20

            ./configure -ICPC -prefix=$PDT_INSTALL_DIR ./configure 

            make -j12
            make install
            ;;

        tau)
            wget http://www.cs.uoregon.edu/research/paracomp/tau/tauprofile/dist/tau_latest.tar.gz
            tar -xvzf tau_latest.tar.gz
            cd tau-2.24

            ./configure -prefix=$TAU_INSTALL_DIR -arch=mic_linux -cc=mpiicc -c++=mpiicpc -iowrapper -pdt=$PDT_INSTALL_DIR -pdt_c++=mpiicpc -mpi -openmp -opari -mpiinc=/opt/intel/impi/4.1.2.040/mic/include -mpilib=/opt/intel/impi/4.1.2.040/mic/lib -mpilibrary=-lmpi_mt

            make -j12
            make install
            ;;

    esac

done
