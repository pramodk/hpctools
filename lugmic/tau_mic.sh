
#install on dommic

module load icc impi

#on mic
./configure -arch=mic_linux -cc=mpiicc -c++=mpiicpc     -prefix=/users/kumbhar/workarena/softwares/install/mic/tau_mpi_pdt_opari  -iowrapper -pdt=/users/kumbhar/workarena/softwares/install/mic/pdt -pdt_c++=mpiicpc  -mpi -mpiinc=/apps/dommic/intel/impi/4.1.3.048/mic/include -mpilib=/apps/dommic/intel/impi/4.1.3.048/mic/lib  -papi=/users/kumbhar/papi-5.3.0/mic 

make -j12 VERBOSE=1
make install

export TAU_MAKEFILE=~/workarena/softwares/install/mic/tau_mpi_pdt_opari/mic_linux/lib/Makefile.tau-icpc-papi-mpi-pdt
export PATH=/users/kumbhar/workarena/softwares/install/mic/tau_mpi_pdt_opari/mic_linux/bin:$PATH


#on x86
./configure -cc=mpiicc -c++=mpiicpc     -prefix=/users/kumbhar/workarena/softwares/install/x86/tau_mpi_pdt_opari  -iowrapper -pdt=/users/kumbhar/workarena/softwares/install/x86/pdt -pdt_c++=mpiicpc  -mpi -mpiinc=/apps/dommic/intel/impi/4.1.3.048/intel64/include -mpilib=/apps/dommic/intel/impi/4.1.3.048/intel64/lib -unwind=download -bfd=download -papi=/users/kumbhar/papi-5.3.0/x86 -opari -mpilibrary=-lmpi_mt
make install

