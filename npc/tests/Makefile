IMAGE = char_test

default: bin

gcc:
	riscv64-unknown-elf-gcc $(IMAGE).c -nostdlib -fno-pic -march=rv64g -mcmodel=medany -mstrict-align

# gcc: a.out 
# bin: a.bin
bin: gcc
	riscv64-unknown-elf-objcopy -O binary a.out a.bin
	riscv64-unknown-elf-objdump -d a.out > a.txt
	xxd a.bin | head

clean:
	rm -rf *.bin *.out *.txt *.elf