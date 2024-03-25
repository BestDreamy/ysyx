project(switch)
cmake_minimum_required(VERSION 3.12)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
find_package(verilator HINTS $ENV{VERILATOR_ROOT})

# project's name
set(PRONAME sim)
add_executable(${PRONAME})
target_sources(${PRONAME} PRIVATE csrc/main.cc)
verilate(${PRONAME} SOURCES vsrc/core/defines.v vsrc/core/top.v vsrc/core/ifu.v vsrc/core/pc.v vsrc/perip/rom.v TRACE_FST)
