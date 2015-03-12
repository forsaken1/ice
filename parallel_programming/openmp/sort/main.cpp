#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <sys/time.h>

#define N 100
#define K 25
#define IS_LESS(v1, v2)  (v1 < v2)
#define SWAP(r, s) { int t = r; r = s; s = t; }

#include "heap_sort.cpp"
#include "merge_sort.cpp"
#include "insertion_sort.cpp"
#include "quick_sort.cpp"

float calc_time(struct timeval &timev1, struct timeval &timev2)
{
    return timev2.tv_sec - timev1.tv_sec + 0.000001 * (timev2.tv_usec - timev1.tv_usec);
}

float time_wrapper( void (*f)(int*, int, void (*)(int*, int) ),
                    void (*s)(int*, int),
                    int *a,
                    int n )
{
    struct timeval timev1, timev2;

    gettimeofday(&timev1, NULL);
    (*f)(a, n, s);
    gettimeofday(&timev2, NULL);

    return calc_time(timev1, timev2);
}

int main(int argc, char *argv[])
{
    int a1[N], a2[N], a3[N], a4[N], n = 0, t;
    FILE *file = fopen("array.txt", "r");

    /* считываем с файла */
    while(fscanf(file, "%d", &t) != EOF)
    {
        if(n > N) break;

        a1[n] = a2[n] = a3[n] = a4[n] = t;
        //printf("%d ", a[n]);
        n++;
    }

    /* сравниваем время */
    printf("Quick-Heap: %f\n",      time_wrapper(quick_sort, heap_sort,         a1, n) );
    printf("Quick-Insertion: %f\n", time_wrapper(quick_sort, insertion_sort,    a2, n) );
    printf("Merge-Heap: %f\n",      time_wrapper(merge_sort, heap_sort,         a3, n) );
    printf("Merge-Insertion: %f\n", time_wrapper(merge_sort, insertion_sort,    a4, n) );

    /* можно распечатать отсортированный массив */
    for(int i = 0; i < N; i++)
    {
        //printf("%d ", a1[i]);
    }
    return 0;
}
