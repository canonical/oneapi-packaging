# oneAPI Packaging for Ubuntu :rocket:

This repo contains Debian package definitions for components from the [oneAPI Base Toolkit](https://www.intel.com/content/www/us/en/developer/tools/oneapi/base-toolkit.html) published to the following PPA:

- [ppa:kobuk-team/oneapi](https://launchpad.net/~kobuk-team/+archive/ubuntu/oneapi)

The packages are currently built for and validated against Ubuntu 25.04 (Plucky) only.

1. [Add the PPA to apt sources](#1-add-the-ppa-to-apt-sources)
2. [Install packages from the PPA](#2-install-packages-from-the-ppa)
3. [Build and run SYCL* applications](#3-build-and-run-sycl-applications)
4. [Intel GPU support](#4-intel-gpu-support)

## 1. Add the PPA to apt sources

```bash
sudo add-apt-repository ppa:kobuk-team/oneapi
sudo apt update
```

## 2. Install packages from the PPA

### 2.1 DPC++ compiler

```bash
sudo apt install clang-dpcpp-20
```

### 2.2 oneDPL library

```bash
sudo apt install onedpl-headers
```

## 3. Build and run SYCL* applications

Applications written in SYCL* C++ can be compiled using the `clang++-dpcpp` command. For example:

```bash
clang++ -fsycl sample.cpp -o simple-sycl-app
./simple-sycl-app
```

## 4. Intel GPU support

To run SYCL* applications with Intel GPU support, please refer to Canonical's [Intel Graphics Preview](https://github.com/canonical/intel-graphics-preview) for steps to install the latest drivers and support libraries on Ubuntu.