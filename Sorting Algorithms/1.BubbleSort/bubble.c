#include<stdio.h>

int main(void){ 
    int A[] = {5, 1, 4, 2, 8};
    int n = sizeof(A)/ sizeof(int);

    int i = 0;
    while(i < n-1){
        int j = 0;
        while(j< n-1-i){
            if (A[j]>A[j+1]){
                int k = A[j];
                A[j] = A[j+1];
                A[j+1] = k;
            }
            j++;
        }
        i++;
    }
    int y = 0;
    printf("The sorted list is:\n");
    while(y < n){
        printf("%d", A[y]);
        y++;
    }
    return 0;
}