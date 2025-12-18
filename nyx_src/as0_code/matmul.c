
void matmul(float mat1[4][4], float mat2[4][4], float result_mat[4][4]){
    for (int i = 0; i < 4; i++){
        for(int j = 0; j < 4; j++){
            result_mat[i][j] = 0;
            for(int k = 0; k < 4; k++){
                result_mat[i][j] += mat1[i][k] * mat2[k][j];
            }
        }
    }
}

void print_mat(float mat[4][4]) {
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            printf("%f\t", mat[i][j]);
        }
        printf("\n");
    }
}

int main(){
    float mat1[4][4] = {
        {1.1, 2.2, 3.3, 4.4},
        {4.2, 3.1, 2.0, 1.0},
        {5.3, 6.4, 7.8, 8.3},
        {9.12, 11.11, 12.21, 13.2}
    };
    float mat2[4][4] = {
        {2.11, 1.21, 4.3, 12.3},
        {11.2, 10.11, 9.1, 8.2},
        {7.3, 6.4, 3.5, 12.6},
        {12.11, 21.9, 11.8, 4.7}
    };
    float result_mat[4][4];

    printf("First Matrix:\n");
    print_mat(mat1);
    printf("\nSecond Matrix:\n");
    print_mat(mat2);

    matmul(mat1, mat2, result_mat);
    printf("\nResult Matrix:\n");
    print_mat(result_mat);

    /*
First Matrix:
1.100000        2.200000        3.300000        4.400000
4.200000        3.100000        2.000000        1.000000
5.300000        6.400000        7.800000        8.300000
9.120000        11.110000       12.210000       13.200000

Second Matrix:
2.110000        1.210000        4.300000        12.300000
11.200000       10.110000       9.100000        8.200000
7.300000        6.400000        3.500000        12.600000
12.110000       21.900000       11.800000       4.700000

Result Matrix:
104.334999      141.053009      88.220001       93.830002
70.292000       71.122993       65.070000       106.979996
240.316010      302.807007      206.270004      254.960007
392.660187      490.581299      338.812012      419.164032
    */

    return 0;
}
