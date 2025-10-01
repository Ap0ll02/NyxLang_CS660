%{
#include "parser.tab.h"
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
%}

%option noyywrap
%option never-interactive


%%

[ \t\n\r] {}
[0-9]+(\.[0-9]*)?([+-]?[eE][0-9]+)? {
    yylval = atof(yytext);
    return NUMBER;
}

. { return yytext[0]; }

%%

