#include <NDL.h>
#include <SDL.h>
#include <string.h>

#define keyname(k) #k,

static const char *keyname[] = {
  "NONE",
  _KEYS(keyname)
};

int SDL_PushEvent(SDL_Event *ev) {
  return 0;
}

int SDL_PollEvent(SDL_Event *ev) {
  char buf[32];
  // Get the state of the keyboard from NDL.
  if (NDL_PollEvent(buf, sizeof(buf) / sizeof(char))) {
    if (strncmp(buf, "kd", 2) == 0) {
      ev->key.type = SDL_KEYDOWN;
    } else {
      ev->key.type = SDL_KEYUP;
    }

    char keyname[16];
    int keycode;
    sscanf(buf + 3, "%s %d\n", keyname, &keycode);
    if (keycode != 0) {
      ev->key.keysym.sym = keycode;
    }
    return 1;
  }
  return 0;
}

int SDL_WaitEvent(SDL_Event *event) {
  while(SDL_PollEvent(event) == 0) ;
  return 1;
}

int SDL_PeepEvents(SDL_Event *ev, int numevents, int action, uint32_t mask) {
  return 0;
}

static unsigned char keystate[sizeof(keyname) / sizeof(keyname[0])];

uint8_t* SDL_GetKeyState(int *numkeys) {
    SDL_Event ev;
    if (SDL_PollEvent(&ev) == 1 && ev.key.type == SDL_KEYDOWN) {
        keystate[ev.key.keysym.sym] = 1;
    } else {
        memset(keystate, 0, sizeof(keystate));
    }
    return keystate;
}