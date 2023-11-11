#include <stdio.h>

void init(int *a,int N)
{
    int i;
    for(i=0;i<N;++i)
    {
        a[i]=i;
    }
}

__global__ void doubleElements(int*a,int N)
{
    int indx=threadIdx.x + blockIdx.x*blockDim.x;
    int grid=gridDim.x*blockDim.x;
    for(int i=indx;i<N;i+=grid)
    {
        a[i]*=2;
    }
}

bool checkelements(int *a,int N)
{
    int i;
    for(i=0;i<N;++i)
    {
        if(a[i]!=i*2)return false;
    }
    return true;
}

int main()
{
    int N=10000;
    size_t size=N*sizeof(int);
    int *a;
    
    cudaMallocManaged(&a,size);
    init(a,N);
    size_t thread_per_block=256;
    size_t number_of_block=32;
    doubleElements<<<number_of_block,thread_per_block>>>(a,N);
    cudaDeviceSynchronize();
    bool b = checkelements(a,N);
    printf("%s",b?"ture":"false");
    cudaFree(a);


}