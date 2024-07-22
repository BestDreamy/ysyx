#ifndef __RAMDISK_H__
#define __RAMDISK_H__
size_t ramdisk_read(void *buf, size_t offset, size_t len);

/* write `len' bytes starting from `buf' into the `offset' of ramdisk */
size_t ramdisk_write(const void *buf, size_t offset, size_t len);

void init_ramdisk();

size_t get_ramdisk_size();

#endif