/***************************************************************************************
* Copyright (c) 2014-2022 Zihao Yu, Nanjing University
*
* NEMU is licensed under Mulan PSL v2.
* You can use this software according to the terms and conditions of the Mulan PSL v2.
* You may obtain a copy of Mulan PSL v2 at:
*          http://license.coscl.org.cn/MulanPSL2
*
* THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
* EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
* MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
*
* See the Mulan PSL v2 for more details.
***************************************************************************************/

#include <isa.h>

/* We use the POSIX regex functions to process regular expressions.
 * Type 'man regex' for more information about POSIX regex functions.
 */
#include <regex.h>

enum {
  TK_NOTYPE = 256, 
  TK_EQ,
  TK_DEC,
  TK_HEX,
  TK_REG,
  /* TODO: Add more token types */

};

static struct rule {
  const char *regex;
  int token_type;
} rules[] = {

  /* TODO: Add more rules.
   * Pay attention to the precedence level of different rules.
   */
  // {"pattern builded by regular expression, real charactor"}
  {" +",                TK_NOTYPE},    // spaces
  // {"--",                TK_NOTYPE},
  {"\\+",               '+'},          // plus (Because '+' is a metacharacter, convert it to str by '\')
  {"\\*",               '*'},
  {"/",                 '/'},
  {"\\(",               '('},
  {"\\)",               ')'},
  {"-",                 '-'},
  {"==",                TK_EQ},        // equal
  {"0x[0-9a-fA-F]+",    TK_HEX},
  {"[0-9]+",            TK_DEC},
  {"\\$[a-z][a-z0-9]+", TK_REG},
};

#define NR_REGEX ARRLEN(rules)

static regex_t re[NR_REGEX] = {};

/* Rules are used for many times.
 * Therefore we compile them only once before any usage.
 */
void init_regex() {
  int i;
  char error_msg[128];
  int ret;
  for (i = 0; i < NR_REGEX; i ++) {
    // Convert string to regex_t
    ret = regcomp(&re[i], rules[i].regex, REG_EXTENDED);
    if (ret != 0) {
      regerror(ret, &re[i], error_msg, 128);
      panic("regex compilation failed: %s\n%s", error_msg, rules[i].regex);
    }
  }
}

typedef struct token {
  int type;
  char str[32];
} Token;

static Token tokens[32] __attribute__((used)) = {};
static int nr_token __attribute__((used))  = 0;

static bool make_token(char *e) {
  int position = 0;
  int i;
  regmatch_t pmatch;

  nr_token = 0;

  while (e[position] != '\0') {
    /* Try all rules one by one. */
    for (i = 0; i < NR_REGEX; i ++) {
      // Matching string(e + position) with pattern re[i]
      if (regexec(&re[i], e + position, 1, &pmatch, 0) == 0 && pmatch.rm_so == 0) {
        char *substr_start = e + position;
        int substr_len = pmatch.rm_eo;

        Log("match rules[%d] = \"%s\" at position %d with len %d: %.*s",
            i, rules[i].regex, position, substr_len, substr_len, substr_start);

        position += substr_len;

        switch (rules[i].token_type) {
          case TK_NOTYPE: {
            break;
          }
          case TK_DEC: // Special expression
          case TK_HEX:
          case TK_REG: {
            tokens[nr_token].type = rules[i].token_type;
            sprintf(tokens[nr_token ++].str, "%s", substr_start);
            break;
          }
          default: { // Common one character
            tokens[nr_token ++].type = rules[i].token_type;
          }
        }

        break;
      }
    }

    if (i == NR_REGEX) {
      printf("no match at position %d\n%s\n%*.s^\n", position, e, position, "");
      return false;
    }
  }

  return true;
}

bool check_parentheses(uint32_t l, uint32_t r) {
  if (tokens[l].type != '(' || tokens[r].type != ')') {
    return false;
  }
  uint32_t pars = 0;
  for (uint32_t i = l + 1; i < r; i ++) {
    if (tokens[i].type == '(') pars ++;
    else if (tokens[i].type == ')') pars --;
    
    if (pars < 0) return false;
  }
  return pars == 0;
}

int token_prior (int type) { //LUT
  switch (type) {
    case '+':
    case '-': {
      return 5;
    }
    case '*':
    case '/': {
      return 6;
    }
  }
}

uint32_t major_pos(uint32_t l, uint32_t r) {
  uint32_t pars = 0, pos = -1;
  for (uint32_t i = l; i <= r ; i ++) {

  } 
}

word_t eval(uint32_t l, uint32_t r, bool *success) {
  if (*success == false) {
    return 0;
  }

  if (l > r) {
    *success = false;
    return 0;
  }
  else if (l == r) {
    switch (tokens[l].type) {
      case TK_DEC: {
        return strtoul(token[l].str, NULL, 10);
      }
      case TK_HEX: {
        return strtoul(token[l].str, NULL, 16);
      }
      case TK_REG: {
        return isa_reg_str2val(token[l].str, success);
      }
      default: {
        *success = false;
        return 0;
      }
    }
  }
  else if (check_parentheses(l, r) == true) {
    return eval(p + 1, q - 1, success);
  }
  else {
    uint32_t mid = major_pos(l, r);

    word_t res1 = eval(l, mid - 1, success);
    word_t res2 = eval(mid + 1, r, success);

    switch (tokens[mid].type) {
      case '+': return res1 + res2;
      case '-': return res1 - res2;
      case '*': return res1 * res2;
      case '/': {
        if (res2 == 0) {
          *success = false;
          return 0;
        }
        return res1 / res2;
      }
      default: {
        *success = false;
        return 0;
      }
    }
  }
}

word_t expr(char *e, bool *success) {
  if (!make_token(e)) {
    *success = false;
    return 0;
  }
  
  word_t ans = eval(0, nr_token - 1, success);

  return ans;
}
