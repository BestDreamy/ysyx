#include <elf.h>
#include <proc.h>
#include "ramdisk.h"
#include "loader.h"
#include "fs.h"

#ifdef __LP64__
# define Elf_Ehdr Elf64_Ehdr
# define Elf_Phdr Elf64_Phdr
#else
# define Elf_Ehdr Elf32_Ehdr
# define Elf_Phdr Elf32_Phdr
#endif

static uintptr_t loader(PCB *pcb, const char *filename) {
  /* Elf_Ehdr elf_header; */
  /* ramdisk_read(&elf_header, 0, sizeof(elf_header)); */
  /**/
  /* // rv64-elf -a build/ramdisk.img */
  /* assert(*(uint32_t *)elf_header.e_ident == 0x464C457f); */
  /**/
  /* Elf_Phdr elf_segment_arr[elf_header.e_phnum]; */
  /* ramdisk_read(elf_segment_arr, elf_header.e_phoff, sizeof(Elf_Phdr) * elf_header.e_phnum); */
  /* for (int i = 0; i < elf_header.e_phnum; i++) { */
  /*   if (elf_segment_arr[i].p_type == PT_LOAD) { */
  /*     Elf64_Addr  p_vaddr  = elf_segment_arr[i].p_vaddr; */
  /*     Elf64_Off   p_offset = elf_segment_arr[i].p_offset; */
  /*     Elf64_Xword p_memsz  = elf_segment_arr[i].p_memsz; */
  /*     Elf64_Xword p_filesz = elf_segment_arr[i].p_filesz; */
  /*     ramdisk_read((void *)p_vaddr, p_offset, p_memsz); */
  /*     memset((void *)(p_vaddr + p_filesz), 0, p_memsz - p_filesz); */
  /*   } */
  /* } */
  /**/
  /* return elf_header.e_entry; */

  Elf_Ehdr elf_header;
  int fd = fs_open(filename, 0, 0);
  fs_read(fd, &elf_header, sizeof elf_header);

  assert(*(uint32_t *)elf_header.e_ident == 0x464C457f);

  Elf_Phdr elf_segment_arr[elf_header.e_phnum];
  fs_lseek(fd, elf_header.e_phoff, SEEK_SET);
  fs_read(fd, elf_segment_arr, sizeof(Elf_Phdr) * elf_header.e_phnum);
  
  for (int i = 0; i < elf_header.e_phnum; i++) {
    if (elf_segment_arr[i].p_type == PT_LOAD) {
      fs_lseek(fd, elf_segment_arr[i].p_offset, SEEK_SET);
      // man elf
      Elf64_Addr  p_vaddr  = elf_segment_arr[i].p_vaddr;
      Elf64_Xword p_memsz  = elf_segment_arr[i].p_memsz;
      Elf64_Xword p_filesz = elf_segment_arr[i].p_filesz;
      fs_read(fd, (void *)(uintptr_t)p_vaddr, p_memsz);
      memset((void *)(uintptr_t)(p_vaddr + p_filesz), 0, p_memsz - p_filesz);
    }
  }
  fs_close(fd);

  return elf_header.e_entry;
}

void naive_uload(PCB *pcb, const char *filename) {
  uintptr_t entry = loader(pcb, filename);
  Log("Jump to entry = %p", entry);
  ((void(*)())entry) ();
}

