Build using docker image
---

```bash
docker build -t oneapi-compiler-build -f Dockerfile.build .
docker build -t oneapi-compiler -f Dockerfile.compiler .
```

Build samples
---

```bash
cd samples
docker run -v $PWD:/src -it oneapi-compiler bash

cd /src/
```

### sample.cpp
```bash
clang++ -fsycl sample.cpp -o simple-sycl-app
```

### mandelbrot
```bash
cd mandelbrot
CXXFLAGS=-isystem\ /src/common/ cmake .
make
```

Build using multipass
---

```
sudo snap install multipass
```

Select the version of Ubuntu you are targeting and adjust the command based on resources available on host:

```bash
multipass launch --cpus 16 --memory 24G --disk 50G --name plucky 25.04

# Or for 25.10 (questing):
#multipass launch --cpus 16 --memory 24G --disk 50G --name questing 25.10
```

Now shell in and build the compiler. The first command assumes you are using a Plucky (25.04) Multipass VM.

```bash
multipass shell plucky
git clone -b develop/kobuk https://github.com/canonical/oneapi-packaging.git
cd oneapi-packaging/compiler
./fetch.sh
sudo ./scripts/install_build_tools.sh
cd llvm-6.1.0
sudo ./build.sh
```

## Transfer build artifacts to the host

This assumes your Multipass VM is based on Plucky (25.04).

```bash
multipass transfer -r plucky:/home/ubuntu/oneapi-packaging/compiler/llvm-6.1.0/build /home/ubuntu/oneapi-build
```

## Build and run samples (on the host)

### Update search paths

First set up your search paths to find the DPC++ compiler and libraries:

```bash
export PATH=/home/ubuntu/oneapi-build/bin:$PATH
export LD_LIBRARY_PATH=/home/ubuntu/oneapi-build/lib:$LD_LIBRARY_PATH
```

### Clone repo

If you have not done so already on the host:

```bash
git clone -b develop/kobuk https://github.com/canonical/oneapi-packaging.git
```

### Simple SYCL app

This first example hard-codes the type of device, so in order to run successfully `sycl-ls` should show a `HD Graphics NEO` device type. You can also modify the device type manually and re-build as this is a very simple application.

```bash
cd /home/ubuntu/oneapi-packaging/compiler/samples
clang++ -fsycl sample.cpp -o simple-sycl-app
./simple-sycl-app
```

### Mandelbrot

For the next example you may need to first install a OpenCL development package from the archive that provides the `libOpenCL.so` sym link:

```bash
sudo apt install -y ocl-icd-opencl-dev
```

Now build and run:

```bash
cd /home/ubuntu/oneapi-packaging/compiler/samples/mandebrot
CXXFLAGS="-isystem /home/ubuntu/oneapi-packaging/compiler/samples/common" cmake .
make
cd src
./mandelbrot
./mandelbrot_usm
```

### Vector addition

* Buffer-based implementation:

```bash
cd /home/ubuntu/oneapi-packaging/validation/2025.1/DirectProgramming/C++SYCL/DenseLinearAlgebra/vector-add
mkdir build
cd build
cmake ..
make cpu-gpu
./vector-add-buffers
```

* Unified shared memory (USM) implementation

```bash
cd /home/ubuntu/oneapi-packaging/validation/2025.1/DirectProgramming/C++SYCL/DenseLinearAlgebra/vector-add
mkdir build
cd build
cmake .. -DUSM=1
make cpu-gpu
./vector-add-usm
```

### Matrix multiply

```bash
cd /home/ubuntu/oneapi-packaging/validation/2025.1/DirectProgramming/C++SYCL/DenseLinearAlgebra/matrix_mul
CXXFLAGS="-isystem /home/ubuntu/oneapi-packaging/compiler/samples/common" make all
```
