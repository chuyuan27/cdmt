#include <stdio.h>


__global__ void some_kernel(int value,int *a,int N)
{
    int i=threadIdx.x+blockIdx.x*blockDim.x;
    if(i<N)
    {
        a[i]=value;
    }
    
}

int main()
{
    int N=1000;
    int *a;
    int value=6;
    size_t size=N*sizeof(int);
    cudaMallocManaged(&a,size); 
    size_t threadof_per_block=256;
    size_t block_numbers=(N+threadof_per_block-1)/threadof_per_block;

    some_kernel<<<threadof_per_block,block_numbers>>>(value,a,N);
    cudaDeviceSynchronize();
    
    for(int i=0;i<N;++i)
    {
        if(a[i]!=value)
        {
            printf("false");
        }
    }
    printf("True");
    
    cudaFree(a);
}