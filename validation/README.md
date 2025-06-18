# Validation using upstream packages

## System Requirements

Hardware and software requirements for using oneAPI are described [here](https://www.intel.com/content/www/us/en/developer/articles/system-requirements/oneapi-base-toolkit/2025.html).


## Install upstream packages and set up environment

Instructions from Intel can be found [here](https://www.intel.com/content/www/us/en/developer/tools/oneapi/base-toolkit-download.html?packages=oneapi-toolkit&oneapi-toolkit-os=linux&oneapi-lin=apt).

The steps for installing the Debian repo from Intel are in `install-upstream-repo.sh`. Thus, if you want to install all of the oneAPI Base Toolkit packages from Intel you can simply run:

```bash
./install-upstream-repo.sh
sudo apt install intel-oneapi-base-toolkit
. /opt/intel/oneapi/setvars.sh
```

## Install packages from PPA

TODO

## Install Intel graphics support (OpenCL and Level-Zero backends)

Run the [`setup-intel-graphics.sh` script](https://github.com/canonical/intel-graphics-preview/blob/main/setup-intel-graphics.sh) to install packages from the `intel graphics` PPA:

```bash
git clone https://github.com/canonical/intel-graphics-preview.git
cd intel-graphics-preview
./setup-intel-graphics.sh
```

Verify that the backends are detected. For example:

```bash
$ sycl-ls
[level_zero:gpu][level_zero:0] Intel(R) oneAPI Unified Runtime over Level-Zero, Intel(R) Arc(TM) B580 Graphics 20.1.0 [1.6.33578+11]
[opencl:cpu][opencl:0] Intel(R) OpenCL, 13th Gen Intel(R) Core(TM) i9-13900K OpenCL 3.0 (Build 0) [2025.19.4.0.18_160000.xmain-hotfix]
[opencl:gpu][opencl:1] Intel(R) OpenCL Graphics, Intel(R) Arc(TM) B580 Graphics OpenCL 3.0 NEO  [25.18.33578]
```

## Samples

Code samples come from the [2025.1 release of oneAPI-samples](https://github.com/oneapi-src/oneAPI-samples/tree/2025.1.0). The samples assume the upstream packages are being used. To validate against PPA packages you should update the name of the compiler in the build scripts.

Only a subset of the code samples from the `oneAPI-samples` repo are coped in to this repo for now as we focus on validating just the compiler on Intel hardware.