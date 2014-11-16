###SCALASCA installation script for BG-Q @ CSCS - Pramod Kumbhar, Blue Brain Project @ EPFL######

#!/bin/bash
set -e

#MODULES NEEDED FOR SCALASCA TOOLCHAIN, IN ORDER
package_names=(otf2 opari2 qt cube scorep scalasca)

#LOAD DEFAULT MODULE: BBP-PROD-DEV (local on our system, PAPI, ZLIB, SION ARE LOADED FROM HERE)
module load dev-prod/1.0.0

#DIRECTORY UNDER WHICH ALL SOFTWARES WILL BE DOWNLOADED AND INSTALLED
export INSTALL_DIR=/gpfs/bbp.cscs.ch/home/kumbhar/workarena/systems/lugbgq/softwares/install/profilers/scalasca
export SOURCE_DIR=/gpfs/bbp.cscs.ch/home/kumbhar/workarena/systems/lugbgq/softwares/sources/profilers/scalasca

export PATH=$PATH:/opt/ibmcmp/vacpp/bg/12.1/bin:/opt/ibmcmp/vac/bg/12.1/bin:/opt/ibmcmp/xlf/bg/14.1/bin

compiler=ibm

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


        #OTF2: http://www.vi-hps.org/projects/score-p/
        otf2)
            wget http://www.vi-hps.org/upload/packages/otf2/otf2-1.2.1.tar.gz
            tar -xvzf otf2-1.2.1.tar.gz
            cd otf2-1.2.1

            ./configure --prefix=$OTF2_INSTALL_DIR --host=powerpc64-bgq-linux --with-platform=bgq --with-frontend-compiler-suite=ibm --with-sionconfig=$SION_INSTALL_DIR/bin/sionconfig --enable-shared=no --enable-static=yes
            make -j12
            make install
            ;;

        #OPARI2: http://www.vi-hps.org/projects/score-p/
        opari2)
            wget http://www.vi-hps.org/upload/packages/opari2/opari2-1.1.1.tar.gz
            tar -xvzf opari2-1.1.1.tar.gz
            cd opari2-1.1.1

            #NOTE THAT INSTALLATION FAILS WITHOUT -O2, SEE BUG REPORT http://www-01.ibm.com/support/docview.wss?uid=swg1LI77249
            ./configure --prefix=$OPARI2_INSTALL_DIR --with-compiler-suite=${compiler} --enable-shared=no --enable-static=yes CXXFLAGS_FOR_BUILD="-O2" CFLAGS_FOR_BUILD="-O2" CXXFLAGS="-O2" CFLAGS="-O2"
            make -j12
            make install
            make check
            ;;

        #QT: http://qt-project.org/downloads
        qt)
            wget http://mirrors.linsrv.net/Qt/official_releases/qt/4.8/4.8.5/qt-everywhere-opensource-src-4.8.5.tar.gz
            tar -xvzf qt-everywhere-opensource-src-4.8.5.tar.gz
            cd qt-everywhere-opensource-src-4.8.5

            #SKIP BUILDING EXAMPLES WITH INTEL COMPILER
            sed -i.old '40s;^;#;' projects.pro
            sed -i.old '42s;^;#;' projects.pro

            #QT BUILD ON BG-Q FAILED IF WE DONT ADD CXX FLAGS, SEE GNU COMPILER MANUAL
            for file in $(find . -name '*.pro') ; do
                echo "*-g++* {"  >> $file
                echo "    QMAKE_CXXFLAGS += -mminimal-toc" >> $file
                echo "    QMAKE_CFLAGS += -mminimal-toc" >> $file
                echo "}" >> $file
            done

            ./configure --prefix=$QT_INSTALL_DIR -static -platform linux-g++-64 -fast -confirm-license -opensource
            gmake -j12
            gmake install
            ;;

        #CUBE: http://www.scalasca.org/software/cube-4.x/download.html 
        cube)
            wget http://apps.fz-juelich.de/scalasca/releases/cube/4.2/dist/cube-4.2.tar.gz
            tar -xvzf cube-4.2.tar.gz
            cd cube-4.2

            ./configure --prefix=$CUBE_INSTALL_DIR --with-tools --with-vampir --with-frontend-compiler-suite=gcc --with-gui --with-qt=$QT_INSTALL_DIR --enable-static=yes --enable-shared=no
            #./configure --prefix=$CUBE_INSTALL_DIR --with-tools --with-vampir --with-frontend-compiler-suite=gcc --with-gui
            make -j12
            make install
            ;;

        #SCORE-P: http://www.vi-hps.org/projects/score-p/
        scorep)
            wget http://www.vi-hps.org/upload/packages/scorep/scorep-1.2.1.tar.gz
            tar -xvzf scorep-1.2.1.tar.gz
            cd scorep-1.2.1
            ./configure --prefix=$SCOREP_INSTALL_DIR --with-frontend-compiler-suite=ibm --with-mpi=ibmpoe --with-otf2=$OTF2_INSTALL_DIR/bin --with-opari2=$OPARI2_INSTALL_DIR/bin --with-cube=$CUBE_INSTALL_DIR --with-papi-header=$PAPI_ROOT/include --with-papi-lib=$PAPI_ROOT/lib
            make -j12
            make check
            make install
            ;;

        #SCALASCA: http://www.scalasca.org/software/scalasca-2.x/download.html
        #todo: need to apply patch for slurm, --envs variable should be removed from src/utils/scan.cpp   
        scalasca)
            wget http://apps.fz-juelich.de/scalasca/releases/scalasca/2.0/dist/scalasca-2.0.tar.gz
            tar -xvzf scalasca-2.0.tar.gz
            cd scalasca-2.0

            ./configure --prefix=$SCALASCA_INSTALL_DIR --with-frontend-compiler-suite=ibm --with-otf2=$OTF2_INSTALL_DIR --with-cube=$CUBE_INSTALL_DIR --with-sionconfig=$SIONLIB_ROOT/bin/sionconfig --with-libz=$ZLIB_ROOT
            make -j12
            make install
    esac

done

