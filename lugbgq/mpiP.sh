#installation directory
export MPIP_PATH=$HOME/workarena/systems/lugbgq/softwares/install/profilers/mpiP

module load bbp-dev-prod/1.0.0 

#download and extract mpiP package
wget http://downloads.sourceforge.net/project/mpip/mpiP/mpiP-3.4/mpiP-3.4.tar.gz
tar -xvzf mpiP-3.4.tar.gz
cd mpiP-3.4 

mkdir -p $MPIP_PATH

#install package
CFLAGS="-I/bgsys/drivers/ppcfloor/toolchain/gnu/build-powerpc64-bgq-linux/binutils-2.21.1-build/bfd -I/bgsys/drivers/ppcfloor/toolchain/gnu/gcc-4.4.6/include -I/bgsys/drivers/ppcfloor/toolchain/gnu/gdb-7.1/include" LIBS="-L/bgsys/drivers/ppcfloor/toolchain/gnu/build-powerpc64-bgq-linux/binutils-2.21.1-build/bfd -L$ZLIB_HOME/lib" CC=mpixlc_r CXX=mpixlcxx_r F77=mpixlf77_r ./configure --prefix=$MPIP_PATH

make -j12

make install
