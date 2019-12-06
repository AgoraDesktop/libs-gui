#! /usr/bin/env sh

set -ex

DEP_SRC=$HOME/dependency_source/

install_gnustep_make() {
    cd $DEP_SRC
    git clone https://github.com/gnustep/tools-make.git
    cd tools-make
    if [ -n "$RUNTIME_VERSION" ]
    then
        echo "RUNTIME_VERSION=$RUNTIME_VERSION" > GNUstep.conf
    fi
    ./configure --prefix=$HOME/staging --with-library-combo=$LIBRARY_COMBO --with-user-config-file=$PWD/GNUstep.conf
	make install
    echo Objective-C build flags: `$HOME/staging/bin/gnustep-config --objc-flags`
}

install_ng_runtime() {
    cd $DEP_SRC
    git clone https://github.com/gnustep/libobjc2.git
    cd libobjc2
    git submodule init
    git submodule sync
    git submodule update
    cd ..
    mkdir libobjc2/build
    cd libobjc2/build
    export CC="clang"
    export CXX="clang++"
    export CXXFLAGS="-std=c++11"
    cmake -DTESTS=off -DCMAKE_BUILD_TYPE=RelWithDebInfo -DGNUSTEP_INSTALL_TYPE=NONE -DCMAKE_INSTALL_PREFIX:PATH=$HOME/staging ../
    make install
}

install_libdispatch() {
    cd $DEP_SRC
    git clone https://github.com/ngrewe/libdispatch.git
    mkdir libdispatch/build
    cd libdispatch/build
    export CC="clang"
    export CXX="clang++"
    export LIBRARY_PATH=$HOME/staging/lib;
    export LD_LIBRARY_PATH=$HOME/staging/lib:$LD_LIBRARY_PATH;
    export CPATH=$HOME/staging/include;
    cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo  -DCMAKE_INSTALL_PREFIX:PATH=$HOME/staging ../
    make install
}

install_gnustep_base() {
    export GNUSTEP_MAKEFILES=$HOME/staging/share/GNUstep/Makefiles
    . $HOME/staging/share/GNUstep/Makefiles/GNUstep.sh

    cd $DEP_SRC
    git clone https://github.com/gnustep/libs-base.git
    cd libs-base
    ./configure
    make
    make install
}

mkdir -p $DEP_SRC
if [ $LIBRARY_COMBO = 'ng-gnu-gnu' ]
then
    install_ng_runtime
    install_libdispatch
fi

install_gnustep_make
install_gnustep_base
