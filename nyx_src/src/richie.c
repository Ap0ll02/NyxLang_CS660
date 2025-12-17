int main() {
    int x = 5;
    return x;
}

// main:
//     addi sp, sp, -16
//     sw   s1, 12(sp)      # save callee-saved if you use it
//     addi s1, sp, 0

//     li   t1, 5
//     sw   t1, 0(s1)
//     lw   a0, 0(s1)       # return value in a0

//     lw   s1, 12(sp)      # restore
//     addi sp, sp, 16
//     ret

// or even better:

// main:
//     li a0, 5
//     ret

// Some hard code:

// int main() {
//   int a=1,b=2,c=3,d=4,e=5,f=6,g=7,h=8,i=9,j=10,k=11,l=12;
//   int s = a+b+c+d+e+f+g+h+i+j+k+l;
//   return (s == 78) ? 0 : 1;
// }

// int main() {
//   int x = 0;
//   for (int i=0; i<100; i++) {
//     if (i & 1) x += i;
//     else x -= i;
//   }
//   return (x == -50) ? 0 : 1;
// }

