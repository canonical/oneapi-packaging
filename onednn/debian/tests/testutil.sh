#!/bin/bash
set -e

cxxflags="$(dpkg-buildflags --get CXXFLAGS) $(dpkg-buildflags --get CPPFLAGS) -fsycl -I /usr/lib/onednn/examples -I /usr/lib/onednn/examples/graph"
ldflags=$(dpkg-buildflags --get LDFLAGS)
libs="-ldnnl-sycl -lOpenCL -ltbb"

compile_and_test () {
	local _cxx=$1
	local _src=$2
	install -D -m 0644 /usr/lib/onednn/$_src $_src
	echo $_cxx ${cxxflags[@]} ${ldflags[@]} $_src ${libs} -o tester
	$_cxx ${cxxflags[@]} ${ldflags[@]} $2 ${libs} -o tester
	./tester gpu
	rm tester || true
	rm -r examples || true
}

dump_test_command () {
	local _cxx=$1
	local _src=$2
	local _exe=$(basename ${_src%.*})_tester
	cat >> debian/tests/control <<EOF
Test-Command: install -D -m 0644 /usr/lib/onednn/$_src $_src; $_cxx ${cxxflags} ${ldflags} $_src ${libs} -o $_exe; ./$_exe gpu
Depends: @, onednn-sycl-examples, libtbb-dev, clang-dpcpp-21, libsycl-dev, libclang-dpcpp-common-21-dev, ocl-icd-opencl-dev
Restrictions: allow-stderr
Architecture: amd64
Features: test-name=$_cxx-$(echo ${_src} | awk -F/ '{print $NF}')

EOF
}

tests=(
examples/bnorm_u8_via_binary_postops.cpp
examples/cnn_inference_f32.c
examples/cnn_inference_f32.cpp
examples/cnn_inference_int8.cpp
examples/cnn_training_bf16.cpp
examples/cnn_training_f32.cpp
#examples/cpu_matmul_coo.cpp
#examples/cpu_matmul_csr.cpp
#examples/cpu_matmul_weights_compression.cpp
#examples/cpu_cnn_training_f32.c
#examples/cpu_rnn_inference_f32.cpp
#examples/cpu_rnn_inference_int8.cpp
#examples/cross_engine_reorder.c
#examples/cross_engine_reorder.cpp
examples/getting_started.cpp
#examples/gpu_opencl_interop.cpp
examples/matmul_perf.cpp
examples/memory_format_propagation.cpp
examples/performance_profiling.cpp
examples/rnn_training_f32.cpp
examples/sycl_interop_buffer.cpp
examples/sycl_interop_usm.cpp
examples/graph/sycl_getting_started.cpp
examples/graph/sycl_single_op_partition.cpp
)

case "$1" in
	test)
		for compiler in clang++-dpcpp; do
			for t in ${tests[@]}; do
				compile_and_test $compiler $t
			done
		done
		;;
	generate)
		truncate -s0 debian/tests/control
		for compiler in clang++-dpcpp; do
			for t in ${tests[@]}; do
				dump_test_command $compiler $t
			done
		done
		;;
	*)
		echo ???
		;;
esac
