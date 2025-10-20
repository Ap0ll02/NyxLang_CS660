#include <stdio.h>

int main() {

    int* x;
    int** y = &x;
    int*** z = &y;
}
//pointer direct_declarator
//'*' pointer direct_declarator
//'*' '*' pointer direct_declarator
//'*' '*' '*' direct_declarator