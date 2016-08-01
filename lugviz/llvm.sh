clone_or_pull() {

    directory=$1
    repo_url=$2

    if [ ! -d "$directory" ]; then
        echo "Cloning repository : $repo_url"
        git clone $repo_url
    else
        echo "Pulling changes from repository : $repo_url"
        cd $directory
        git pull
        cd -
    fi

}

LLVM=`pwd`/llvm

clone_or_pull "llvm" "http://llvm.org/git/llvm.git"

cd $LLVM/tools
clone_or_pull "clang" "http://llvm.org/git/clang.git"

cd $LLVM/projects
clone_or_pull "compiler-rt" "http://llvm.org/git/compiler-rt.git"
clone_or_pull "openmp" "http://llvm.org/git/openmp.git"
clone_or_pull "libcxx" "http://llvm.org/git/libcxx.git"
clone_or_pull "libcxxabi" "http://llvm.org/git/libcxxabi.git"
clone_or_pull "test-suite" "http://llvm.org/git/test-suite.git"

cd $LLVM
mkdir -p build-make
cd build-make

cmake .. -DCMAKE_INSTALL_PREFIX=/Users/kumbhar/workarena/repos/ext/llvm-home/install
make -j12
make install
