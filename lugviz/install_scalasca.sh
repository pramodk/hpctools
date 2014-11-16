#!/bin/bash
set -e

#MODULES NEEDED FOR SCALASCA TOOLCHAIN
package_names=(sion zlib otf2 opari2 qt cube papi scorep pdt scalasca)

#LOAD DEFAULT MODULES: FOR INTEL COMPILER
module load intel
#module load  mvapich2/1.9-intel-2013.1.117    

#DEFAULT COMPILER FOR INSTALLATION
export CC=icc
export CXX=icpc

#COMPILER: INTEL OR GNU
compiler="intel"

#DIRECTORY UNDER WHICH ALL SOFTWARES WILL BE DOWNLOADED AND INSTALLED
export INSTALL_DIR=/gpfs/bbp.cscs.ch/home/kumbhar/workarena/systems/lugviz/softwares/install/profilers/scalasca
export SOURCE_DIR=/gpfs/bbp.cscs.ch/home/kumbhar/workarena/systems/lugviz/softwares/sources/profilers/scalasca

mv $SOURCE_DIR /gpfs/bbp.cscs.ch/home/kumbhar/workarena/systems/lugviz/softwares/sources/profilers/scalasca_old
mkdir -p $SOURCE_DIR

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

    #INSTALLATION OF INDIVIDUAL PACKAGE:
        #DOWNLOAD AND EXTRACT
        #CONFIGURE
        #MAKE AND MAKE INSTALL

    case "$package" in

        #SION LIBRARY: http://www.fz-juelich.de/ias/jsc/EN/Expertise/Support/Software/SIONlib/sionlib-fileformat_node
        sion)
            wget http://apps.fz-juelich.de/jsc/sionlib//log/tmpfull0002/sionlib-1.3p7.tar.gz
            tar -xvzf sionlib-1.3p7.tar.gz 
            cd sionlib

            ./configure --prefix=$SION_INSTALL_DIR --compiler=${compiler} --mpi=mpich2
            cd build-linux-${compiler}-mpich2/
            #Optionally change CFLAGS to -O3 in Makefiles.def
            make
            make test && make install
            ;;

        #ZLIB: http://www.zlib.net
        zlib)
            wget http://zlib.net/zlib-1.2.8.tar.gz
            tar -xvzf zlib-1.2.8.tar.gz 
            cd zlib-1.2.8

            ./configure --prefix=$ZLIB_INSTALL_DIR --static 
            make -j12
            make test
            make install
           ;;

        #OTF2: http://www.vi-hps.org/projects/score-p/
        otf2)
            wget http://www.vi-hps.org/upload/packages/otf2/otf2-1.2.1.tar.gz
            tar -xvzf otf2-1.2.1.tar.gz 
            cd otf2-1.2.1

            ./configure --prefix=$OTF2_INSTALL_DIR --with-platform=auto --with-nocross-compiler-suite=${compiler} --with-sionconfig=$SION_INSTALL_DIR/bin/sionconfig
            make -j12
            make install
            ;;
        
        #OPARI2: http://www.vi-hps.org/projects/score-p/
        opari2)
            wget http://www.vi-hps.org/upload/packages/opari2/opari2-1.1.1.tar.gz
            tar -xvzf opari2-1.1.1.tar.gz 
            cd opari2-1.1.1

            ./configure --prefix=$OPARI2_INSTALL_DIR --with-compiler-suite=${compiler}
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

            ./configure --prefix=$QT_INSTALL_DIR -static -platform linux-icc-64 -fast -confirm-license -opensource
            gmake -j12
            gmake install
            ;;

        #PDT: http://www.cs.uoregon.edu/research/pdt/home.php    
        pdt)
            wget http://tau.uoregon.edu/pdt_lite.tgz
            tar -xvzf pdt_lite.tgz 
            cd pdtoolkit-3.20/ 

            ./configure --prefix=$PDT_INSTALL_DIR -ICPC CC=${CC} CXX=${CXX}
            make -j12
            make install
            ;;

        #PAPI: http://icl.cs.utk.edu/papi/
        papi)
            wget http://icl.cs.utk.edu/projects/papi/downloads/papi-5.2.0.tar.gz
            tar -xvzf papi-5.2.0.tar.gz 
            cd papi-5.2.0/src

            ./configure --prefix=$PAPI_INSTALL_DIR --with-static-lib=yes --with-shared-lib=no LDFLAGS="-openmp"
            make 
            make test
            make install
            ;;
            
        #CUBE: http://www.scalasca.org/software/cube-4.x/download.html 
        cube)
            wget http://apps.fz-juelich.de/scalasca/releases/cube/4.2/dist/cube-4.2.tar.gz
            tar -xvzf cube-4.2.tar.gz
            cd cube-4.2

            ./configure --prefix=$CUBE_INSTALL_DIR --with-tools --with-vampir --with-nocross-compiler-suite=${compiler} --with-gui --with-qt=$QT_INSTALL_DIR
            make -j12
            make check
            make install
            ;;

        #SCORE-P: http://www.vi-hps.org/projects/score-p/
        scorep)
            wget http://www.vi-hps.org/upload/packages/scorep/scorep-1.2.1.tar.gz
            tar -xvzf scorep-1.2.1.tar.gz 
            cd scorep-1.2.1

            ./configure --prefix=$SCOREP_INSTALL_DIR --with-nocross-compiler-suite=${compiler} --with-mpi=mpich3 --with-otf2=$OTF2_INSTALL_DIR/bin --with-opari2=$OPARI2_INSTALL_DIR/bin --with-cube=$CUBE_INSTALL_DIR --with-papi-header=$PAPI_INSTALL_DIR/include --with-papi-lib=$PAPI_INSTALL_DIR/lib
            make -j12
            make check
            make install
            ;;

        #SCALASCA: http://www.scalasca.org/software/scalasca-2.x/download.html
        scalasca)
            wget http://apps.fz-juelich.de/scalasca/releases/scalasca/2.0/dist/scalasca-2.0.tar.gz
            tar -xvzf scalasca-2.0.tar.gz
            cd scalasca-2.0

            ./configure --prefix=$SCALASCA_INSTALL_DIR --with-nocross-compiler-suite=intel --with-mpi=mpich3 --with-otf2=$OTF2_INSTALL_DIR --with-cube=$CUBE_INSTALL_DIR --with-sionconfig=$SION_INSTALL_DIR/bin/sionconfig --with-libz=$ZLIB_INSTALL_DIR
            make -j12 
            make install
    esac

done

