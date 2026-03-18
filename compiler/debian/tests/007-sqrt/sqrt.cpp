#include <sycl/sycl.hpp>
#include <cmath>
int main() {
 // Creating buffer of 4 elements to be used inside the kernel code
 sycl::buffer<float, 1> Buffer(4);

 // Creating SYCL queue
 sycl::queue Queue;

 // Size of index space for kernel
 sycl::range<1> NumOfWorkItems{Buffer.size()};
 // Submitting command group(work) to queue
 Queue.submit([&](sycl::handler &cgh) {
   // Getting write only access to the buffer on a device.
   sycl::accessor Accessor{Buffer, cgh, sycl::write_only};
   // Executing kernel
   cgh.parallel_for<class FillBuffer>(
       NumOfWorkItems, [=](sycl::id<1> WIid) {
         // Fill buffer with indexes.
         Accessor[WIid] = std::sqrt(float(WIid));
       });
 });

 return 0;
}
