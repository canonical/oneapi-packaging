#!/bin/bash

VERSION=6.1.0
SRC_FOLDER=${PWD}/llvm-${VERSION}

# sycl compiler (llvm)
if [ ! -d "${SRC_FOLDER}" ]; then
    git clone -b v${VERSION} --depth 1 https://github.com/intel/llvm.git ${SRC_FOLDER}
fi

# unified runtime
# the compiler at v6.1.0 requires unified runtime v0.11.8
git clone -b v0.11.8 https://github.com/oneapi-src/unified-runtime.git ${SRC_FOLDER}/unified-runtime

# UMF tag v0.10.0, this is required by UR v0.11.8
# (TODO : bump into v0.12.0-dev3)
git clone -b v0.10.0 https://github.com/oneapi-src/unified-memory-framework.git ${SRC_FOLDER}/unified-memory-framework/

# level-zero v1.19.2 (required by UMF v0.10.0)
# TODO : bump to v1.21.9
git clone -b v1.19.2 https://github.com/oneapi-src/level-zero.git ${SRC_FOLDER}/level-zero/

# compute runtime (24.39.31294.12), required by unified runtime (UR)
# unified runtimes only needs level-zero headers that are part of the compute-runtime (level_zero/include)
git clone -b 24.39.31294.12 https://github.com/intel/compute-runtime.git ${SRC_FOLDER}/compute-runtime/

# SPIRV-Headers (the one in Ubuntu does not work) :
git clone -b vulkan-sdk-1.4.313.0 https://github.com/KhronosGroup/SPIRV-Headers.git ${SRC_FOLDER}/SPIRV-Headers

# emhash
git clone https://github.com/ktprime/emhash ${SRC_FOLDER}/emhash

# parallel-hashmap
git clone -b v2.0.0 https://github.com/greg7mdp/parallel-hashmap.git  ${SRC_FOLDER}/parallel-hashmap

# mp11-boost
git clone -b boost-1.88.0 https://github.com/boostorg/mp11.git ${SRC_FOLDER}/mp11-boost

# vc-intrinsics
git clone -b dpcpp_staging https://github.com/intel/vc-intrinsics.git ${SRC_FOLDER}/vc-intrinsics

cp build.sh ${SRC_FOLDER}

cd ${SRC_FOLDER}
rm .gitignore

patch -p1 < ../sycl-0001-ubuntu-sauce.patch
patch -p1 < ../sycl-0002-clang-SYCL-Disable-float128-device-mode-diagnostic.patch

cd unified-runtime
patch -p1 < ../../ur-0001-fix-opencl-lib.patch

cd ${SRC_FOLDER}
