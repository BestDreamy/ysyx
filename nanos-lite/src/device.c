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
  if (ev.keycode == AM_KEY_NONE) {
    *(char*)buf = '\0';
    return 0;
  }

  char* key_state = ev.keydown? "kd": "ku";
  return snprintf((char*)buf, len, "%s %s\n", key_state, keyname[ev.keycode]);
}

size_t dispinfo_read(void *buf, size_t offset, size_t len) {
  AM_GPU_CONFIG_T ev = io_read(AM_GPU_CONFIG);
  return snprintf((char*)buf, len, "WIDTH: %d\nHEIGHT: %d", ev.width, ev.height);
}

size_t fb_write(const void *buf, size_t offset, size_t len) {
  // AM_GPU_CONFIG_T ev = io_read(AM_GPU_CONFIG);
  // int width = ev.width;
 
  // offset /= 4;
  // len /= 4;
 
  // int y = offset / width;
  // int x = offset - y * width;
 
  // io_write(AM_GPU_FBDRAW, x, y, (void *)buf, len, 1, true);

  // return len;
 
  return 0;
}

void init_device() {
  Log("Initializing devices...");
  ioe_init();
}
