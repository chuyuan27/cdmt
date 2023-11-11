#include <stdio.h>
#include <assert.h>

inline cudaError_t checkCuda(cudaError_t result)
{
    if(result != cudaSuccess){
        fprintf(stderr,"Cuda Runtime Error:%s\n",cudaGetErrorString(result));
        assert(result == cudaSuccess);
    }
    return result;
}

void matrixMulCPU(int *a,int *b,int *c,int N)
{
    int val=0;
    for(int row=0;row<N;++row)
    {
        for(int col=0;col<N;++col)
        {
            val=0;
            for(int k=0;k<N;++k)
            {
                val+=a[row*N+k]*b[col+k*N];
                c[row*N+col]=val;
            }
        }
    }
}

__global__ void matrixMulGPU(int *a,int*b,int*c,int N)
{
    int row = threadIdx.x + blockIdx.x*blockDim.x;
    int col = threadIdx.y + blockIdx.y*blockDim.y;
    if(row<N && col<N)
    {
        for(int k=0;k<N;++k)
        {
            int val = 0;
            val +=a[row*N+k]*b[col+k*N];
            c[row*N+col]=val;
        }
    }
}

void checkElements(int *a,int*b,int N)
{
    for(int row=0;row<N;++row)
    {
        for(int col=0;col<N;++col)
        {
            int val=0;
            val=a[row*N+col];
            if(b[row*N+col] != val)printf("Error:in row %d col %d",row,col);
        }
    }
}


int main()
{
    int N=2<<20;
    int *a;
    int *b;
    int *c_cpu;
    int *c_gpu;
    size_t size=N*N*sizeof(int);
    checkCuda(cudaMallocManaged(&a,size));
    checkCuda(cudaMallocManaged(&b,size));
    checkCuda(cudaMallocManaged(&c_cpu,size));
    checkCuda(cudaMallocManaged(&c_gpu,size));

    for( int row = 0; row < N; ++row )
        for( int col = 0; col < N; ++col )
        {
            a[row*N + col] = row;
            b[row*N + col] = col+2;
            c_cpu[row*N + col] = 0;
            c_gpu[row*N + col] = 0;
        }

    matrixMulCPU(a,b,c_cpu,N);
    dim3 threadperblock(16,16,1);
    dim3 numberofblocks((N+threadperblock.x-1)/threadperblock.x,(N+threadperblock.y-1)/threadperblock.y,1);

    matrixMulGPU<<<numberofblocks,threadperblock>>>(a,b,c_gpu,N);
    checkCuda(cudaDeviceSynchronize());
    checkElements(c_cpu,c_gpu,N);

    checkCuda(cudaFree(a));
    checkCuda(cudaFree(b));
    checkCuda(cudaFree(c_cpu));
    checkCuda(cudaFree(c_gpu));

}