%{ 
#include <stdio.h>
#include "parser.tab.h"
int yylex(void);
void yyerror(const char *s);

// Declare Extern Functions 
extern double zig_add(double a, double b);
extern void zig_print_result(double a);
extern double zig_minus(double a, double b);
extern double zig_mul(double a, double b);
extern double zig_div(double a, double b);
%}

// Definitions

%define api.value.type {double}

%token NUMBER

%%

// Grammar Rules
goal: expr {
    zig_print_result($1);
};
expr: 
      expr '+' factor { $$ = zig_add($1, $3); } 
    | expr '-' factor{ $$ = zig_minus($1, $3); }
    | factor;
factor: expr '*' term { $$ = zig_mul($1, $3); }
    | expr '/' term { $$ = zig_div($1, $3); }
    | term;
term: NUMBER 
      | '(' expr ')' { $$ = $2; }
%%
