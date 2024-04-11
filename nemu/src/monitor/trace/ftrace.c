#include <trace.h>

void init_elf(const char *elf_file) {
    FILE *fp = fopen(elf_file, "r");
    assert (fp != NULL); // Check fp cannot point to null

    Elf64_Ehdr elf_header; // elf header
    // Elf64_Shdr section_header;
    // Elf64_Phdr program_header;

    assert(fread(&elf_header, sizeof(elf_header), 1, fp));

    // Build the section header table(shdr)
    Elf64_Shdr *section_header_table = (Elf64_Shdr*)malloc(sizeof(Elf64_Shdr) * elf_header.e_shnum);
    fseek(fp, elf_header.e_shoff, SEEK_SET);
    assert(fread(section_header_table, sizeof(Elf64_Shdr) * elf_header.e_shnum, 1, fp));
    rewind(fp);

    // Build the string table
    fseek(fp, section_header_table[elf_header.e_shstrndx].sh_offset, SEEK_SET);
    int32 sz = section_header_table[elf_header.e_shstrndx].sh_size;
    char string_table[sz];
    assert(fread(string_table, sz, 1, fp));
    rewind(fp);

    printf("%s\n", string_table);
}

bool isSymbolFunc() {
    return true;
}

void ftrace_call() {
    IFDEF(CONFIG_FTRACE, printf("call\n"));
    
}

void ftrace_ret() {
    IFDEF(CONFIG_FTRACE, printf("ret\n"));
}

void ftraceDisplay() {
    ;
}