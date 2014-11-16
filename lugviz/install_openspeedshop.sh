#installation directories
export BASE_PATH=$HOME/workarena/systems/lugviz/softwares/tmp
export OSS_INSTALL_DIR=$BASE_PATH/install/profilers/
 
#setup directories
mkdir -p $BASE_PATH/sources/profilers
mkdir -p $BASE_PATH/install/profilers
mkdir -p $OSS_INSTALL_DIR
 
#load mpi, must be GNU module
module load mvapich2/1.9-gcc-4.4.7
module load python/2.7.5 
  
cd $BASE_PATH/sources/profilers
 
#download openss source code
wget http://sourceforge.net/projects/openss/files/openss/openspeedshop-2.1/openspeedshop-release-2.1.tar.gz
  
tar -xvzf openspeedshop-release-2.1.tar.gz 
cd openspeedshop-release-2.1

export COMMON_LIBS_PATH=/gpfs/bbp.cscs.ch/home/kumbhar/workarena/systems/lugviz/softwares/install/commonlibs
export PATH=$PATH:$COMMON_LIBS_PATH/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$COMMON_LIBS_PATH/lib
export CFLAGS="-I$COMMON_LIBS_PATH/include"
export CPPLAGS="-I$COMMON_LIBS_PATH/include"

#this builds fine without any issues, I am using this installation
#./install-tool --build-offline --openss-prefix $OSS_INSTALL_DIR/oss_v2.1 --with-mvapich2 $MPI_ROOT 
  
./install-tool --build-all --cbtf-prefix $OSS_INSTALL_DIR/cbtf_only_v1.1 --krell-root-prefix $OSS_INSTALL_DIR/krellroot_v2.1 --openss-prefix $OSS_INSTALL_DIR/osscbtf_v2.1 --with-mvapich2 $MPI_ROOT  2>&1 | tee build_all.log
