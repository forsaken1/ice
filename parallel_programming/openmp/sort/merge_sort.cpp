void merge(int *a, int n, int m)
{
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
 
void merge_sort(int *a, int n, void (*s)(int*, int))
{
    if(n < 2) return;

    if(n > K)
    {
        int m = n / 2;

        #pragma omp parallel sections num_threads(2)
        {
            #pragma omp section
            merge_sort(a, m, s);

            #pragma omp section
            merge_sort(a + m, n - m, s);
        }
        merge(a, n, m);
    }
    else
    {
        s(a, n);
    }
}