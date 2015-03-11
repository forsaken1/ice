#include <stdio.h>
#include <pthread.h>
#include <malloc.h>

#define CONSUME_COUNT 2
#define MANUFACTURE_COUNT 5

pthread_mutex_t mutex;
int warehouse = 1000;

static void* manufacturer()
{
    while(1)
    {
        pthread_mutex_lock(&mutex);
        printf("Manufacturer created: %d items; warehouse: %d\n", 
            MANUFACTURE_COUNT, warehouse += MANUFACTURE_COUNT);
        pthread_mutex_unlock(&mutex);
    }
    pthread_exit(NULL);
}

static void* consumer()
{
    while(1)
    {
        pthread_mutex_lock(&mutex);
        if(warehouse >= CONSUME_COUNT)
            printf("Consumer consumed: %d items; warehouse: %d\n", 
                CONSUME_COUNT, warehouse -= CONSUME_COUNT);
        else
            printf("Too small items!\n");
        pthread_mutex_unlock(&mutex);
    }
    pthread_exit(NULL);
}

// входные параметры:
// 1. количество производителей
// 2. количество потребителей
// 3. количество продукции на складе
int main(int argc, char *argv[])
{
    int i;
    int manufacturer_count = atoi(argv[1]);
    int consumer_count = atoi(argv[2]);
    warehouse = atoi(argv[3]);

    pthread_t* manufacturer_thread = (pthread_t*) malloc(manufacturer_count * sizeof(pthread_t));
    pthread_t* consumer_thread = (pthread_t*) malloc(consumer_count * sizeof(pthread_t));

    pthread_mutex_init(&mutex, 0);

    for(i = 0; i < manufacturer_count; ++i)
        pthread_create(&manufacturer_thread[i], NULL, manufacturer, NULL);

    for(i = 0; i < consumer_count; ++i)
        pthread_create(&consumer_thread[i], NULL, consumer, NULL);

    pthread_mutex_destroy(&mutex);

    pthread_exit(NULL);
}