%{
#include "parser.tab.h"
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
%}

%option always-interactive
%option noyywrap


%%
[ \t\n\r] {}
[0-9]+(\.[0-9]*)?([+-]?[eE][0-9]+)? {
    yylval.num = atof(yytext);
    return NUMBER;
}
"++" {return INCREMENT; }
"--" {return DECREMENT; }
[a-zA-Z_][a-zA-Z0-9_]* {
    //strdup does not work with c99 so we are going to use manual memory allocation
    yylval.id = malloc(strlen(yytext) + 1);
    strcpy(yylval.id, yytext);
    return VAR;
}
; { return END; }
\\n { return PROGRAM_END; } // ends program 

. { return yytext[0]; }

%%

