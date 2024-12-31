TOP_MODULE = ysyxSoCFull
VERILATOR = verilator
YSYXSOC_PATH = $(abspath ../ysyxSoC)
# VERILATOR_INC_PATH  = $(addprefix -I, $(abspath ./vsrc/core) $(abspath ./vsrc/perip) $(abspath ./vsrc/include) $(abspath ./vsrc))
VERILATOR_INC_PATH  = $(addprefix -I, $(abspath ./vsrc/core) $(abspath ./vsrc/perip) $(abspath ./vsrc/include))
# For ysysSoC
VERILATOR_INC_PATH += $(shell find $(YSYXSOC_PATH)/perip -type d | sed 's/^/-I/')
VERILATOR_INC_PATH += $(addprefix -I, $(YSYXSOC_PATH)/build)
VERILATOR_FLAGS = -cc --exe --build --trace-fst --top-module $(TOP_MODULE)
VERILATOR_FLAGS += $(VERILATOR_INC_PATH)
VERILATOR_FLAGS += -Wno-WIDTHEXPAND -Wno-WIDTHTRUNC # TODO
VERILATOR_FLAGS += --timescale "1ns/1ns" --no-timing

WORK_DIR = $(shell pwd)

CSRC = $(shell find $(abspath ./csrc) -name "*.c" -or -name "*.cc" -or -name "*.cpp")
VSRC = -f $(shell find $(abspath ./vsrc) -name "vsrc.txt")
# For ysysSoC
YSYXSOC_VSRC = -f $(shell find $(abspath ./vsrc) -name "ysyx.txt")
YSYXSOC_VSRC += $(shell find $(YSYXSOC_PATH)/perip -type f -name "*.v")

FILELIST_MK = $(shell find ./csrc -name filelist.mk)
-include $(FILELIST_MK)

DIFFTEST_MK = $(shell find ./csrc -name difftest.mk)
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
IMG ?= a.bin
# LOAD_IMG = $(abspath ./bin/$(notdir $(IMG)))
LOAD_IMG = $(abspath ./tests/$(notdir $(IMG)))
ARGS += $(LOAD_IMG)

run: $(CSRC)
	@echo "\033[0;1;36mVerilator the project: \033[0m"
	@rm -rf $(OBJ_DIR)
	@cp $(IMG) $(LOAD_IMG)
	@$(VERILATOR) $(VERILATOR_FLAGS) $(VSRC) $(CXX_FLAGS) $(LD_FLAGS) $(CSRC) #> /dev/null 2>&1
	@# echo "\033[0;35m$(ARGS)\033[0m"
	@echo -n "(npc run) "
	$(BIN) $(ARGS)

ysyx: $(CSRC)
	@echo "\033[0;1;36mVerilator the project: \033[0m"
	@rm -rf $(OBJ_DIR)
	@$(VERILATOR) $(VERILATOR_FLAGS) $(YSYXSOC_VSRC) $(CXX_FLAGS) $(LD_FLAGS) $(CSRC) #> /dev/null 2>&1
	@# echo "\033[0;35m$(ARGS)\033[0m"
	@echo -n "(npc run) "
	$(BIN) $(ARGS)

SIM = sim.fst

sim:
	@echo "Run sim"
	$(call git_commit, "sim RTL") # DO NOT REMOVE THIS LINE!!!

clean:
	rm -rf $(OBJ_DIR)
.PHONY: run sim default rm

include ../Makefile
