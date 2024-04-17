TOP_MODULE = top
VERILATOR = verilator
VERILATOR_INC_PATH = $(addprefix -I, $(abspath ./vsrc/core/))
VERILATOR_FLAGS = -cc --exe --build
VERILATOR_FLAGS += $(VERILATOR_INC_PATH)
VERILATOR_FLAGS += --top-module $(TOP_MODULE) --trace-fst

CSRC = $(shell find $(abspath ./csrc) -name "*.c" -or -name "*.cc" -or -name "*.cpp")
VSRC = $(shell find $(abspath ./vsrc) -name "*.v" -or -name "*.sv") 

run:
	@echo "Verilator the project"
	$(VERILATOR) $(VERILATOR_FLAGS) $(VSRC) $(CSRC) 

sim:
	$(call git_commit, "sim RTL") # DO NOT REMOVE THIS LINE!!!
	@echo "Write this Makefile by your self."

.PHONY: run sim default

include ../Makefile
