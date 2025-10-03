#include <stdio.h>
#include "c11.tab.h"
int yyparse(void);

int main(int argc, char *argv[]) {
    yyparse();
    printf("There is a thing\n");
}
