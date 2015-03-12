#include <stdio.h>
#include <sys/time.h>
#include <pthread.h>
#include <malloc.h>

#define M 3

long j, k;

double MAD, MA[M][M + 1] = { // -4.313, 32.875, -30.438
    { 3.0, 4.0, 7.0, 10.0 },
    { 6.0, 7.0, 8.0, 13.0 },
    { 4.0, 5.0, 2.0, 34.0 },
};

static void *routine(void *param)
{
    long i = (long)param;

    for (j = M; j >= k; j--)
        MA[i][j] -= MA[i][k] * MA[k][j];

    pthread_exit(NULL);
}

int main()
{
    long i;
    pthread_t* thread = (pthread_t*) malloc(M * sizeof(pthread_t));
    struct timeval tv1, tv2;
    float time_seconds;

    gettimeofday(&tv1, NULL);

    /* Прямой ход */
    for (k = 0; k < M; k++)
    {
        MAD = 1.0 / MA[k][k];

        for (j = M; j >= k; j--)
        {
            MA[k][j] *= MAD;
        }

        for (i = k + 1; i < M; i++)
        {
            pthread_create(&thread[i], NULL, routine, (void*)i);
        }

        for (i = k + 1; i < M; i++)
        {
            pthread_join(thread[i], NULL);
        }
    }

    /* Обратный ход */
    for (k = M - 1; k >= 0; k--)
    {
        for (i = k - 1; i >= 0; i--)
        {
            MA[i][M] -= MA[k][M] * MA[i][k];
        }
    }

    gettimeofday(&tv2, NULL);
    time_seconds = tv2.tv_sec - tv1.tv_sec + 0.000001 * (tv2.tv_usec - tv1.tv_usec);
    printf("Time = %.8f\n", time_seconds);

    for(i = 0; i < M; i++)
    {
        printf("%f   ", MA[i][M]);
    }
    printf("\n");

    return 0;
}