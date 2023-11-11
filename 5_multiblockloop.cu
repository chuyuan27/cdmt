#include <stdio.h>

__global__ void multiblockloop()
{
    int c;
    c = threadIdx.x + blockIdx.x * blockDim.x;
    printf("%d\n",c);

}

int main()
{
    multiblockloop<<<10,10>>>();
    cudaDeviceSynchronize();

}