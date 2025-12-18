
int iter_fibby(int nth){
    if (nth < 2){
        return nth;
    }
    int a = 0;
    int b = 1;
    for (int i = 1; i < nth; i++){
        int c = a + b;
        a = b;
        b = c;
    }
    return b;
}

int main() {
    printf("Nth element of fibonacci iteratively: %d\n", iter_fibby(7)); // 7th Fibonacci number is 13
    return 0;
}
