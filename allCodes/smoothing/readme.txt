
		splitBregmanROF.c (MEX version) by Tom Goldstein

    This code performs isotropic ROF denoising using the "Split Bregman" algorithm.
  This version of the code has a "mex" interface, and should be compiled and called
  through MATLAB.

DISCLAIMER:  This code is for academic (non-commercial) use only.  Also, this code 
comes with absolutely NO warranty of any kind: I do my best to write reliable codes, 
but I take no responsibility for the reliability of the results.
 
                       HOW TO COMPILE THIS CODE
    To compile this code, open a MATLAB terminal, and change the current directory to
 the folder where this "c" file is contained.  Then, enter this command:
     >>  mex splitBregmanROF.c
 This file has been tested under windows using lcc, and under SUSE Unix using gcc.
 Once the file is compiled, the command "splitBregmanROF" can be used just like any
 other MATLAB m-file.
 
                       HOW TO USE THIS CODE
  An image is denoised using the following command
  
    splitBregmanROF(image,mu,tol);
 
  where:
    - "image" is a 2d array containing the noisy image.
    - "mu" is the weighting parameter for the fidelity term 
             (usually a value between 0.01 and 0.5 works well for images with 
                            pixels on the 0-255 scale).
    - "tol" is the stopping tolerance for the iteration.  "tol"=0.001 is reasonable for most applications.


For an example of how this is done, try running the file "rof_mex_demo" included in this distribution.

