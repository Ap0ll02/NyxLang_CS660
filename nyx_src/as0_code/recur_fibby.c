
int recursive_fibby(int nth){
    if (nth < 2){
        return nth;
    }
    return recursive_fibby(nth - 1) + recursive_fibby(nth - 2);
}

int main() {
    printf("Nth element of fibonacci using Recursion: %d\n", recursive_fibby(7)); // 7th Fibonacci number is 13
    return 0;
}
