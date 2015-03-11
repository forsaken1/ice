#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <string>

using namespace std;

int main(int argc, char *argv[])
{
    int a = 1;
    int thread_count = atoi(argv[1]);
    bool shared_mode = string(argv[2]) == "shared";
    bool private_mode = string(argv[2]) == "private";
    bool firstprivate_mode = string(argv[2]) == "firstprivate";
    bool lastprivate_mode = string(argv[2]) == "lastprivate";
    bool copyprivate_mode = string(argv[2]) == "copyprivate";

    // shared
    if(shared_mode)
    {
        #pragma omp parallel num_threads(thread_count) shared(a)
        {
            printf("В потоке %d a = %d\n", omp_get_thread_num(), a += 2);
        }
    }

    // private
    if(private_mode)
    {
        #pragma omp parallel num_threads(thread_count) private(a)
        {
            printf("В потоке %d a = %d\n", omp_get_thread_num(), a += 2);
        }
    }

    // firstprivate
    if(firstprivate_mode)
    {
        #pragma omp parallel num_threads(thread_count) firstprivate(a)
        {
            printf("В потоке %d a = %d\n", omp_get_thread_num(), a += 2);
        }
    }

    // lastprivate
    if(lastprivate_mode)
    {
        #pragma omp num_threads(thread_count) lastprivate(a)
        {
            printf("В потоке %d a = %d\n", omp_get_thread_num(), a += 2);
        }
    }

    // copyprivate
    /*#pragma omp parallel if(copyprivate_mode) num_threads(thread_count) threadprivate(a)
    {
        printf("В потоке %d a = %d\n", omp_get_thread_num(), a += 2);
    }*/
    printf("Возврат в главный поток со значением переменной a = %d\n", a);
    printf("Число потоков: %d, тип данных: %s\n", thread_count, argv[2]);
}