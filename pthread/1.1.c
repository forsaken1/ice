#include <stdio.h>
#include <pthread.h>

static void *third_thread_func(void *i)
{
	printf("Thread three: %d\n", (int)i);
	pthread_exit(NULL);
}

static void *second_thread_func(void *i)
{
	pthread_t thread;

	if((int)i % 2 == 0)
	{
		if(!pthread_create(&thread, NULL, third_thread_func, i))
		{
			printf("Error: thread not created\n");
		}
	}
	else
	{
		printf("Thread two: %d\n", (int)i);
	}
	pthread_exit(NULL);
}

static void *first_thread_func()
{
	int i;
	pthread_t thread;

	for(i = 1; i <= 100; ++i)
	{
		if(!pthread_create(&thread, NULL, second_thread_func, (void *)i))
		{
			printf("Error: thread not created\n");
		}
	}
	pthread_exit(NULL);
}

int main()
{
	int i;
	pthread_t thread;

	if(!pthread_create(&thread, NULL, first_thread_func, NULL))
	{
		printf("Error: thread not created\n");
	}
	pthread_exit(NULL);
}