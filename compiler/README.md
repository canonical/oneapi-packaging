# intel-dpcpp compiler package

## Build the debian package

```
cd oneapi-packaging/intel-dpcpp-6.2.0
sudo apt build-dep ./
sbuild-apt plucky-amd64 apt-get install ca-certificates
sbuild -c plucky-amd64 --dist=plucky --no-run-lintian --extra-repository="deb [trusted=yes] https://ppa.launchpadcontent.net/kobuk-team/oneapi/ubuntu plucky main" --build-path=""
```

This avoids running `lintian` for now as it takes a very long time to run. The final option is important as it forces `sbuild` to use a different build path for each build. Otherwise, each build will share a build directory, which can result in strange errors.

## Build and run samples (on the host)

### Clone repo

If you have not done so already on the host:

```bash
git clone https://github.com/canonical/oneapi-packaging.git
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
cd /home/ubuntu/oneapi-packaging/compiler/samples/mandelbrot
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
./matrix_mul_dpc
```