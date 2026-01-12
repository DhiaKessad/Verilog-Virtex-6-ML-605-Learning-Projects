#include<stdio.h>

int main(void){
    int A[] = {5, 2, 9, 1, 5, 6};
    int n = sizeof(A)/ sizeof(int);

    for (int i = 1; i<n; i++){
        int j = i;
        while(j >0 && A[j-1]>A[j]){
            int t = A[j];
            A[j] = A[j-1];
            A[j-1] = t;
            j--;
        }
    }
    printf("the array is:\n");
    for(int i = 0; i<n; i++){
        printf("%d, ", A[i]);
    }
}