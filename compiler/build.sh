#!/bin/bash

# build and install UMF
(cd unified-memory-framework/ && cmake -DUMF_BUILD_LIBUMF_POOL_DISJOINT=ON -DUMF_LEVEL_ZERO_INCLUDE_DIR=/usr/include/level_zero -DUMF_BUILD_CUDA_PROVIDER=OFF -DUMF_BUILD_TESTS=OFF . && make && make install)

# build and install level-zero v1.21.9
(cd level-zero/ && cmake -DCMAKE_INSTALL_PREFIX=/usr/ . && make && make install)

# SPIRV-Headers (the one in Ubuntu does not work) : 
(cd SPIRV-Headers/ && cmake -DCMAKE_INSTALL_PREFIX=/usr/ . && make && make install)

# copy compute-runtime header files
mkdir /usr/include/level_zero/include/
cp compute-runtime/level_zero/include/*h /usr/include/level_zero/include/

rm -rf build
mkdir -p build/_deps/

cp -rf emhash build/_deps/emhash-headers-src
cp -rf parallel-hashmap build/_deps/parallel-hashmap-src

#--cmake-opt="-DLLVM_USE_LINKER=mold" \
#--cmake-opt="-DUR_OPENCL_ICD_LOADER_LIBRARY=OpenCL" \
python3 ./buildbot/configure.py \
         --l0-headers /usr/include/level_zero/ \
         --l0-loader /usr/lib/x86_64-linux-gnu/libze_loader.so \
         --cmake-opt="-DLLVM_PARALLEL_LINK_JOBS=4" \
         --disable-jit \
         --cmake-opt="-DLLVM_ENABLE_RTTI=ON" \
         --cmake-opt="-DLLVM_BUILD_LLVM_DYLIB:BOOL=ON" \
         --cmake-opt="-DSYCL_UR_USE_FETCH_CONTENT=OFF" \
         --cmake-opt="-DLLVMGenXIntrinsics_SOURCE_DIR=$PWD/vc-intrinsics" \
         --cmake-opt="-DFETCHCONTENT_FULLY_DISCONNECTED=ON" \
         --cmake-opt="-DSYCL_UR_SOURCE_DIR=$PWD/unified-runtime" \
         --cmake-opt="-DUR_OPENCL_INCLUDE_DIR=/usr/include/" \
         --cmake-opt="-DUR_USE_EXTERNAL_UMF=ON" \
         --cmake-opt="-DCOMPUTE_RUNTIME_LEVEL_ZERO_INCLUDE=/usr/include/level_zero" \
         --cmake-opt="-DOpenCL_INCLUDE_DIR=/usr/include/" \
         --cmake-opt="-DBOOST_MP11_SOURCE_DIR=$PWD/mp11-boost" \
         --cmake-opt="-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR=/usr/include/" \

python3 ./buildbot/compile.py
