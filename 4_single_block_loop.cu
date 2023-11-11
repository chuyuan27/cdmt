#include<stdio.h>

__global__ void singleblockloop()
{
    int N = 10;
    for(int i = 0 ; i < N ; ++i)
    {
        if(threadIdx.x==i)
        {
            printf("%d",i);
        }

    }
}

int main()
{
    singleblockloop<<<1,10>>>();
    cudaDeviceSynchronize();

}