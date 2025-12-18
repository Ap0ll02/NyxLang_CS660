
void swap_by_ptr(int *ptr1, int *ptr2){
    int tmp = *ptr1;
    *ptr1 = *ptr2;
    *ptr2 = tmp;
}

// Before swap: 142, 632
// After swap: 632, 142

int main(){
    int num1 = 142;
    int num2 = 632;
    printf("Before swap: %d, %d", num1, num2);
    swap_by_ptr(&num1, &num2);
    printf("\nAfter swap: %d, %d\n", num1, num2);
    return 0;
}
