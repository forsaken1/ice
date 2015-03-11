#include <stdio.h>
#include <pthread.h>

pthread_mutex_t mutex;
int iter = 1;
int odd = 1;

static void *third_thread_func()
{
	while(iter <= 100)
	{
		if(!odd)
		{
			pthread_mutex_lock(&mutex);
			printf("Thread three: %d\n", iter++);
			odd = 1;
			pthread_mutex_unlock(&mutex);
		}
	}
	pthread_exit(NULL);
}

static void *second_thread_func()
{
	while(iter < 100)
	{
		if(odd)
		{
			pthread_mutex_lock(&mutex);
			printf("Thread two: %d\n", iter++);
			odd = 0;
			pthread_mutex_unlock(&mutex);
		}
	}
	pthread_exit(NULL);
}

static void *first_thread_func()
{
	pthread_t second_thread, third_thread;

	pthread_create(&second_thread, NULL, second_thread_func, NULL);
	pthread_create(&third_thread, NULL, third_thread_func, NULL);

	pthread_join(second_thread, NULL);
	pthread_join(third_thread, NULL);

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