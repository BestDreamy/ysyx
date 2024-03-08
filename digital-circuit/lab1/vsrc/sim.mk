default:
	# iverilog sel_tb.v sel.v -o sel
	iverilog sel_tb.v -o sel
	./sel
	gtkwave wave.vcd

rm:
	rm sel wave*

sim: default

.PHONY: rm sim default
