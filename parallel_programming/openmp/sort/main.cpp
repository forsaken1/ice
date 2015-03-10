#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include "heap_sort.cpp"
#include "merge_sort.cpp"
#include "insertion_sort.cpp"
#include "quick_sort.cpp"

void sort(a, n)
{
    quick_sort(a, n);
}

int main(int argc, char *argv[])
{
    int a[] = {4, 65, 2, -31, 0, 99, 2, 83, 782, 1};
    int n = sizeof a / sizeof a[0], i;

    for (i = 0; i < n; i++)
        printf("%d%s", a[i], i == n - 1 ? "\n" : " ");

    sort(a, n);

    for (i = 0; i < n; i++)
        printf("%d%s", a[i], i == n - 1 ? "\n" : " ");
    
    return 0;
}