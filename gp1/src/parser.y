%{ 
#include <stdio.h>
#include "parser.tab.h"
#include <string.h>

int yylex(void);
void yyerror(const char *s);

// Declare Extern Functions 
extern double zig_add(double a, double b);
extern void zig_print_result(double a);
extern double zig_minus(double a, double b);
extern double zig_mul(double a, double b);
extern double zig_div(double a, double b);
extern void zig_var_init(const char *name, double val);
extern double zig_var(const char *name);
extern double zig_var_inc(const char *name);
extern double zig_var_dec(const char *name);
%}

// Definitions

%union {
    double num;    /* for numbers */
    char* id;      /* for variable names (strings) */
}

%token <num> NUMBER
%token <id> VAR
%token INCREMENT
%token DECREMENT
%type <num> expr factor term statement program post
%token END PROGRAM_END

%%

// Grammar Rules
goal: program PROGRAM_END // ToDO we need to make some sort of end of program token \\n is not working 
program: statement END { zig_print_result($1); } // First statement
       | program statement END { zig_print_result($2); }; // Subsequent statements
statement: 
    VAR '=' expr { zig_var_init($1, $3); $$ = $3; }
    | expr { $$ = $1; };
expr: 
      expr '+' term { $$ = zig_add($1, $3); } 
    | expr '-' term{ $$ = zig_minus($1, $3); }
    | term;
term: term '*' post { $$ = zig_mul($1, $3); }
    | term '/' post { $$ = zig_div($1, $3); }
    | post;
post: factor 
    | VAR INCREMENT  { $$ = zig_var_inc($1); }
    | VAR DECREMENT  { $$ = zig_var_dec($1); }
factor: 
    NUMBER { $$ = $1; } 
    | VAR { $$ = zig_var($1); }
    | '(' expr ')' { $$ = $2; }
%%
