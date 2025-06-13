#############
# by https://alephsecurity.com
#############

mkdir build
echo "=================="
echo "Creating build folder."
echo "=================="
sleep 2
export CC="/media/jin/4abb279b-6d65-4663-97c2-26987f64673a/home/yuna/LabTes/fuzzing-firmware/termux/android-ndk-r25c/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android30-clang"
export CXX="/media/jin/4abb279b-6d65-4663-97c2-26987f64673a/home/yuna/LabTes/fuzzing-firmware/termux/android-ndk-r25c/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android30-clang++"
export BUILD_DIR=`realpath ./build/`

export TOOLCHAIN="/media/jin/4abb279b-6d65-4663-97c2-26987f64673a/home/yuna/LabTes/fuzzing-firmware/termux/android-ndk-r25c/toolchains/llvm/prebuilt/linux-x86_64"
export QEMU_DIR="/media/jin/4abb279b-6d65-4663-97c2-26987f64673a/home/yuna/LabTes/fuzzing-firmware/termux/AFLplusplus/qemu_mode"




function build_iconv() {
#wget https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.16.tar.gz
tar zxf libiconv-1.16.tar.gz
cd libiconv-1.16
./configure --prefix=$BUILD_DIR --host=aarch64-linux-android30  --disable-rpath
make -j 1
make install
cd ..
echo;echo "=================="
echo "build iconv done."
echo "=================="
read -p "Press Enter to continue"
}

function build_ffi() {
#wget https://github.com/libffi/libffi/releases/download/v3.4.2/libffi-3.4.2.tar.gz
tar zxf libffi-3.4.2.tar.gz
cd libffi-3.4.2/
./configure --prefix=$BUILD_DIR --host=aarch64-linux-android30
make -j 1
make install
cd ..
echo;echo "=================="
echo "build libffi done."
echo "=================="
read -p "Press Enter to continue"
}

function build_gettext() {
#wget https://ftp.gnu.org/gnu/gettext/gettext-0.19.tar.gz
tar zxf gettext-0.19.tar.gz
cd gettext-0.19/
./configure --prefix=$BUILD_DIR --host=aarch64-linux-android30 --disable-threads
make -j 1
make install
cd ..
echo;echo "=================="
echo "build gettext done."
echo "=================="
read -p "Press Enter to continue"
}


function build_glib() {
#wget https://download.gnome.org/sources/glib/2.57/glib-2.57.1.tar.xz
tar xf glib-2.57.1.tar.xz
cd glib-2.57.1; cp ../android.cache .
chmod -w android.cache
CFLAGS="-L$BUILD_DIR/lib -I$BUILD_DIR/include" ./configure --prefix=$BUILD_DIR --host=aarch64-linux-android30 --cache-file=android.cache --with-pcre=no  --enable-libmount=no --with-libiconv=gnu --disable-libelf
make -j 1
make install
cd ..
echo;echo "=================="
echo "build glibc done."
echo "=================="
read -p "Press Enter to continue"
}

#build_iconv
#build_ffi
#build_gettext
#build_glib

#(cd $QEMU_DIR ; sudo --preserve-env=CC,CXX PATH=$PATH:$TOOLCHAIN/bin NO_CHECKOUT=1 HOST=aarch64-linux-android30 PKG_CONFIG_PATH=$BUILD_DIR/lib/pkgconfig CPU_TARGET=aarch64 CROSS=$CC  ./build_qemu_support.sh)
(cd $QEMU_DIR ; sudo --preserve-env=CC,CXX PATH=$PATH:$TOOLCHAIN/bin NO_CHECKOUT=1 PKG_CONFIG_PATH=$BUILD_DIR/lib/pkgconfig CPU_TARGET=aarch64 CROSS=$CC  ./build_qemu_support.sh)
