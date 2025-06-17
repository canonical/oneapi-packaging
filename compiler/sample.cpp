#include <sycl/sycl.hpp>

int main() {

  auto NEOGPUDeviceSelector = [](const sycl::device &Device){
    using namespace sycl::info;

    const std::string DeviceName = Device.get_info<device::name>();
    bool match = Device.is_gpu() && (DeviceName.find("HD Graphics NEO") != std::string::npos);
    return match ? 1 : -1;
  };

  try {
    sycl::queue Queue(NEOGPUDeviceSelector);
    sycl::device Device(NEOGPUDeviceSelector);
  } catch (sycl::exception &E) {
    std::cout << E.what() << std::endl;
  }
}

