#include <stdio.h>
#include <pthread.h>

pthread_mutex_t mutex_param;

static void *third_thread_func()
{
	printf("Thread three: %d\n", (int)i);
	pthread_exit(NULL);
}

static void *second_thread_func()
{
	pthread_t thread;

	if((int)i % 2 == 0)
	{
		if(!pthread_create(&thread, NULL, third_thread_func, NULL))
		{
			printf("Error: thread not created\n");
		}
	}
	else
	{
		printf("Thread two: %d\n", mutex_param);
	}
	pthread_exit(NULL);
}

static void *first_thread_func()
{
	pthread_t thread;

	if(!pthread_create(&thread, NULL, second_thread_func, NULL))
	{
		printf("Error: thread not created\n");
	}
	pthread_exit(NULL);
}

int main()
{
	pthread_t thread;

	pthread_mutex_init(&mutex_param, 0);

	if(!pthread_create(&thread, NULL, first_thread_func, NULL))
	{
		printf("Error: thread not created\n");
	}
	pthread_mutex_destroy(&mutex_param);
	pthread_exit(NULL);
}