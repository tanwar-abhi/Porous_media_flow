# The Porous_Media_Flow repository

Introduction
~~~~~~~~~~~~

The Porous_Media_Flow repository contains all the MATLAB code files and sub files that are required to run the FEM solver that was coded to simulate (both steady and transient) pressure driven airflow in a fibrous composite material.

Different test cases are already defined for both steady and transient cases with various possible boundary conditions.  If a user wishes to change the boundary conditions other that what is already defined in solver, he/she can do so by changing boundary consitions in subsequent functions of steady and transient case.

Suffix `DBC` stands for Dirichlet Boundary Conditions and `NBC` stands for Neumann Boundary Conditions.


The file names are structured such that a user/reader can intutively guess the internal structure and output of the files from reading name of the functions/files. For example:

``main.m`` :: This is the main file where the domain and phusical parameters for flow and user specific inputs are defined.

`FEM_matrices_steady.m , FEM_matrices_transient.m` :: This is a function {sub file} created for solving and assembling subsequent element and global FEM matrices. This function is called everytime the element natrices is calculated and when it is added to the global stiffness matrix.

`Quadrature.m` :: This fucntion contains all the gauss quadratures used for the calculation of integrals.

`ShapeFunc.m` :: Here linear and quadratic shape functions are defined which are called upon during element martix calculations.

`rhs_element.m` :: Here RHS terms of the equation and source terms are defined for the subsequent, steady and trasnsient, cases.

``Initial_Conditions.m`` :: As per the name here initial conditions for the transient boundary value propblem as defined.



How to run the Solver
~~~~~~~~~~~~~~~~~~~~~

To run the solver simply open MATLAB and run only the ``main.m`` file and select appropriate options when prompted on the screen.

The flow parameters and composite material properties must be defied within `main.m` before running ``main.m``, otherwise the solver would take default parameters defined by me during verification and debugging.

**NOTE : ** This solver was coded and tested on a genuine licensed MATLAB 2016, it might not work on very old versions of MATLAB such as versions older than MATLAB 2010.

