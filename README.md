# oneAPI Packaging for Ubuntu :rocket:

This repo contains Debian package definitions for components from the [oneAPI Base Toolkit](https://www.intel.com/content/www/us/en/developer/tools/oneapi/base-toolkit.html) published to the following PPA:

- [ppa:kobuk-team/oneapi](https://launchpad.net/~kobuk-team/+archive/ubuntu/oneapi)

The latest packages are built for and validated against Ubuntu 25.10 (Questing Quokka).

1. [(Optional) Enable Intel GPU support](#1-optional-enable-intel-gpu-support)
2. [Add the PPA to apt sources](#2-add-the-ppa-to-apt-sources)
3. [Install packages from the PPA](#3-install-packages-from-the-ppa)
4. [Build and run SYCL* applications](#4-build-and-run-sycl-applications)

## 1. (Optional) Enable Intel GPU support

To run SYCL* applications with Intel GPU support, ensure you have permissions to the device by adding yourself to the `render` Unix group:

```shell
sudo usermod -a -G render $USER
```

You need to log out and log back for this change to take effect.

## 2. Add the PPA to apt sources

```bash
sudo add-apt-repository ppa:kobuk-team/oneapi
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

## 4. Build and run SYCL* applications

Applications written in SYCL* C++ can be compiled using the `clang++-dpcpp` command. For example:

```bash
clang++-dpcpp -fsycl sample.cpp -o simple-sycl-app
./simple-sycl-app
```
