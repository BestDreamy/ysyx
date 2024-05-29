TOP_MODULE = top
VERILATOR = verilator
VERILATOR_INC_PATH = $(addprefix -I, $(abspath ./vsrc/core) $(abspath ./vsrc/perip))
VERILATOR_FLAGS = -cc --exe --build
VERILATOR_FLAGS += $(VERILATOR_INC_PATH)
VERILATOR_FLAGS += --trace-fst
VERILATOR_FLAGS += -Wno-WIDTHEXPAND
VERILATOR_FLAGS += -Wno-WIDTHTRUNC

WORK_DIR = $(shell pwd)

CSRC = $(shell find $(abspath ./csrc) -name "*.c" -or -name "*.cc" -or -name "*.cpp")
VSRC = -f $(shell find $(abspath ./vsrc) -name "vsrc.txt") 

FILELIST_MK = $(shell find ./csrc -name filelist.mk)
DIFFTEST_MK = $(shell find ./csrc -name difftest.mk)
-include $(FILELIST_MK)
-include $(DIFFTEST_MK)
CXX_INC_PATH = $(addprefix -I, $(INC_PATH))
CXX_FLAGS    = $(addprefix -CFLAGS , $(CXX_INC_PATH))
CXX_FLAGS   += $(addprefix -CFLAGS , -Wno-pointer-arith)  # ignore warning: (void*) arithmetic
CXX_FLAGS   += $(addprefix -CFLAGS , -Wno-return-type)    # ignore warning: no return
# CXX_FLAGS   += $(addprefix -CFLAGS , -fpermissive)
# LIB         += -fsanitize=address -lasan
LD_FLAGS     = $(addprefix -LDFLAGS , $(LIB))

default: run

OBJ_DIR = obj_dir
BIN = $(OBJ_DIR)/V$(TOP_MODULE)
IMG ?= inst.txt
LOAD_IMG = $(abspath ./bin/$(notdir $(IMG)))
ARGS += $(LOAD_IMG)

run: $(CSRC)
	@echo "\033[0;36mVerilator the project\033[0m"
	@rm -rf $(OBJ_DIR)
	@cp $(IMG) $(LOAD_IMG)
	@$(VERILATOR) $(VERILATOR_FLAGS) $(VSRC) $(CXX_FLAGS) $(LD_FLAGS) $(CSRC)
	@# echo "\033[0;35m$(ARGS)\033[0m"
	$(BIN) $(ARGS)

SIM = sim.fst

sim:
	@echo "Run sim"
	$(call git_commit, "sim RTL") # DO NOT REMOVE THIS LINE!!!

rm:
	rm -rf $(OBJ)
.PHONY: run sim default rm

include ../Makefile

# COLOR_RESET = \033[0m
# COLOR_RED = \033[0;31m
# COLOR_GREEN = \033[0;32m
# COLOR_YELLOW = \033[0;33m
# COLOR_BLUE = \033[0;34m
# COLOR_MAGENTA = \033[0;35m
# COLOR_CYAN = \033[0;36m
# COLOR_WHITE = \033[0;37m