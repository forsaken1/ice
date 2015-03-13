void *quick_heap_sort(void *thread_data)
{
    pthread_t first, second;
    t_data *d; d = (t_data*)thread_data;
    int i, n = d->n;
    int *a = d->a;

    if(n > 1)
    {
        if(n > K)
        {
            int j, m = a[n / 2];
            t_data  *f = (t_data*)malloc(sizeof(t_data)),
                    *s = (t_data*)malloc(sizeof(t_data));

            f->a = a;
            f->n = m;
            s->a = a + m;
            s->n = n - m;

            for(i = 0, j = n - 1;; i++, j--)
            {
                while (a[i] < m)
                    i++;
                while (m < a[j])
                    j--;
                if (i >= j)
                    break;
                SWAP( a[i], a[j] );
            }

            //quick_sort(a, i, s);
            //quick_sort(a + i, n - i, s);

            pthread_create(&first, NULL, quick_heap_sort, (void*)f);
            pthread_create(&second, NULL, quick_heap_sort, (void*)s);

            pthread_join(first, NULL);
            pthread_join(second, NULL);
        }
        else
        {
            heap_sort(a, n);
        }
    }
    free(thread_data);
    pthread_exit(NULL);
}

void *quick_insertion_sort(void *thread_data)
{
    pthread_t first, second;
    t_data *d; d = (t_data*)thread_data;
    int i, n = d->n;
    int *a = d->a;

    if(n > 1)
    {
        if(n > K)
        {
            int j, m = a[n / 2];
            t_data  *f = (t_data*)malloc(sizeof(t_data)),
                    *s = (t_data*)malloc(sizeof(t_data));

            f->a = a;
            f->n = m;
            s->a = a + m;
            s->n = n - m;

            for(i = 0, j = n - 1;; i++, j--)
            {
                while (a[i] < m)
                    i++;
                while (m < a[j])
                    j--;
                if (i >= j)
                    break;
                SWAP( a[i], a[j] );
            }

            pthread_create(&first, NULL, quick_heap_sort, (void*)f);
            pthread_create(&second, NULL, quick_heap_sort, (void*)s);

            pthread_join(first, NULL);
            pthread_join(second, NULL);
        }
        else
        {
            insertion_sort(a, n);
        }
    }
    free(thread_data);
    pthread_exit(NULL);
}