#!/bin/bash

VERSION=6.1.0
SRC_FOLDER=llvm-${VERSION}

# sycl compiler (llvm)
if [ ! -d "${SRC_FOLDER}" ]; then
    git clone -b v${VERSION} https://github.com/intel/llvm.git ${SRC_FOLDER}
fi

# UMF tag v0.11.2
git clone -b v0.12.0-dev3 https://github.com/oneapi-src/unified-memory-framework.git ${SRC_FOLDER}/unified-memory-framework/

# unified runtime (on v6.1.0), unified runtime is not bundled into the compiler
git clone -b v0.11.10 https://github.com/oneapi-src/unified-runtime.git ${SRC_FOLDER}/unified-runtime

# level-zero v1.21.9
git clone -b v1.21.9 https://github.com/oneapi-src/level-zero.git ${SRC_FOLDER}/level-zero/

# compute runtime (24.39.31294.12)

# SPIRV-Headers (the one in Ubuntu does not work) :
git clone -b vulkan-sdk-1.4.313.0 https://github.com/KhronosGroup/SPIRV-Headers.git ${SRC_FOLDER}/SPIRV-Headers

# emhash
git clone https://github.com/ktprime/emhash ${SRC_FOLDER}/emhash

# parallel-hashmap
git clone -b v2.0.0 https://github.com/greg7mdp/parallel-hashmap.git  ${SRC_FOLDER}/parallel-hashmap

# mp11-boost
git clone -b boost-1.88.0 https://github.com/boostorg/mp11.git ${SRC_FOLDER}/mp11-boost

# vc-intrinsics

cp build.sh ${SRC_FOLDER}
cd ${SRC_FOLDER}


