#include <stdio.h>
#include <pthread.h>

pthread_mutex_t mutex;
int iter = 0;

static void *third_thread_func()
{
	pthread_mutex_lock(&mutex);
	if(iter % 2)
	{
		++iter;
		printf("Thread three: %d\n", iter);
	}
	pthread_mutex_unlock(&mutex);
	pthread_exit(NULL);
}

static void *second_thread_func()
{
	pthread_t thread;

	pthread_mutex_lock(&mutex);
	if(iter % 2 == 0)
	{
		++iter;
		printf("Thread two: %d\n", iter);
	}
	pthread_mutex_unlock(&mutex);

	pthread_create(&thread, NULL, third_thread_func, NULL);
	pthread_exit(NULL);
}

static void *first_thread_func()
{
	pthread_t thread;

	while(iter <= 100)
	{
		pthread_create(&thread, NULL, second_thread_func, NULL);
	}
	pthread_exit(NULL);
}

int main()
{
	pthread_t thread;

	pthread_mutex_init(&mutex, 0);
	pthread_create(&thread, NULL, first_thread_func, NULL);
	pthread_mutex_destroy(&mutex);
	pthread_exit(NULL);
}