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
 
//void merge_sort(int *a, int n, void (*s)(int*, int))
static void *merge_heap_sort(void *thread_data)
{
    pthread_t first, second;
    t_data *d = (t_data*)thread_data;
    int n = d->n;
    int *a = d->a;

    free(thread_data);
    free(d);

    if(n < 2)
        pthread_exit(NULL);

    if(n > K)
    {
        int m = n / 2;
        t_data *f = (t_data*)malloc(sizeof(t_data)), *s = (t_data*)malloc(sizeof(t_data));

        f->a = a;
        f->n = m;
        s->a = a + m;
        s->n = n - m;

        pthread_create(&first, NULL, merge_heap_sort, (void*)f);
        pthread_create(&second, NULL, merge_heap_sort, (void*)s);

        pthread_join(first, NULL);
        pthread_join(second, NULL);
        
        //merge_sort(a, m, s);
        //merge_sort(a + m, n - m, s);
        merge(a, n, m);
    }
    else
    {
        heap_sort(a, n);
    }
    pthread_exit(NULL);
}