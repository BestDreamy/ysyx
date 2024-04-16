export VERILATOR_ROOT
VERILATOR = $(VERILATOR_ROOT)/bin/verilator

VERILATOR_FLAGS = -cc --exe --build -j 0

run:
	$(VERILATOR) -cc --exe --build -j 

all:
	@echo "Write this Makefile by your self."

sim:
	$(call git_commit, "sim RTL") # DO NOT REMOVE THIS LINE!!!
	@echo "Write this Makefile by your self."

.PHONY: run all sim

include ../Makefile
