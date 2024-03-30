set(Target sim)
project(${Target})
cmake_minimum_required(VERSION 3.12)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
find_package(verilator HINTS $ENV{VERILATOR_ROOT})

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
