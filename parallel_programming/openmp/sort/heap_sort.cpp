void sift_down(int *a, int start, int end)
{
    int root = start;

    while ( root * 2 + 1 < end ) {
        int child = 2 * root + 1;
        if ((child + 1 < end) && IS_LESS(a[child], a[child + 1])) {
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

void heap_sort(int *a, int count)
{
    int start, end;

    for (start = (count - 2) / 2; start >= 0; start--) {
        sift_down(a, start, count);
    }

    for (end = count - 1; end > 0; end--) {
        SWAP(a[end], a[0]);
        sift_down(a, 0, end);
    }
}
