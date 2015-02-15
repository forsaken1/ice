#include <stdio.h>
#include <pthread.h>

int even = 2, odd = 1;
void *status_one, *status_two;

static void *third_thread_func()
{
	printf("Thread three: %d\n", even);
	pthread_exit(NULL);
}

static void *second_thread_func()
{
	pthread_t thread;

	printf("Thread two: %d\n", odd);

	pthread_create(&thread, NULL, third_thread_func, NULL);
	pthread_join(thread, &status_two);
	pthread_exit(NULL);
}

static void *first_thread_func()
{
	pthread_t thread;

	while(even < 102 && odd < 101)
	{
		pthread_create(&thread, NULL, second_thread_func, NULL);
		pthread_join(thread, &status_one);
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