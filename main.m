clear; clc;
%close all;

disp('This code solves the governing pressure equation for a compressible air flow in a porous media. ')
disp(' ')
elem = cinput('Select type of elements (default value=0) 0:Quadrilateral | 1:Triangular ',0);
disp(' ')
interp =  cinput('Select order of interpolation of elements (default value=1) [1]:Linear | [2]:Quadratic ',1);
disp(' ')
problem = cinput('Select which pressure equation to solve- 0:Steady | 1:Transient ',0);
disp(' ')
BC = cinput(['Select the Boundary Conditions to impose \n'...
                     ' [0]: Pure Dirichlet BC on whole boundary of domain \n'...
                     ' [1]: Mixed BC: Dirichlet (left,right) + Neumann (top,bottom) \n '],0);
if BC == 1
    disp(' ')
    NBC = cinput(['Select type of Neumann BC :\n'...
                  ' [0]: Gradient of pressure=0 at top and bottom boundary (NB) \n'...
                  ' [1]: Non zero Neumann BCs top = 1 ; bottom = 0 \n '],0);
end


tic
% Domain Defination (x1,x2,y1,y2)
dom = [0,2,0,1];
L = dom(2)- dom(1);
W = dom(4)- dom(3);

% Geometric and material parameters
mu = 1.8;                          % Viscosity of fluid/gas
phi = 1;                           % Porosity


% Permeability Tensor
Kv(1,1) = 1; Kv(1,2) = 0;
Kv(2,1) = Kv(1,2); Kv(2,2) = 0.1;
% 
% Kv = [1, 0; 0, 0.1];

% Kv = [0.775, 0.389 ; 0.389, 0.325];          % Tensor rotated at 30 deg


% Number of elements
nx = 06;                  % in x-direction
ny = 03;                  % in y-directions

% Time control for Transient case
tEnd = 5;                % Total time ({0,tEnd} in seconds)
ntStep = 45;             % No. of time steps

referenceElement = SetReferenceElement(elem,interp);

[X,T] = CreateMesh(dom,nx,ny,referenceElement);

referenceElement.nx = nx; referenceElement.ny = ny;


% Uncomment the below line if you wish to see the mesh
% PlotMesh(T,X,elem,'b-',1);

if problem == 0 && BC == 0
    steady_DBC

elseif problem == 1 && BC == 0
%     transient_implicit_DBC
    transient_2BDF_DBC
    
elseif problem == 0 && BC == 1
    steady_DBC_NBC
    
elseif problem == 1 && BC == 1
%     transient_implicit_DBC_NBC
    transient_2BDF_DNBC
    
else
    error('Inappropriate problem choice');
end

toc