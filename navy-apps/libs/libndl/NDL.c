#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/time.h>
#include <fcntl.h>

static int evtdev = -1;
static int fbdev = -1;
static int screen_w = 0, screen_h = 0;

uint32_t NDL_GetTicks() {
  struct timeval tv;
  gettimeofday(&tv, NULL);
  return tv.tv_sec * 1000 + tv.tv_usec / 1000;
}

int NDL_PollEvent(char *buf, int len) {
  int fd = open("/dev/events", 0, 0);
  int ret = read(fd, buf, len);
  return !(ret == 0);
}

void NDL_OpenCanvas(int *canvas_w, int *canvas_h) {
  int fd = open("/proc/dispinfo", 0, 0);

  char buf[32];
  read(fd, buf, sizeof(buf)); // --> dispinfo_read 
  sscanf(buf, "WIDTH: %d\nHEIGHT: %d", &screen_w, &screen_h);

  if (*canvas_w == 0 && *canvas_h == 0) {
    *canvas_w = screen_w;
    *canvas_h = screen_h;
  }
  // printf("width: %d\nheight: %d\n", screen_w, screen_h);
  // printf("width: %d\nheight: %d\n", *w, *h);
  close(fd);

  // if (getenv("NWM_APP")) {
  //   int fbctl = 4;
  //   fbdev = 5;
  //   screen_w = *canvas_w; screen_h = *canvas_h;
  //   char buf[64];
  //   int len = sprintf(buf, "%d %d", screen_w, screen_h);
  //   // let NWM resize the window and create the frame buffer
  //   write(fbctl, buf, len);
  //   while (1) {
  //     // 3 = evtdev
  //     int nread = read(3, buf, sizeof(buf) - 1);
  //     if (nread <= 0) continue;
  //     buf[nread] = '\0';
  //     if (strcmp(buf, "mmap ok") == 0) break;
  //   }
  //   close(fbctl);
  // }
}

void NDL_DrawRect(uint32_t *pixels, int x, int y, int canvas_w, int canvas_h) {
  int center_x = screen_w / 2 - canvas_w / 2;
  int center_y = screen_h / 2 - canvas_h / 2;

  x = center_x + x;
  y = center_y + y;

  int fd = open("/dev/fb", 0, 0);

  size_t offset = (screen_w * y + x);
  lseek(fd, offset, SEEK_SET);

  for (int i = 0; i < canvas_h; i ++) {
    write(fd, pixels, canvas_w);
    lseek(fd, screen_w - canvas_w, SEEK_CUR);
    pixels += canvas_w;
  }
  close(fd);
}

void NDL_OpenAudio(int freq, int channels, int samples) {
}

void NDL_CloseAudio() {
}

int NDL_PlayAudio(void *buf, int len) {
  return 0;
}

int NDL_QueryAudio() {
  return 0;
}

int NDL_Init(uint32_t flags) {
  if (getenv("NWM_APP")) {
    evtdev = 3;
  }
  return 0;
}

void NDL_Quit() {
}
