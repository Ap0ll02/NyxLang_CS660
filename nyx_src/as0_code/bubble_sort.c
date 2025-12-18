
void bubble_sort(int arr[], int size){
    for (int i = 0; i < size - 1; i++){
        for (int j = 0; j < size - i - 1; j++){
            if (arr[j] > arr[j+1]){
                int tmp = arr[j];
                arr[j] = arr[j+1];
                arr[j+1] = tmp;
            }
        }
    }
}

void print_arr(int arr[], int size){
    for (int i = 0; i < size; i++){
        printf("%d ", arr[i]);
    }
}

int main() {
    int size = 4;
    int arr[] = {120, 3, 1922, 1};
    printf("Bubble sort:\n\tOriginal arr: ");
    print_arr(arr, size);
    printf("\n");
    
    printf("\tSorted arr: ");
    bubble_sort(arr, size);
    print_arr(arr, size);
    printf("\n");
    return 0;

/*
Bubble sort:
    Original arr: 120 3 1922 1 
    Sorted arr: 1 3 120 1922 
*/
}
