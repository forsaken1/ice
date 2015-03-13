void merge(int *a, int n, int m)
{
    int i, j, k;
    int *x = (int*)malloc(n * sizeof (int));
    for (i = 0, j = m, k = 0; k < n; k++)
    {
        x[k] = j == n      ? a[i++]
             : i == m      ? a[j++]
             : a[j] < a[i] ? a[j++]
             :               a[i++];
    }
    for (i = 0; i < n; i++)
    {
        a[i] = x[i];
    }
    free(x);
}

void *merge_heap_sort(void *thread_data)
{
    pthread_t first, second;
    t_data *d = (t_data*)thread_data;
    int i, n = d->n;
    int *a = d->a;
    
    printf("%d\n", n); //удалить
    for(i = 0; i < N; i++)
    {
        printf("%d ", a[i]);
    }
    printf("\n");

    if(n > 1)
    {
        if(n > K)
        {
            int m = n / 2;
            t_data  *f = (t_data*)malloc(sizeof(t_data)),
                    *s = (t_data*)malloc(sizeof(t_data));

            f->a = a;
            f->n = m;
            s->a = a + m;
            s->n = n - m;

            pthread_create(&first, NULL, merge_heap_sort, (void*)f);
            pthread_create(&second, NULL, merge_heap_sort, (void*)s);

            pthread_join(first, NULL);
            pthread_join(second, NULL);
            
            //merge_sort(a, m, s); //удалить
            //merge_sort(a + m, n - m, s);
            merge(a, n, m);
        }
        else
        {
            heap_sort(a, n);
        }
    }
    free(thread_data);
    pthread_exit(NULL);
}

void *merge_insertion_sort(void *thread_data)
{
    pthread_t first, second;
    t_data *d = (t_data*)thread_data;
    int i, n = d->n;
    int *a = d->a;

    if(n > 1)
    {
        if(n > K)
        {
            int m = n / 2;
            t_data  *f = (t_data*)malloc(sizeof(t_data)),
                    *s = (t_data*)malloc(sizeof(t_data));

            f->a = a;
            f->n = m;
            s->a = a + m;
            s->n = n - m;

            pthread_create(&first, NULL, merge_heap_sort, (void*)f);
            pthread_create(&second, NULL, merge_heap_sort, (void*)s);

            pthread_join(first, NULL);
            pthread_join(second, NULL);
            
            merge(a, n, m);
        }
        else
        {
            insertion_sort(a, n);
        }
    }
    free(thread_data);
    pthread_exit(NULL);
}