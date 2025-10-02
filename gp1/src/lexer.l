%{
#include "parser.tab.h"
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
%}

%option always-interactive
%option noyywrap


%%
[ \t\n\r] {}
[0-9]+(\.[0-9]*)?([+-]?[eE][0-9]+)? {
    yylval = atof(yytext);
    return NUMBER;
}
; { return END; }

. { return yytext[0]; }

%%

