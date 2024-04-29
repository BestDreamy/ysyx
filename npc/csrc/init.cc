#include "init.h"
#include "macro.h"
#include "debug.h"
#include "paddr.h"
#include "dut.h"
#include <cstddef>
#include <stdio.h>
#include <getopt.h>

static char *img_file = NULL;
static char *diff_so_file = NULL;
static bool is_batch_mode = false;
static int  difftest_port = 1234;

uint64_t load_image() {
    Assert(img_file != NULL, "The binary file not found!\n");

    FILE *fp = fopen(img_file, "rb");
    Assert(fp != NULL, "Can not open instruction file!\n");
    fseek(fp, 0, SEEK_END);
    size_t size = ftell(fp);
    fseek(fp, 0, SEEK_SET);
    bool ret = fread(guest_to_host(RESET_VECTOR), size, 1, fp);
    Assert(ret == 1, "Load the instrction to the pmem error!\n");
    fclose(fp);
    return size;
}

void welcome(int argc, char *argv[]) {
    Log("ITrace: %s", MUXDEF(CONFIG_ITRACE, ANSI_FMT(GREEN_TXT, "ON"), ANSI_FMT(RED_TXT, "OFF")));
    Log("MTrace: %s", MUXDEF(CONFIG_MTRACE, ANSI_FMT(GREEN_TXT, "ON"), ANSI_FMT(RED_TXT, "OFF")));
    Log("FTrace: %s", MUXDEF(CONFIG_FTRACE, ANSI_FMT(GREEN_TXT, "ON"), ANSI_FMT(RED_TXT, "OFF")));
    Log("ETrace: %s", MUXDEF(CONFIG_ETRACE, ANSI_FMT(GREEN_TXT, "ON"), ANSI_FMT(RED_TXT, "OFF")));
    Log("DiffTest: %s", MUXDEF(CONFIG_DIFFTEST, ANSI_FMT(GREEN_TXT, "ON"), ANSI_FMT(RED_TXT, "OFF")));
    printf("Welcome to %s-NPC!\n", ANSI_FMT(GREEN_TXT, "riscv32"));

    parse_args(argc, argv);
    size_t img_size = load_image();

    IFDEF(CONFIG_DIFFTEST, init_difftest(diff_so_file, img_size, difftest_port));
}

int parse_args(int argc, char *argv[]) {
    const struct option table[] = {
        {"batch"    , no_argument      , NULL, 'b'},
        /* {"log"      , required_argument, NULL, 'l'}, */
        {"diff"     , required_argument, NULL, 'd'},
        /* {"port"     , required_argument, NULL, 'p'}, */
        {"help"     , no_argument      , NULL, 'h'},
        /* {"ftrace"   , required_argument, NULL, 'f'}, */
        {0          , 0                , NULL,  0 },
    };
    int o;
    while ( (o = getopt_long(argc, argv, "-bhd:", table, NULL)) != -1) {
        switch (o) {
            case 'b': sdb_set_batch_mode(); break;
            /* case 'p':  break; */
            /* case 'l': log_file = optarg; break; */
            case 'd': diff_so_file = optarg; break;
            /* case 'f': elf_file = optarg; break; */
            case 1: img_file = optarg; return 0; // ![-bhd:]
            default:
                printf("Usage: %s [OPTION...] IMAGE [args]\n\n", argv[0]);
                printf("\t-b,--batch              run with batch mode\n");
                /* printf("\t-l,--log=FILE           output log to FILE\n"); */
                printf("\t-d,--diff=REF_SO        run DiffTest with reference REF_SO\n");
                /* printf("\t-p,--port=PORT          run DiffTest with port PORT\n"); */
                /* printf("\t-f,--ftrace=FILE        Ftrace file in\n"); */
                printf("\n");
                Assert(0, "Please choose a option from the above.");
        }
    }
    return 0;
}

void sdb_set_batch_mode() {
    is_batch_mode = true;
}
