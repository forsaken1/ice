#include <stdio.h>
#include <sys/time.h>

#define M 2

int main()
{
    int i, j, v, k;
    double MAD, MA[][] = { { 3.0, 4.0 }, { 6.0, 7.0 } }

    /* Переменные для замера времени решения */
    struct timeval tv1, tv2;
    long int dt1;

    /* Генерация данных */
    /*for (i = 0; i < M; i++)
    {
        for (j = 0; j < M; j++)
        {
            if (i == j)
                MA[i][j] = 7.0;
            else
                MA[i][j] = 1.0;
        }
        MA[i][M] = 1.0 * (M) + 1.0;
    }*/

    gettimeofday(&tv1, NULL);

    /* Прямой ход */
    for (k = 0; k < M; k++)
    {
        MAD = 1.0 / MA[k][k];

        for (j = M; j >= k; j--)
            MA[k][j] *= MAD;

        for (i = k + 1; i < M; i++)
            for (j = M; j >= k; j--)
                MA[i][j] -= MA[i][k] * MA[k][j];
    }

    /* Обратный ход */
    for (k = M - 1; k >= 0; k--)
    {
        for (i = k - 1; i >= 0; i--)
            MA[i][M] -= MA[k][M] * MA[i][k];
    }

    /* Засечение времени и печать */
    gettimeofday(&tv2, NULL);
    dt1 = (tv2.tv_sec - tv1.tv_sec) * 1000000 + tv2.tv_usec - tv1.tv_usec;
    printf("Time = %ld\n", dt1);

    /* Печать первых восьми корней */
    printf(" %f %f\n", MA[0][M], MA[1][M]);//, MA[2][M], MA[3][M]);
    //printf(" %f %f %f %f\n", MA[4][M], MA[5][M], MA[6][M], MA[7][M]);

    return (0);
}