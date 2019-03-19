

# Introduction

The Porous_Media_Flow repository contains all the MATLAB code files and sub files that are required to run the FEM solver that was coded to simulate (both steady and transient) pressure driven airflow in a fibrous composite material.

Different test cases are already defined for both steady and transient cases with various possible boundary conditions.  If a user wishes to change the boundary conditions other that what is already defined in solver, he/she can do so by changing boundary consitions in subsequent functions of steady and transient case.



## Main solver files

The file names are structured such that a user/reader can intutively guess the internal structure and output of the files from reading name of the functions/files. For example:

`main.m` :: This is the main file where the domain and phusical parameters for flow and user specific inputs are defined.

`rhs_element.m` :: Here RHS terms of the equation and source terms are defined for the subsequent, steady and trasnsient, cases.

`Initial_Conditions.m` :: As per the name here initial conditions for the transient boundary value problem as defined.

`Element_Neumann.m` :: This function imposes the Neumann boundary conditions on the subsequent elements.

`Postprocessing.m` :: This function displays the time variation graphs, showing the gradual progression of pressure as the solution marches in time. 

`steady_DBC.m` :: This file contains the numerical algorithm for solving the nonlinear steady case boundary value problem with only imposed Dirichlet boundary conditions.

`steady_DBC_NBC.m` :: This file contains the numerical algorithm for solving the nonlinear steady case boundary value problem with imposed Dirichlet and Neumann boundary conditions.

`transient_2BDF_DNBC.m` :: This file contains the numerical algorithms for solving nonlinear transient boundary value problem with both dirichlet and neumann boundary conditions.

`transient_2BDF_DBC.m` :: This file contains the numerical algorithms for solving nonlinear transient boundary value problem with only imposed dirichlet boundary conditions.

## Sub functions, helping functions Pre and Post-Processing

These are the sub functions that are called upon by the main solver code, they are located within Functions directory and this path is added to solver.

`cinput.m` :: This is just a function created for rendering text on screen asking for user inputs.

`PlotMesh.m` :: This gives a visual representation of the mesh, elements and nodes.

`SetReferenceElement.m` :: This function creates a structured element of all the user inputs and element numbers, node nubers and connectivities.

`Quadrature.m` :: This function contains all the gauss quadratures used for the calculation of integrals.

`CreateMesh.m` :: It discretize's the whole domain defined in `main.m` and creates the mesh.

`ShapeFunc.m` :: Here linear and quadratic shape functions are defined which are called upon during element martix calculations.

`FEM_matrices_steady.m` , `FEM_matrices_transient.m` :: This function {sub file} solve and assembling, respective, element and global FEM matrices. This function is called everytime the element matrices is calculated and then it adds to the global stiffness matrix.


## Case Setup
* To solve steady and transient cases with differnet imposed boundary condition, multiple files where created which call in necessary functions. They subsequently contain algorithms for solving steady and tranisent problem.

* Suffix **DBC** stands for Dirichlet Boundary Conditions and **NBC** stands for Neumann Boundary Conditions.


# How to run the Solver

* To run the solver simply open MATLAB and run only the `main.m` file and select appropriate options when prompted on the screen.

* The flow parameters and composite material properties must be defied within `main.m` before running `main.m`, otherwise the solver would take default parameters defined by me during verification and debugging.

* The `Postprocessing.m` function should only be executed for the **transient case** after the solver has calculated the pressure values which will be indicated by a text on screen.

**NOTE :** This solver was coded and tested on a genuine licensed MATLAB 2016, it might not work on very old versions of MATLAB such as versions older than MATLAB 2010.

