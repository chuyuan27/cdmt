#include <stdio.h>

void helloCPU()
{
    printf("hello from CPU.\n");
}

__global__ void helloGPU()
{
    printf("hello also from CPU.\n");
}

int main()
{
    helloCPU();
    helloGPU<<<1,2>>>();
    cudaDeviceSynchronize();


}
