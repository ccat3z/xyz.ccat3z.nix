cmake_minimum_required(VERSION 3.29)
project(sd-controller)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD 20)

find_package(hidapi REQUIRED)
add_executable(sd-controller main.cpp)

target_link_libraries(sd-controller hidapi::hidapi)

install(TARGETS sd-controller DESTINATION bin)