set(Target top)
project(${Target})
cmake_minimum_required(VERSION 3.12)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
find_package(verilator HINTS $ENV{VERILATOR_ROOT})

add_executable( ${Target} 
    csrc/main.cc
)


file(
    GLOB_RECURSE
    VSRC $ENV{NPC_HOME}/vsrc/*.v
)
message(Vsrcs: ${VSRC})
verilate( ${Target}
    SOURCES ${VSRC}
    INCLUDE_DIRS vsrc/core vsrc/perip
    TOP_MODULE top
    TRACE_FST
)

