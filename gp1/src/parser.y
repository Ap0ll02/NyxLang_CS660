%{
#include <stdio.h>
#include "parser.tab.h"
int yylex(void);
void yyerror(const char *s);
%}

// Definitions

%define api.value.type {double}

%token NUMBER

%%

// Grammar Rules
goal: expr;
expr: expr '+' factor | factor;
factor: NUMBER | '(' expr ')';

%%

// Raw User Code
