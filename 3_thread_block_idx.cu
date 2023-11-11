#include<stdio.h>

__global__ void threadblockidx()
{
    printf("1");
    if(threadIdx.x == 1023 && blockIdx.x == 255)
    {
        printf("successful.\n");
    }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
}

int main()
{
    threadblockidx<<<256,1024>>>();
    cudaDeviceSynchronize();

}