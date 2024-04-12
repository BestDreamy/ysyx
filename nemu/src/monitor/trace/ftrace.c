#include <trace.h>

static char* strtab = NULL;
static Elf64_Sym* symbol = NULL;
static int32 symbol_num = 0;

void init_elf(const char *elf_file) {
    FILE *fp = fopen(elf_file, "r");
    assert(fp != NULL); // Check fp cannot point to null

    Elf64_Ehdr elf_header; // elf header
    // Elf64_Shdr section_header;
    // Elf64_Phdr program_header;

    assert( fread(&elf_header, sizeof(elf_header), 1, fp) );

    // Build the section header table(shdr)
    Elf64_Shdr *section_header_table = (Elf64_Shdr*)malloc(sizeof(Elf64_Shdr) * elf_header.e_shnum);
    #define SHDR section_header_table
    fseek(fp, elf_header.e_shoff, SEEK_SET);
    assert( fread(SHDR, sizeof(Elf64_Shdr) * elf_header.e_shnum, 1, fp) );
    rewind(fp);

    // Build the section header string table
    int32 sz = SHDR[elf_header.e_shstrndx].sh_size;
    char shstrtab[sz]; // section header string table
    fseek(fp, SHDR[elf_header.e_shstrndx].sh_offset, SEEK_SET);
    assert( fread(shstrtab, sz, 1, fp) );
    rewind(fp);

    // -------------------------- Real Work --------------------------------- //
    // Look the shstrtab as base, we can scan the section table to find .strtab
    for (int32 i = 0; i < elf_header.e_shnum; i ++) {
        // Build the const string table
        if (strcmp(shstrtab + SHDR[i].sh_name, ".strtab") == 0) {
            sz = SHDR[i].sh_size;
            strtab = (char*)malloc(sizeof(char) * sz);
            fseek(fp, SHDR[i].sh_offset, SEEK_SET);
            assert( fread(strtab, sz, 1, fp) );
            rewind(fp);
        }

        // Build the Symbol
        if (SHDR[i].sh_type == 2) {
            sz = SHDR[i].sh_size, symbol_num = sz / sizeof(Elf64_Sym);
            // printf("%d %ld %ld\n", sz, sizeof(Elf64_Sym), sz / sizeof(Elf64_Sym));
            symbol = (Elf64_Sym*)malloc(sz);
            fseek(fp, SHDR[i].sh_offset, SEEK_SET);
            assert( fread(symbol, sz, 1, fp) );
            rewind(fp);
        }
    }
    // for (int i = 0; i < symbol_num; i ++) printf("%s: %c\n", strtab + symbol[i].st_name, ELF64_ST_TYPE(symbol[i].st_info) == STT_FUNC? 'f': 'n'); puts("");
    // for (int i = 0; i < sz; i ++) printf("%c", shstrtab[i]); puts("");
    // for (int i = 0; i < sz; i ++) printf("%c", strtab[i]); puts("");
}

static int32 space_num = 0;
void print_space() {
    for (int32 i = 0; i < space_num; i ++) printf("  ");
}

char* symbol_is_func(uint64 pc) {
    char *func = NULL;
    for (int i = 0; i < symbol_num; i ++) {
        if (ELF64_ST_TYPE(symbol[i].st_info) == STT_FUNC && pc >= symbol[i].st_value && pc < symbol[i].st_value + symbol[i].st_size) {
            func = strtab + symbol[i].st_name;
        }
    }
    return func;
}

void ftrace_call(uint64 pc, uint64 npc) {
    print_space();
    space_num ++;
    IFDEF(CONFIG_FTRACE, printf("0x%08lx: call [%s -> 0x%08lx]\n", pc, symbol_is_func(npc), npc));
}

void ftrace_ret(uint64 pc, uint64 npc) {
    print_space();
    space_num --;
    IFDEF(CONFIG_FTRACE, printf("0x%08lx: ret  [%s -> 0x%08lx]\n", pc, symbol_is_func(npc), npc));
}

void ftraceDisplay() {
    ;
}
