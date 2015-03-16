#include <stdio.h>
#include <pthread.h>

int even = 2, odd = 1;

static void *third_thread_func()
{
	printf("Thread three: %d\n", even);
	pthread_exit(NULL);
}

static void *second_thread_func()
{
	printf("Thread two: %d\n", odd);
	pthread_exit(NULL);
}

static void *first_thread_func()
{
	pthread_t second_thread, third_thread;

	while(even < 102 && odd < 101)
	{
		pthread_create(&second_thread, NULL, second_thread_func, NULL);
		pthread_join(second_thread, NULL);

		pthread_create(&third_thread, NULL, third_thread_func, NULL);
		pthread_join(third_thread, NULL);

		even += 2;
		odd += 2;
	}
	pthread_exit(NULL);
}

int main()
{
	pthread_t thread;

	pthread_create(&thread, NULL, first_thread_func, NULL);
	pthread_exit(NULL);
}