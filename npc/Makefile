TOP_MODULE = top
VERILATOR = verilator
VERILATOR_INC_PATH = $(addprefix -I, $(abspath ./vsrc/core) $(abspath ./vsrc/perip))
VERILATOR_FLAGS = -cc --exe --build
VERILATOR_FLAGS += $(VERILATOR_INC_PATH)
VERILATOR_FLAGS += --trace-fst

CSRC = $(shell find $(abspath ./csrc) -name "*.c" -or -name "*.cc" -or -name "*.cpp")
VSRC = -f $(shell find $(abspath ./vsrc) -name "vsrc.txt") 

CXX_INC_PATH = $(addprefix -I, $(abspath ./csrc/include))
CXX_FLAGS = $(addprefix -CFLAGS , $(CXX_INC_PATH))

default: run

BIN = $(abspath obj_dir/V$(TOP_MODULE))

run:
	@echo "Verilator the project"
	@$(VERILATOR) $(VERILATOR_FLAGS) $(VSRC) $(CXX_FLAGS) $(CSRC) 
	@$(BIN) $(IMG)

SIM = wave.fst

sim:
	@echo "Run sim"
	$(call git_commit, "sim RTL") # DO NOT REMOVE THIS LINE!!!

rm:
	rm -rf $(OBJ)
.PHONY: run sim default rm

include ../Makefile
