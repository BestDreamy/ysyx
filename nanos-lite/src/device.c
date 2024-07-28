#include <common.h>

#if defined(MULTIPROGRAM) && !defined(TIME_SHARING)
# define MULTIPROGRAM_YIELD() yield()
#else
# define MULTIPROGRAM_YIELD()
#endif

#define NAME(key) \
  [AM_KEY_##key] = #key,

static const char *keyname[256] __attribute__((used)) = {
  [AM_KEY_NONE] = "NONE",
  AM_KEYS(NAME)
};

size_t serial_write(const void *buf, size_t offset, size_t len) {
  for (int i = 0; i < len; i ++) {
    putch(*(char*)((buf + i)));
  }
  return len;
}

size_t events_read(void *buf, size_t offset, size_t len) {
  // Seek for $AM/am/include/amdev.h
  AM_INPUT_KEYBRD_T ev = io_read(AM_INPUT_KEYBRD);
  int keycode = ev.keycode;
  if (keycode == AM_KEY_NONE) {
    *(char*)buf = '\0';
    return 0;
  }

  char* key_state = ev.keydown? "kd": "ku";
  return snprintf((char*)buf, len, "%s %s %d\n", key_state, keyname[keycode], keycode);
}

size_t dispinfo_read(void *buf, size_t offset, size_t len) {
  AM_GPU_CONFIG_T ev = io_read(AM_GPU_CONFIG);
  return snprintf((char*)buf, len, "WIDTH: %d\nHEIGHT: %d", ev.width, ev.height);
}

extern size_t file_offset;
size_t fb_write(const void *buf, size_t offset, size_t len) {
  // printf("offset=%d len=%d\n", offset, len);
  AM_GPU_CONFIG_T cfg = io_read(AM_GPU_CONFIG);

  AM_GPU_FBDRAW_T ctl;
  ctl.pixels = (void *)buf;
  ctl.sync = true;

  ctl.x = offset % cfg.width;
  ctl.y = offset / cfg.width;
  ctl.w = len;
  ctl.h = 1;

  io_write(AM_GPU_FBDRAW, ctl.x, ctl.y, ctl.pixels, ctl.w, ctl.h, ctl.sync);
  file_offset = file_offset + len;
  return 0;
}

void init_device() {
  Log("Initializing devices...");
  ioe_init();
}
