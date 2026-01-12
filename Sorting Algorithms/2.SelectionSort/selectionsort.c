#include<stdio.h>

void select(int A[], int n){
    for (int i = 0; i<n; i++){
        int min = i;
        for(int j = i+1; j<n; j++){
            if(A[j]<A[min]){
                min = j;
            }
        }
        if(min != i){
        int t = A[i];
        A[i] = A[min];
        A[min] = t;
        }
        
    }
}

void printarr(int A[], int n){
    printf("the array is:\n");
    for(int i = 0; i<n; i++){
        printf("%d, ", A[i]);
    }
}
int main(void){
    int A[] = {5, 1, 4, 2, 8};
    int n = sizeof(A)/ sizeof(int);
    printarr(A, n);

    select(A, n);
    printarr(A, n);
}