#include <fs.h>

typedef size_t (*ReadFn) (void *buf, size_t offset, size_t len);
typedef size_t (*WriteFn) (const void *buf, size_t offset, size_t len);

typedef struct {
  char *name;
  size_t size;
  size_t disk_offset;
  ReadFn read;
  WriteFn write;
} Finfo;

enum {
  FD_STDIN, 
  FD_STDOUT, 
  FD_STDERR, 
  FD_EVENTS, 
  FD_FB,
  FD_DISPINFO,
};

size_t ramdisk_read(void *buf, size_t offset, size_t len);

size_t ramdisk_write(const void *buf, size_t offset, size_t len);

size_t invalid_read(void *buf, size_t offset, size_t len) {
  panic("should not reach here");
  return 0;
}

size_t invalid_write(const void *buf, size_t offset, size_t len) {
  panic("should not reach here");
  return 0;
}

/* This is the information about all files in disk. */
size_t serial_write(const void *buf, size_t offset, size_t len);
size_t events_read(void *buf, size_t offset, size_t len);
size_t fb_write(const void *buf, size_t offset, size_t len);
size_t dispinfo_read(void *buf, size_t offset, size_t len);

static Finfo file_table[] __attribute__((used)) = {
  [FD_STDIN]  = {"stdin", 0, 0, invalid_read, invalid_write},
  [FD_STDOUT] = {"stdout", 0, 0, invalid_read, serial_write},
  [FD_STDERR] = {"stderr", 0, 0, invalid_read, serial_write},
  [FD_EVENTS] = {"/dev/events", 0, 0, events_read, invalid_write},
  [FD_FB] = {"/dev/fb", 0, 0, invalid_read, fb_write},
  [FD_DISPINFO] = {"/proc/dispinfo", 0, 0, dispinfo_read, invalid_write},
#include "files.h"
};
#define NR_FILES (int)(sizeof(file_table) / sizeof(Finfo))

void init_fs() {
  // frame buffer
  AM_GPU_CONFIG_T fb = io_read(AM_GPU_CONFIG);
  file_table[FD_FB].size = fb.width * fb.height;
}

// file_offset's value in [0, file.size)
size_t file_offset = 0;

int fs_open(const char *pathname, int flags, int mode) {
  int fd = -1;
  for (int i = 3; i < NR_FILES; i ++) {
    if (strcmp(file_table[i].name, pathname) == 0) {
      fd = i;
      file_offset = 0;
      break;
    }
  }
  if (fd == -1) panic("No this file in FILE_TABLE.");
  return fd;
}

size_t fs_read(int fd, void *buf, size_t len) {
  /* if (fd < 3) return Log("Read invalid fd."), 0; */
  Finfo file = file_table[fd];
  if (file.read != NULL) {
    return file.read(buf, 0, len);
  }

  if (len + file_offset > file.size) {
    len = file.size - file_offset;
  }
  ramdisk_read(buf, file.disk_offset + file_offset, len);
  /* file_offset = (len + file_offset) % file.size; */
  file_offset = (len + file_offset);
  return len;
}

/* intptr_t sys_write(int fd, const void* buf, size_t len); */
size_t fs_write(int fd, const void *buf, size_t len) {
  /* if (fd == 0) return Log("Write invalid fd."), 0; */
  /* if (fd < 3) return sys_write(fd, buf, len); */
  Finfo file = file_table[fd];
  if (file.write != NULL) {
    return file.write(buf, 0, len);
  }

  if (len + file_offset > file.size) {
    len = file.size - file_offset;
  }
  ramdisk_write(buf, file.disk_offset + file_offset, len);
  /* file_offset = (len + file_offset) % file.size; */
  file_offset = (len + file_offset);
  return len;
}

size_t fs_lseek(int fd, size_t offset, int whence) {
  if (fd < 3) return Log("Seek invalid fd."), 0;

  Finfo file = file_table[fd];
  switch (whence) {
    case SEEK_SET:
      file_offset = offset;
      break;
    case SEEK_CUR:
      file_offset = file_offset + offset;
      break;
    case SEEK_END:
      file_offset = file.size + offset;
      break;
    default:
      panic("Invalid whence when seeking.");
  }
  return file_offset;
}

int fs_close(int fd) {
  return 0;
}
