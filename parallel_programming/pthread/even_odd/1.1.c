#include <stdio.h>
#include <pthread.h>

static void *third_thread_func(void *i)
{
	printf("Thread three: %ld\n", (long)i);
	pthread_exit(NULL);
}

static void *second_thread_func(void *i)
{
	pthread_t thread;

	if((long)i % 2 == 0)
	{
		pthread_create(&thread, NULL, third_thread_func, (void*)i);
		pthread_join(thread, NULL);
	}
	else
	{
		printf("Thread two: %ld\n", (long)i);
	}
	pthread_exit(NULL);
}

static void *first_thread_func()
{
	long i;
	pthread_t thread;

	for(i = 1; i <= 100; ++i)
	{
		pthread_create(&thread, NULL, second_thread_func, (void*)i);
		pthread_join(thread, NULL);
	}
	pthread_exit(NULL);
}

int main()
{
	pthread_t thread;

	pthread_create(&thread, NULL, first_thread_func, NULL);
	pthread_exit(NULL);
}