project(switch)
cmake_minimum_required(VERSION 3.12)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

find_package(verilator HINTS $ENV{VERILATOR_ROOT})
add_executable(switch)
target_sources(switch PRIVATE csrc/switch.cc)
verilate(switch SOURCES vsrc/switch.v TRACE_FST)
