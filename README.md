# oneAPI Packaging for Ubuntu :rocket:

This repo contains Debian package definitions for components from the [oneAPI Base Toolkit](https://www.intel.com/content/www/us/en/developer/tools/oneapi/base-toolkit.html) published to the following PPA:

- [ppa:kobuk-team/oneapi-release](https://launchpad.net/~kobuk-team/+archive/ubuntu/oneapi-release)

The latest packages are built for and validated against Ubuntu 26.04 (Resolute Raccoon).

1. [Enable Intel GPU support](#1-optional-enable-intel-gpu-support)
2. [Add the PPA to apt sources](#2-add-the-ppa-to-apt-sources)
3. [Install packages from the PPA](#3-install-packages-from-the-ppa)
4. [Build and run SYCL* applications](#4-build-and-run-sycl-applications)

## 1. Enable Intel GPU support

To run SYCL* applications with Intel GPU support, ensure you have permissions to the device by adding yourself to the `render` Unix group:

```shell
sudo usermod -a -G render $USER
```

You need to log out and log back for this change to take effect.

## 2. Add the PPA to apt sources

```bash
sudo add-apt-repository ppa:kobuk-team/oneapi-release
sudo apt update
```

## 3. Install packages from the PPA

### 3.1 DPC++ compiler

```bash
sudo apt install clang-dpcpp-21
```

### 3.2 oneDPL library

```bash
sudo apt install onedpl-headers
```

### 3.3 oneDNN library

```bash
sudo apt install libdnnl-sycl3
```

## 4. Build and run SYCL* applications

Applications written in SYCL* C++ can be compiled using the `clang++-dpcpp` command. For example:

```bash
clang++-dpcpp -fsycl sample.cpp -o simple-sycl-app
./simple-sycl-app
```

### 4.1 Build and run SYCL* applications with oneDNN

First make sure to install all the required development packages:

```bash
sudo apt install libdnnl-sycl-dev libtbb-dev ocl-icd-opencl-dev libsycl-dev libclang-dpcpp-common-21-dev
```

Now pass the library names in your compile command, for example:

```bash
clang++-dpcpp -fsycl -ldnnl-sycl -lOpenCL -ltbb sample.cpp -o sample-onednn-sycl-app
./simple-onednn-sycl-app
```

There are also examples available from the `onednn-examples` binary package:

```bash
sudo apt install onednn-examples
cp /usr/lib/onednn/examples/getting_started.cpp .
clang++dpcpp -fsycl -I /usr/lib/onednn/examples -ldnnl-sycl -lOpenCL -ltbb getting_started.cpp -o getting-started
./getting-started gpu
```