# ===============================================
# Compile afl-showmap & afl-fuzz
# Author: Eric Le Guevel & sunjangyo12
# Date: 2023-03-28
# ===============================================

project(AFLppAndroid)
cmake_minimum_required(VERSION 3.13)

add_compile_options(
    -Wno-pointer-sign
    -Wno-pointer-arith
    -Wno-sign-compare
    -Wno-unused-parameter
    -Wno-unused-function
    -Wno-format
    -Wno-user-defined-warnings
    -Wno-macro-redefined
    -Wno-deprecated
)

# ========
# afl-showmap
# ========

file(GLOB afl-showmap-c src/afl-showmap.c)

add_executable(
    afl-showmap
    ${afl-showmap-c}
    "src/afl-common.c"
    "src/afl-forkserver.c"
    "src/afl-sharedmem.c"
    "src/afl-performance.c"
    "src/afl-fuzz-mutators.c"
)

target_include_directories(afl-showmap AFTER PRIVATE ${CMAKE_SOURCE_DIR}/include)

target_compile_definitions(
    afl-showmap
    PRIVATE DOC_PATH=\"/usr/local/share/doc/afl\"
    PRIVATE BIN_PATH=\"/usr/local/bin\"
    PRIVATE AFL_PATH=\"/usr/local/lib/afl\"
    PRIVATE _FORTIFY_SOURCE=2
)

set_target_properties(afl-showmap PROPERTIES POSITION_INDEPENDENT_CODE ON)
set_target_properties(afl-showmap PROPERTIES COMPILE_FLAGS "-O2")



# ========
# afl-fuzz
# ========

file(GLOB afl-fuzz-c src/afl-fuzz*.c)

add_definitions(-U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=0)

add_executable(
    afl-fuzz
    ${afl-fuzz-c}
    "src/afl-common.c"
    "src/afl-forkserver.c"
    "src/afl-sharedmem.c"
    "src/afl-performance.c"
)

target_include_directories(afl-fuzz AFTER PRIVATE ${CMAKE_SOURCE_DIR}/include)

target_compile_definitions(
    afl-fuzz
    PRIVATE DOC_PATH=\"/usr/local/share/doc/afl\"
    PRIVATE BIN_PATH=\"/usr/local/bin\"
    PRIVATE AFL_PATH=\"/usr/local/lib/afl\"
    PRIVATE _FORTIFY_SOURCE=2
)

set_target_properties(afl-fuzz PROPERTIES POSITION_INDEPENDENT_CODE ON)
set_target_properties(afl-fuzz PROPERTIES COMPILE_FLAGS "-O2")

