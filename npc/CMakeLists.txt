set(Target sim)
project(${Target})
cmake_minimum_required(VERSION 3.12)
# Build .json(clangd)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
# Env C++11
set(CMAKE_CXX_STANDARD 11)
find_package(verilator HINTS $ENV{VERILATOR_ROOT})
if (NOT verilator_FOUND)
  message(FATAL_ERROR "Verilator was not found. Either install it, or set the VERILATOR_ROOT environment variable")
endif()

include_directories(include csrc/include/ csrc/)
add_executable( ${Target} 
    csrc/main.cc
)

if(FALSE)
file(
    GLOB_RECURSE
    VSRC $ENV{NPC_HOME}/vsrc/*.v
)
message(Vsrcs: ${VSRC})
endif()

# set(VERILATOR_FLAGS "-Wno-PINMISSING")
verilate( ${Target}
    SOURCES vsrc/core/top.v
    INCLUDE_DIRS vsrc/core vsrc/perip
    # TOP_MODULE vsrc/core/top.v
    # VERILATOR_FLAGS ${VERILATOR_FLAGS}
    TRACE_FST
)
