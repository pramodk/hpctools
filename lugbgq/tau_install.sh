wget http://www.cs.uoregon.edu/research/paracomp/pdtoolkit/Download/pdt_latest.tar.gz 

wget http://www.cs.uoregon.edu/research/paracomp/tau/tauprofile/dist/tau_latest.tar.gz

#pdt

./configure -XLC -prefix=/gpfs/bbp.cscs.ch/home/kumbhar/workarena/systems/lugbgq/softwares/install/profilers/tau
make install



#tau with pdt

./configure -arch=bgq -mpi -pdt=/gpfs/bbp.cscs.ch/home/kumbhar/workarena/systems/lugbgq/softwares/install/profilers/tau -pdt_c++=xlC  -papi=/gpfs/bbp.cscs.ch/apps/bgq/external/papi/papi-5.2.0/install -prefix=/gpfs/bbp.cscs.ch/home/kumbhar/workarena/systems/lugbgq/softwares/install/profilers/tau -openmp -opari -unwind=download -bfd=download 
make install -j12 VERBOSE=1


#make install

#export TAU_MAKEFILE=~/workarena/systems/lugbgq/softwares/install/profilers/tau/bgq/lib/Makefile.tau-papi-mpi-openmp-opari-trace 
#export PATH=$PATH:/gpfs/bbp.cscs.ch/home/kumbhar/workarena/systems/lugbgq/softwares/install/profilers/tau/bgq/bin/




