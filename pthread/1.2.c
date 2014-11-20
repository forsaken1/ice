#include <stdio.h>
#include <pthread.h>

int iter = 0;

static void *third_thread_func()
{
	pthread_exit(NULL);
}

static void *second_thread_func()
{
	pthread_t thread;

	if(pthread_create(&thread, NULL, third_thread_func, NULL))
	{
		pthread_join(thread, NULL);
		iter++;
	}
	pthread_exit(NULL);
}

static void *first_thread_func()
{
	pthread_t thread;

	while(iter <= 100)
	{
		if(pthread_create(&thread, NULL, second_thread_func, NULL))
		{
			pthread_join(thread, NULL);
			iter++;
		}
	}
	pthread_exit(NULL);
}

int main()
{
	pthread_t thread;

	pthread_create(&thread, NULL, first_thread_func, NULL);
	pthread_exit(NULL);
}