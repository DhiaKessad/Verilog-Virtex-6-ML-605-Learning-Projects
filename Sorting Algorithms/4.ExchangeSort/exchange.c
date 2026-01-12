#include<stdio.h>

int exchange(int A[], int i, int n){
    if(i<=0){
       
    }else{
        for (int j=0; j< i-1; j++){
            if (A[j]>A[j+1]){
                int t = A[j];
                A[j] = A[j+1];
                A[j+1] = t;
            }
        }
        exchange(A, i-1, n);
    }
    return 0;
}

int main(void){
    int A[] = {5, 4, 6, 2, 8};
    int n = sizeof(A)/ sizeof(int);

    exchange(A, n, n);
    printf("the array is:\n");
        for(int i = 0; i<n; i++){
        printf("%d, ", A[i]);
        }
}