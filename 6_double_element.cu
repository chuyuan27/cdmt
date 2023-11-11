#include <stdio.h>

void init(int *a,int N)
{
    int i;
    for(i=0;i<N;++i)
    {
        a[i]=i;
    }
}

__global__ void doubleElements(int *a,int N)
{
    int i;
    i = blockIdx.x * blockDim.x + threadIdx.x;
    if(i<N)
    {
        a[i]*=2;
    }
}

bool checkElements(int*a,int N)
{
    int i;
    for(i=0;i<N;++i)
    {
        if(a[i]!=i*2) return false;
    }
    return true;

}

int main()
{
    int N=1000;
    int *a;
    size_t  size=N*sizeof(int);
    cudaMallocManaged(&a,size);
    init(a,N);
//    size_t thread_per_block=10;
//    size_t number_of_block=10;
    size_t thread_per_block=256;
    size_t number_of_block=(N+thread_per_block-1)/thread_per_block;
    doubleElements<<<thread_per_block,number_of_block>>>(a,N);
    cudaDeviceSynchronize();
    bool aredouble=checkElements(a,N);
    printf("are all elements true? %s\n",aredouble?"true":"false");
    cudaFree(a);

}