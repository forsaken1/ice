#include <mpi.h>
#include <stdio.h>
#include <string.h>

#define tagCharData 1
#define ELEMS(x) ( sizeof(x) / sizeof(x[0]) )

int main(int argc, char **argv)
{
  int size, rank, i, errCode;
  char charData[50];
  MPI_Status status;

  memset(charData, 0, sizeof(charData));

  if ((errCode = MPI_Init(&argc, &argv)) != 0)
  {
    return errCode;
  }

  MPI_Comm_size(MPI_COMM_WORLD, &size);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);

  if (rank != 0) 
  {
    sprintf(charData, "Hello! My rank in MPI_COMM_WORLD = %d\n", rank);

    MPI_Send(charData, strlen(charData), MPI_CHAR, 0, tagCharData, MPI_COMM_WORLD);
  }
  else
  {
    for (i = 1; i < size; i++)
    {
      MPI_Recv(charData, ELEMS(charData), MPI_CHAR, MPI_ANY_SOURCE, tagCharData, MPI_COMM_WORLD, &status);

      printf("%s", charData);
    }
    printf("Hello World!!!\n");
  }
  MPI_Finalize();

  return 0;
}