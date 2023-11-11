#include <stdio.h>

__global__ void parallel()
{
    printf("this should been print in parallel.\n");
}

int main()
{
    parallel<<<5,5>>>();
    cudaDeviceSynchronize();

}