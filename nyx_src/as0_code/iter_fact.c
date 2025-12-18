
int iter_factorial(int num) {
    int facty = 1;
    for (int i = 1; i < num + 1; i ++){
        facty *= i;
    }
    return facty;
}

int main() {
    printf("Iterative factorial: %d\n", iter_factorial(7)); // 7! = 5040
    return 0;
}
