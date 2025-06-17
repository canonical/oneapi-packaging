Build docker image
---

docker build -t oneapi-compiler-build -f Dockerfile.build .

docker build -t oneapi-compiler -f Dockerfile.compiler .

Build sample progrem
---

cd samples
docker run -v $PWD:/src -it oneapi-compiler bash

cd /src/

#### sample.cpp
clang++ -fsycl sample.cpp -o simple-sycl-app

#### mandelbrot
cd mandelbrot
CXXFLAGS=-isystem\ /src/common/ cmake .
make

