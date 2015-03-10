void quick_calc(int *a, int n)
{
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
    //quick_calc(a, i);
    //quick_calc(a + i, n - i);
}

void quick_sort(int *a, int n)
{
    int m = n / 2;

    quick_calc(a, n);

    #pragma omp parallel sections num_threads(2)
    {
        #pragma omp section
        merge_sort(a, m);

        #pragma omp section
        merge_sort(a + m, n - m);
    }
}