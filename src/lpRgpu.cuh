#include <cufft.h>
#include <stdio.h>
#include "config.cuh"
#include "gridStorage.cuh"

class lpRgpu{
	//global parameters
	int N0;
	int N;
	int Nspan;
	int Ntheta;int Nrho;
	int Nproj;
	int Nslices;int ni;
	int Ntheta_cut;
	int Ntheta_R2C;
	int cor;
	int osangles;
	float* erho;

	//grids storages
	fwdgrids* fgs;
	adjgrids* ags;
	//gpu memory    
	float* derho;
	float* dfl;
	float2* dflc;
	cudaArray* dfla;
	cufftHandle plan_forward;
	cufftHandle plan_inverse;
	cufftHandle plan_f_forward;
	cufftHandle plan_f_inverse;
	//fwd
	float2* fZfwd;
	float2* dfZfwd;
	cudaArray* dfa;
	float* dR;
	float* dtmpf;

	//adj
	float2* fZadj;
	float2* dfZadj;
	float* dtmpR;
	cudaArray* dRa;
	float* df;

	//filter
    float* filter;
	float* dfilter;
	float2* dRc;

	int interp_type;
	cudaError_t err;

public:
	lpRgpu(float* params, int Nparams, int gpu);
	~lpRgpu();
	void printGlobalParameters();
	void printFwdParameters();
	void printAdjParameters();
	void readGlobalParametersArr(float* params);
	void readFwdParametersArr(int* paramsi, float* paramsf);
	void readAdjParametersArr(int* paramsi, float* paramsf);
	void printCurrentGPUMemory(const char* str = 0);

	void initFwd(int* paramsi, int Nparamsi, float* paramsf, int Nparamsf, int gpu);

	void initAdj(int* paramsi, int Nparamsi, float* paramsf, int Nparamsf, int gpu);

	void deleteFwd();
	void deleteAdj();

	void prefilter2D(float *df, float* dtmpf,uint width, uint height);
	void execFwd();
	void execAdj();

	void execFwdMany(float* R, int Nslices2_, int Nproj_, int N_, float* f, int Nslices1_, int N2_, int N1_);

	void execAdjMany(float* f, int Nslices1_, int N2_, int N1_, float* R, int Nslices2_, int Nproj_, int N_);
	void execFwdManyPtr(size_t Rptr, size_t fptr, int Nslices0, int gpu);
	void execAdjManyPtr(size_t fptr, size_t Rptr, int Nslices0,  int gpu);

	void applyFilter();
	void padding(int N_);
};
