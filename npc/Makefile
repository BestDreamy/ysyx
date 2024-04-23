TOP_MODULE = top
VERILATOR = verilator
VERILATOR_INC_PATH = $(addprefix -I, $(abspath ./vsrc/core) $(abspath ./vsrc/perip))
VERILATOR_FLAGS = -cc --exe --build
VERILATOR_FLAGS += $(VERILATOR_INC_PATH)
VERILATOR_FLAGS += --trace-fst

WORK_DIR = $(shell pwd)

CSRC = $(shell find $(abspath ./csrc) -name "*.c" -or -name "*.cc" -or -name "*.cpp")
VSRC = -f $(shell find $(abspath ./vsrc) -name "vsrc.txt") 

FILELIST_MK = $(shell find ./csrc -name filelist.mk)
-include $(FILELIST_MK)
CXX_INC_PATH = $(addprefix -I, $(INC_PATH))
CXX_FLAGS = $(addprefix -CFLAGS , $(CXX_INC_PATH))

default: run

OBJ_DIR = obj_dir
BIN = $(abspath $(OBJ_DIR)/V$(TOP_MODULE))
IMG ?= inst.txt
LOAD_IMG = bin/$(notdir $(IMG))

run: $(CSRC)
	@echo "Verilator the project"
	rm -rf $(OBJ_DIR)
	cp $(IMG) $(LOAD_IMG)
	@$(VERILATOR) $(VERILATOR_FLAGS) $(VSRC) $(CXX_FLAGS) $(CSRC)
	@echo $(LOAD_IMG)
	# $(BIN) $(abspath($(LOAD_IMG)))

SIM = wave.fst

sim:
	@echo "Run sim"
	$(call git_commit, "sim RTL") # DO NOT REMOVE THIS LINE!!!

rm:
	rm -rf $(OBJ)
.PHONY: run sim default rm

include ../Makefile
