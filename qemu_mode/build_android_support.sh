mkdir build
export CC="/media/jin/4abb279b-6d65-4663-97c2-26987f64673a/home/yuna/LabTes/fuzzing-firmware/termux/android-ndk-r25c/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android30-clang"
export CXX="/media/jin/4abb279b-6d65-4663-97c2-26987f64673a/home/yuna/LabTes/fuzzing-firmware/termux/android-ndk-r25c/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android30-clang++"
export BUILD_DIR=`realpath ./build/`

export TOOLCHAIN="/media/jin/4abb279b-6d65-4663-97c2-26987f64673a/home/yuna/LabTes/fuzzing-firmware/termux/android-ndk-r25c/toolchains/llvm/prebuilt/linux-x86_64"
export QEMU_DIR="/media/jin/4abb279b-6d65-4663-97c2-26987f64673a/home/yuna/LabTes/fuzzing-firmware/termux/AFLplusplus/qemu_mode"

# Kompilasi iconv
wget https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.16.tar.gz
tar zxvf libiconv-1.16.tar.gz
cd libiconv-1.16
./configure --prefix=$BUILD_DIR --host=aarch64-linux-android30  --disable-rpath
make -j 1
make install
cd ..

# Kompilasi libffi:
wget https://github.com/libffi/libffi/releases/download/v3.4.2/libffi-3.4.2.tar.gz
tar zxvf libffi-3.4.2.tar.gz
cd libffi-3.4.2/
./configure --prefix=$BUILD_DIR --host=aarch64-linux-android30
make -j 1
make install
cd ..

# Kompilasi gettext:
wget https://ftp.gnu.org/gnu/gettext/gettext-0.19.tar.gz
tar zxvf gettext-0.19.tar.gz
cd gettext-0.19/
./configure --prefix=$BUILD_DIR --host=aarch64-linux-android30 --disable-threads
make -j 1
make install
cd ..

# Kompilasi glibc
wget https://download-fallback.gnome.org/sources/glib/2.57/glib-2.57.1.tar.xz
tar xvf glib-2.57.1.tar.xz
cd glib-2.57.1/
chmod -w android.cache
CFLAGS="-L$BUILD_DIR/lib -I$BUILD_DIR/include" ./configure --prefix=$BUILD_DIR --host=aarch64-linux-android30 --cache-file=android.cache --with-pcre=no  --enable-libmount=no --with-libiconv=gnu --disable-libelf

make -j 1
make install
cd ..
