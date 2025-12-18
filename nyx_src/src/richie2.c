
struct Josh {
    int value;
};

int foo() {
    return 42;
}

int main() {

    // Assignment
    int y = 25;
    printf("Value of y: %d\n", y); // Should print 25

    // Function call
    int x = foo();
    printf("Value of x: %d\n", x); // Should print 42

    // Struct declaration and usage
    int z = 10;
    struct Josh n = { .value = z };
    printf("Josh value: %d\n", n.value); // Should print 10


    // Control flow
    int cat = 5;
    if (cat < 10) {
        cat = cat + 1;
    } else {
        cat = cat - 1;
    }
    printf("Final value of kitty: %d\n", cat); // Should print 6


    // For loop
    int foo = 5;
    for (int i = 0; i < 10; i = i + 1) {
        foo = foo + i;
    }
    printf("Final value of foo: %d\n", foo); // Should print 50

    // While loop
    int fah = 5;
    while (fah < 10)
    {
        fah = fah + 1;
    }
    printf("Final value of fah: %d\n", fah); // Should print 10

    return 0;
}