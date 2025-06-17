Build docker image
---

docker build -t oneapi-compiler-build -f Dockerfile.build .
docker build -t oneapi-compiler -f Dockerfile.compiler .

Build sample progrem
---

export PATH=$PWD/build/bin:$PATH
export LD_LIBRARY_PATH=$PWD/build/lib/:$LD_LIBRARY_PATH

clang++ -fsycl sample.cpp -o simple-sycl-app

