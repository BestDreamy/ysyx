#include <nterm.h>
#include <stdarg.h>
#include <unistd.h>
#include <SDL.h>

char handle_key(SDL_Event *ev);

static void sh_printf(const char *format, ...) {
  static char buf[256] = {};
  va_list ap;
  va_start(ap, format);
  int len = vsnprintf(buf, 256, format, ap);
  va_end(ap);
  term->write(buf, len);
}

static void sh_banner() {
  sh_printf("Built-in Shell in NTerm (NJU Terminal)\n\n");
}

static void sh_prompt() {
  sh_printf("sh> ");
}

static void sh_handle_cmd(const char *cmd) {
  if (strcmp(cmd, "\n") == 0) {
    sh_printf("None\n");
    return ;
  }

  setenv("PATH", "/bin", 1);
  // // Ensure cmd just have a '\n' which is the only one redundant character.
  // // Ensure cmd intend to open a new file in nanos.
  int n = sizeof(char) * strlen(cmd);
  char* fname = (char*) malloc(n);
  strncpy(fname, cmd, n);
  fname[n - 1] = '\0';
  execvp(fname, NULL);
}

void builtin_sh_run() {
  sh_banner();
  sh_prompt();

  while (1) {
    SDL_Event ev;
    if (SDL_PollEvent(&ev)) {
      if (ev.type == SDL_KEYUP || ev.type == SDL_KEYDOWN) {
        const char *res = term->keypress(handle_key(&ev));
        if (res) { // triggered just press [Enter]
          sh_handle_cmd(res);
          sh_prompt();
        }
      }
    }
    refresh_terminal();
  }
}
