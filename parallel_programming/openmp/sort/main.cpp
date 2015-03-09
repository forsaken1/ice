#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

/* HEAP SORT */

#define IS_LESS(v1, v2)  (v1 < v2)
#define SWAP(r, s) { int t = r; r = s; s = t; }

void sift_down(int *a, int start, int count);
 
void heapsort(int *a, int count)
{
    int start, end;
 
    for (start = (count-2)/2; start >=0; start--) {
        sift_down(a, start, count);
    }
 
    for (end=count-1; end > 0; end--) {
        SWAP(a[end],a[0]);
        sift_down(a, 0, end);
    }
}

void sift_down(int *a, int start, int end)
{
    int root = start;
 
    while ( root*2+1 < end ) {
        int child = 2*root + 1;
        if ((child + 1 < end) && IS_LESS(a[child],a[child+1])) {
            child += 1;
        }
        if (IS_LESS(a[root], a[child])) {
            SWAP( a[child], a[root] );
            root = child;
        }
        else
            return;
    }
}

/* QUICK SORT */

void quick_sort(int *a, int n) {
    int i, j, p, t;
    if (n < 2)
        return;
    p = a[n / 2];
    for (i = 0, j = n - 1;; i++, j--) {
        while (a[i] < p)
            i++;
        while (p < a[j])
            j--;
        if (i >= j)
            break;
        SWAP( a[i], a[j] );
    }
    quick_sort(a, i);
    quick_sort(a + i, n - i);
}

/* MERGE SORT */

void merge(int *a, int n, int m) {
    int i, j, k;
    int *x = (int*)malloc(n * sizeof (int));
    for (i = 0, j = m, k = 0; k < n; k++) {
        x[k] = j == n      ? a[i++]
             : i == m      ? a[j++]
             : a[j] < a[i] ? a[j++]
             :               a[i++];
    }
    for (i = 0; i < n; i++) {
        a[i] = x[i];
    }
    free(x);
}
 
void merge_sort(int *a, int n) {
    if (n < 2)
        return;
    int m = n / 2;
    merge_sort(a, m);
    merge_sort(a + m, n - m);
    merge(a, n, m);
}

/* INSERTION SORT */

void insertion_sort(int *a, int n) {
    int i, j, t;
    for (i = 1; i < n; i++) {
        t = a[i];
        for (j = i; j > 0 && t < a[j - 1]; j--) {
            a[j] = a[j - 1];
        }
        a[j] = t;
    }
}

int main(int argc, char *argv[])
{
    int a[] = {4, 65, 2, -31, 0, 99, 2, 83, 782, 1};
    int n = sizeof a / sizeof a[0];
    int i;
    for (i = 0; i < n; i++)
        printf("%d%s", a[i], i == n - 1 ? "\n" : " ");
    //quick_sort(a, n);
    //merge_sort(a, n);
    //insertion_sort(a, n);
    //heapsort(a, n);
    for (i = 0; i < n; i++)
        printf("%d%s", a[i], i == n - 1 ? "\n" : " ");
    return 0;
}