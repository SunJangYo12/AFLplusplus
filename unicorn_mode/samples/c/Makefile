UNICORNAFL_LIB = ../../unicornafl/build
UNICORN_LIB = ../../unicornafl/build/unicorn

CC = /media/jin/4abb279b-6d65-4663-97c2-26987f64673a/home/yuna/LabTes/fuzzing-firmware/termux/android-ndk-r25c/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android30-clang

CFLAGS += -Wall -Werror -I../../unicornafl/unicorn/include -I../../unicornafl/include
LDFLAGS += -L$(UNICORNAFL_LIB) -L$(UNICORN_LIB) -lunicorn -lunicornafl -pthread -lm -lstdc++

.PHONY: all clean

all: harness

clean:
	rm -rf *.o harness

harness.o:
	${CC} ${CFLAGS} -O3 -c harness.c

harness: harness.o
	${CC} harness.o ../../unicornafl/build/libunicornafl.so $(LDFLAGS) -o $@

fuzz: harness
	LD_LIBRARY_PATH="../../unicornafl/unicorn/build" ../../../afl-fuzz -m none -i sample_inputs -o out -- ./harness @@
