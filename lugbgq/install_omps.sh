#!/bin/bash

##BBP-EPFL

set -e

#
#package_names=(binutils sqlite gperf extrae nanox mcxx)
package_names=(extrae nanox mcxx)

#LOAD DEFAULT MODULES: FOR GNU COMPILER
module load bbp-dev-prod/1.1.0 zlib/1.2.3 libxml2/2.7.6 papi/5.2.0

#@TODO: default libxml module fails, we have to set local one
export LIBXML2_ROOT=/gpfs/bbp.cscs.ch/home/kumbhar/workarena/systems/lugbgq/softwares/install/progmodels/ompss/

###JUST FOR INFO#####
#[kumbhar@bgq1 ~]$ mpicc -compile-info
#/bgsys/drivers/toolchain/V1R2M1_base/gnu-linux/bin/powerpc64-bgq-linux-gcc -I/bgsys/drivers/V1R2M1/ppc64/comm/include -I/bgsys/drivers/V1R2M1/ppc64/comm/lib/gnu -I/bgsys/drivers/V1R2M1/ppc64 -I/bgsys/drivers/V1R2M1/ppc64/comm/sys/include -I/bgsys/drivers/V1R2M1/ppc64/spi/include -I/bgsys/drivers/V1R2M1/ppc64/spi/include/kernel/cnk -L/bgsys/drivers/V1R2M1/ppc64/comm/lib -L/bgsys/drivers/V1R2M1/ppc64/comm/lib -L/bgsys/drivers/V1R2M1/ppc64/comm/lib64 -L/bgsys/drivers/V1R2M1/ppc64/comm/lib -L/bgsys/drivers/V1R2M1/ppc64/spi/lib -L/bgsys/drivers/V1R2M1/ppc64/comm/sys/lib -L/bgsys/drivers/V1R2M1/ppc64/spi/lib -L/bgsys/drivers/V1R2M1/ppc64/comm/sys/lib -L/bgsys/drivers/V1R2M1/ppc64/comm/lib64 -L/bgsys/drivers/V1R2M1/ppc64/comm/lib -L/bgsys/drivers/V1R2M1/ppc64/spi/lib -I/bgsys/drivers/V1R2M1/ppc64/comm/include -L/bgsys/drivers/V1R2M1/ppc64/comm/lib -lmpich-gcc -lopa-gcc -lmpl-gcc -lpami-gcc -lSPI -lSPI_cnk -lrt -lpthread -lstdc++ -lpthread


#DIRECTORY UNDER WHICH ALL SOFTWARES WILL BE DOWNLOADED AND INSTALLED
export INSTALL_DIR=/gpfs/bbp.cscs.ch/home/kumbhar/workarena/systems/lugbgq/softwares/install/progmodels/ompss
export SOURCE_DIR=/gpfs/bbp.cscs.ch/home/kumbhar/workarena/systems/lugbgq/softwares/sources/progmodels/ompss

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
        
    export BINUTILS_INSTALL_DIR=$install_dir
    export GPERF_INSTALL_DIR=$install_dir
    export SQLITE_INSTALL_DIR=$install_dir

    echo "Installing package ${package^^} under ${install_dir}"

    #INSTALLATION OF INDIVIDUAL PACKAGE:
        #DOWNLOAD AND EXTRACT
        #CONFIGURE
        #MAKE AND MAKE INSTALL

    case "$package" in

    #BINUTILS
    binutils)
        wget http://ftp.gnu.org/gnu/binutils/binutils-2.23.2.tar.bz2
        tar -xvjf binutils-2.23.2.tar.bz2
        
        #CHECK /home/vlopez/build/binutils-2.23.2/config.log, frontend compilers
        cd binutils-2.23.2
        ./configure --prefix=$install_dir
        make -j12
        make install           
        
        #BINUTILS NOW INSTALLED!
        export BINUTILS_INSTALL_DIR=/bgsys/linux/RHEL6.4_V1R2M1/usr
        ;;

    #Sqlite
    sqlite)
        
        wget http://www.sqlite.org/2013/sqlite-autoconf-3080100.tar.gz
        tar -xvzf sqlite-autoconf-3080100.tar.gz
        #CHECK /home/vlopez/build/gperf-3.0.4/lib/Makefile, fronted compilers
        cd sqlite-autoconf-3080100
        ./configure --prefix=$install_dir --enable-shared=no
        make -j6
        make install
        ;;

    #gperf
    gperf)
        #CHECK /home/vlopez/build/gperf-3.0.4/src/Makefile, fronted compilers, WHY?     
        wget http://ftp.gnu.org/pub/gnu/gperf/gperf-3.0.4.tar.gz
        tar -xvzf gperf-3.0.4.tar.gz
        cd gperf-3.0.4
        ./configure --prefix=$install_dir  CC=/bgsys/drivers/ppcfloor/gnu-linux/bin/powerpc64-bgq-linux-gcc CXX=/bgsys/drivers/ppcfloor/gnu-linux/bin/powerpc64-bgq-linux-g++
        make -j12
        make install
        ;;

    #extrae-2.4.1
    extrae)

        #cp $HOME/softwares/sources/extrae-2.4.1.tar.bz2  .
        #tar -xvjf extrae-2.4.1.tar.bz2
        #tar -xvjf extrae-3.0.1.tar.bz2
        cd extrae-3.0.1
 
        #./configure --prefix=$install_dir --with-mpi=/bgsys/drivers/ppcfloor/comm/gcc --with-mpi-libs=/bgsys/drivers/ppcfloor/comm/gcc/../lib --without-unwind --without-dyninst --with-libz=$ZLIB_ROOT --with-xml-prefix=$LIBXML2_ROOT --enable-merge-in-trace --disable-openmp --with-binutils=$BINUTILS_INSTALL_DIR --with-papi=$PAPI_ROOT CC=/bgsys/drivers/ppcfloor/gnu-linux/bin/powerpc64-bgq-linux-gcc CXX=/bgsys/drivers/ppcfloor/gnu-linux/bin/powerpc64-bgq-linux-g++ FC=/bgsys/drivers/ppcfloor/gnu-linux/bin/powerpc64-bgq-linux-gfortran MPICC=/bgsys/drivers/ppcfloor/comm/gcc/bin/mpicc
        #./configure --prefix=$install_dir --with-mpi=/bgsys/drivers/ppcfloor/comm/gcc --with-mpi-libs=/bgsys/drivers/ppcfloor/comm/gcc/../lib --without-unwind --without-dyninst --with-libz=$ZLIB_ROOT --with-xml-prefix=$LIBXML2_ROOT --enable-merge-in-trace --disable-openmp --with-binutils=/home/kumbhar/softwarestest/install/binutils_ --with-papi=$PAPI_ROOT CC=/bgsys/drivers/ppcfloor/gnu-linux/bin/powerpc64-bgq-linux-gcc CXX=/bgsys/drivers/ppcfloor/gnu-linux/bin/powerpc64-bgq-linux-g++ FC=/bgsys/drivers/ppcfloor/gnu-linux/bin/powerpc64-bgq-linux-gfortran MPICC=/bgsys/drivers/ppcfloor/comm/gcc/bin/mpicc
        #make -j12
        #make install
        ;;

    nanox)
        git clone http://pm.bsc.es/git/nanox.git nanox-git
        cd nanox-git
        autoreconf -f -i -v
 
        ./configure --host=powerpc64-bgq-linux --prefix=$install_dir --with-extrae=$EXTRAE_INSTALL_DIR --disable-silent-rules CC=/bgsys/drivers/ppcfloor/gnu-linux/bin/powerpc64-bgq-linux-gcc CXX=/bgsys/drivers/ppcfloor/gnu-linux/bin/powerpc64-bgq-linux-g++ --disable-allocator --enable-bgq CPPFLAGS="-I/bgsys/drivers/V1R2M1/ppc64/comm/include -I/bgsys/drivers/V1R2M1/ppc64/comm/lib/gnu -I/bgsys/drivers/V1R2M1/ppc64 -I/bgsys/drivers/V1R2M1/ppc64/comm/sys/include -I/bgsys/drivers/V1R2M1/ppc64/spi/include -I/bgsys/drivers/V1R2M1/ppc64/spi/include/kernel/cnk" --enable-bgq
        make -j12
        make install
        ;;

    mcxx)

        git clone http://pm.bsc.es/git/mcxx.git mcxx-git
        cd mcxx-git
        autoreconf -f -i -v
 
        mkdir build
        cd build
 
        export PATH=/bgsys/drivers/toolchain/V1R2M1/gnu-linux/bin:$PATH
        export PATH=/bgsys/drivers/ppcfloor/comm/gcc/bin:$PATH
        ../configure --target=powerpc64-bgq-linux --prefix=$install_dir --enable-ompss --with-nanox=$NANOX_INSTALL_DIR PKG_CONFIG_PATH=$SQLITE_INSTALL_DIR/lib/pkgconfig GPERF=$GPERF_INSTALL_DIR/bin/gperf target_alias=powerpc64-bgq-linux
 
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


