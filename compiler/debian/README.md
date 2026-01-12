# Vendored build dependencies

The following packages are vendored as build depenencies for the oneAPI compiler:

- vc-intrinsics
- compute runtime

Both packages are already in Debian and Ubuntu; however, we need to vendor them for the reasons provided below.

## vc-intrinsics

- We need the source for an [in-tree build](https://github.com/intel/vc-intrinsics?tab=readme-ov-file#in-tree-build) of the compiler, but the intel-vc-intrinsics debian package only includes headers. Even with an intel-vc-instrinsics that depends on a newer version of LLVM (see next point), attempting an exteral build with vc-intrinsics results in errors.
- The intel-vc-intrinsics debian package depends on an old version (14) of llvm, whereas the oneAPI LLVM-based compiler is currently based on version 21 of LLVM. This creates conflicts during the build.

[Link](https://launchpad.net/ubuntu/+source/intel-vc-intrinsics) to source package in Launchpad.

## compute runtime level-zero headers

- The compiler requires a very specific version of the headers that does not match what is in the archive
- Headers enable experimental features not included in the level-zero API and are only meant to be consumed by the DPC++ compiler at build-time
- More background and discussion: https://github.com/intel/llvm/issues/20318
- From the discussion in the GitHub link, Intel intends to remove this dependency in a future release of the oneAPI compiler

[Link](https://launchpad.net/ubuntu/+source/intel-compute-runtime) to source package in Launchpad.
