// IFDEF  CONFIG_ISA32 -> 32
// IFNDEF CONFIG_ISA32 -> 64
#define CONFIG_ISA32 1
// Host address start from 0x8000_0000
#define CONFIG_MBASE 0x80000000
#define CONFIG_MSIZE 0x8000000
#define CONFIG_PC_RESET_OFFSET 0x0
#define CONFIG_DIFFTEST 1
#define CONFIG_ITRACE   1
#define CONFIG_MTRACE   1
// #define CONFIG_FTRACE   1
// #define CONFIG_DEVICE 1

#define CONFIG_HAS_SERIAL 1
#define CONFIG_HAS_TIMER  1
#define CONFIG_SERIAL_MMIO 0xa00003f8
#define CONFIG_RTC_MMIO 0xa0000048
#define CONFIG_TIMER_GETTIMEOFDAY 1