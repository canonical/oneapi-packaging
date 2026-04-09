# oneAPI Packaging for Ubuntu :rocket:

This repo contains Debian package definitions for components from the [oneAPI Base Toolkit](https://www.intel.com/content/www/us/en/developer/tools/oneapi/base-toolkit.html). These packages are built from open source implementations, which may differ in functionality from the closed sourced versions provided by Intel.

The packages are available directly from the Ubuntu archive beginning in Ubuntu 26.04 (Resolute Raccoon).

1. [Enable Intel GPU support](#1-optional-enable-intel-gpu-support)
2. [Install packages from the Ubuntu archive](#2-install-packages-from-the-ubuntu-archive)
3. [Build and run SYCL* applications](#3-build-and-run-sycl-applications)

> [!IMPORTANT]
>
> This repo is intended for development of new package definitions. Once packages have landed in the Ubuntu archive, the source of truth for these packages is Launchpad.

## 1. Enable Intel GPU support

To run SYCL* applications with Intel GPU support, ensure you have permissions to the device by adding yourself to the `render` Unix group:

```shell
sudo usermod -a -G render $USER
```

You need to log out and log back in for this change to take effect.

## 2. Install packages from the Ubuntu archive

### 2.1 DPC++ compiler

```bash
sudo apt install dpclang-6
```

### 2.2 oneDPL library

```bash
sudo apt install onedpl-headers
```

### 2.3 oneDNN library

```bash
sudo apt install libdnnl-sycl3
```

## 3. Build and run SYCL* applications

This section briefly describes the basics of getting started with these tools and libraries on Ubuntu. Please refer to Intel documentation for a more complete guide.

Applications written in SYCL* C++ can be compiled using the `dpclang++` command. For example:

```bash
dpclang++ -fsycl sample.cpp -o simple-sycl-app
./simple-sycl-app
```

This command will also work if `sample.cpp` contains references to header files from the oneDPL library, assuming you have the `onedpl-headers` package installed.

### 3.1 Build and run SYCL* applications with oneDNN

To build with oneDNN support, install the oneDNN-SYCL development package and optionally other common development packages

```bash
sudo apt install libdnnl-sycl-dev
sudo apt install libtbb-dev ocl-icd-opencl-dev # optional
```

Now pass the library names in your compile command (this example assumes your application also uses OpenCL and oneTBB), for example:

```bash
dpclang++ -fsycl -ldnnl-sycl -lOpenCL -ltbb sample.cpp -o sample-onednn-sycl-app
./simple-onednn-sycl-app
```

CMake configuration files are delivered by the `libdnnl-sycl-dev` package to support applications built with CMake.

Finally, there are examples available from the `onednn-examples` binary package that can be used as a helpful reference for application developers:

```bash
sudo apt install onednn-examples
cp /usr/lib/onednn/examples/getting_started.cpp .
dpclang++ -fsycl -I /usr/lib/onednn/examples -ldnnl-sycl -lOpenCL -ltbb getting_started.cpp -o getting-started
./getting-started gpu
```
