%{ #include <stdio.h>
#include "parser.tab.h"
int yylex(void);
void yyerror(const char *s);

// Declare Extern Functions 
extern double zig_add(double a, double b);
%}

// Definitions

%define api.value.type {double}

%token NUMBER

%%

// Grammar Rules
goal: expr;
expr: expr '+' factor {$$ = zig_add($1, $3); }
    | factor;
factor: NUMBER 
      | '(' expr ')' { $$ = $2; }

%%
