void quick_sort(int *a, int n, void (*s)(int*, int))
{
    int i, j, p, t;

    if(n < 2)
        return;

    if(n > K)
    {
        p = a[n / 2];
        for(i = 0, j = n - 1;; i++, j--)
        {
            while (a[i] < p)
                i++;
            while (p < a[j])
                j--;
            if (i >= j)
                break;
            SWAP( a[i], a[j] );
        }

        #pragma omp parallel sections num_threads(2)
        {
            #pragma omp section
            quick_sort(a, i, s);

            #pragma omp section
            quick_sort(a + i, n - i, s);
        }
    }
    else
    {
        s(a, n);
    }
}