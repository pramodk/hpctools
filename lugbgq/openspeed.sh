#!/bin/bash 

set -e

krell_prefix=/gpfs/bbp.cscs.ch/home/kumbhar/workarena/systems/lugbgq/softwares/install/profilers/openspeedshop/oss-dev/bgq/krellroot_v2.1
oss_prefix=/gpfs/bbp.cscs.ch/home/kumbhar/workarena/systems/lugbgq/softwares/install/profilers/openspeedshop/oss-dev/bgq/ossoff_v2.1

#rm -rf /gpfs/bbp.cscs.ch/home/kumbhar/workarena/systems/lugbgq/softwares/install/profilers/openspeedshop/*

krell_prefix_bgq=$krell_prefix/bgq
oss_prefix_bgq=$oss_prefix/bgq

mkdir -p oss_latest
cd oss_latest

#wget http://sourceforge.net/projects/openss/files/openss/openspeedshop-2.1/rc2-openspeedshop-release-2.1-u3.tar.gz
#tar -xvzf rc2-openspeedshop-release-2.1-u3.tar.gz
#cd openspeedshop-release-2.1

#Nov 5th
wget http://sourceforge.net/projects/openss/files/openss/openspeedshop-2.1/openspeedshop-release-2.1-u5.tar.gz
tar -xvzf openspeedshop-release-2.1-u5.tar.gz
cd openspeedshop-release-2.1

./install-tool --runtime-only --target-shared --target-arch bgq --build-krell-root --krell-root-prefix $krell_prefix_bgq --with-mpich2 /bgsys/drivers/V1R2M1/ppc64/comm --force-binutils-build
./install-tool --runtime-only --target-shared --target-arch bgq --build-offline --openss-prefix $oss_prefix_bgq --krell-root-prefix $krell_prefix_bgq --with-mpich2 /bgsys/drivers/V1R2M1/ppc64/comm

# Next build the OSS vulcan front-end node portion of OSS: (use --with-runtime-dir option -> oss compute node install path)
./install-tool --build-krell-root --krell-root-prefix $krell_prefix --with-mpich2 /bgsys/drivers/V1R2M1/ppc64/comm
./install-tool --build-offline --openss-prefix $oss_prefix --krell-root-prefix $krell_prefix --with-mpich2 /bgsys/drivers/V1R2M1/ppc64/comm --with-runtime-dir $oss_prefix_bgq


export OSS_BASE=$HOME/workarena/systems/lugbgq/softwares/install/profilers/openspeedshop/oss-dev/bgq

export PATH=$PATH:$OSS_BASE/krellroot_v2.1/bgq/bin:$OSS_BASE/krellroot_v2.1/bin
export PATH=$PATH:$OSS_BASE/ossoff_v2.1/bgq/bin:$OSS_BASE/ossoff_v2.1/bin

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$OSS_BASE/krellroot_v2.1/bgq/lib64:$OSS_BASE/krellroot_v2.1/lib64
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$OSS_BASE/ossoff_v2.1/bgq/lib64:$OSS_BASE/ossoff_v2.1/lib64

STR=$"Set following Paths: \n\n export PATH=$PATH \n\n export LD_LIBRARY_PATH=$LD_LIBRARY_PATH \n\n"

echo $STR
