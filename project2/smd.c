/** include file for mex function */
#include "mex.h"
#include "matrix.h"


/** This function will be called in mexFunction, i.e., the main entry of a matlab mex function. */
void md_reordering(int* Ap, int* Ai, int* p, int Ar, int Ac);

/** all mex function should be defined like this. It is the main entry of a matlab mex function*/
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    /** number of rows, columns of matrix A*/
    int Ar;
    int Ac;
    /** number of non-zeros of A */
    int Annz;
    
    int* Ap; /** pointer of matrix A (prhs[0]) */
    int* Ai; /** index of matrix A (prhs[0]) */
    int* p;  /** reordering result */

  /** check input-output numbers */
    if(nrhs != 1)
        mexErrMsgTxt("Only one input is required!");
    else if(nlhs != 1)
        mexErrMsgTxt("Only one output is allowed");


    /** check whether the inputs are sparse matrices */
    if(!(mxIsSparse(prhs[0])))
    {
      mexErrMsgTxt("Input should be sparse matrix");
    }

 
    Ar = mxGetM(prhs[0]); Ac = mxGetN(prhs[0]); Annz = mxGetNzmax(prhs[0]);
    Ap = mxGetJc(prhs[0]); Ai = mxGetIr(prhs[0]);  
    
    /** clear plhs[0] */
    if(plhs[0] != NULL)
      mxFree(plhs[0]);
    /** Allocate memory for the return value, actually a permutation vector */
    plhs[0] = mxCreateNumericMatrix(Ar, 1, mxINT32_CLASS, mxREAL);
    p = mxGetPr(plhs[0]);

    /** call the real function. */
    md_reordering(Ap, Ai, p, Ar, Ac);
    

}

/** implementation of the real function. */
/** put your code here. */
/** The order is computed in p.*/
void md_reordering(int* Ap, int* Ai, int* p, int Ar, int Ac)
{
    
}
