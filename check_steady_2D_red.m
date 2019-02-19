% this is someting for a fun, reducing matrix to implement BC instead of
% using Lagrange multipliers

% Number of points(nodes) in each direction
npx = nx*interp+1;
npy = ny*interp+1;

% Boundary Nodes
nodes_x0 = linspace(1,npx*npy-npx+1,npy);          % Nodes on boundary x=0
nodes_xL = linspace(npx,npx*npy,npy);              % Nodes on boundary x=L
nodes_y0 = (2:npx-1);                              % Nodes on boundary y=0
nodes_yW = (npx*npy-npx+2:npx*npy-1);              % Nodes on boundary y=W

nodesDir1 = nodes_x0';                         % Nodes at Dirichlet BC: p=1
% nodesDir0 = nodes_xL';
nodesDir0 = [nodes_y0, nodes_xL, nodes_yW]';   % Nodes at Dirichlet BC: p=0


% Loop for Solving Nonlinear System of Equations (Newton-Raphson)
error = 1; iteration = 0; eps = 1e-9;

while error > eps
    iteration = iteration+1                      % Iteration counter
    if iteration == 1
        p = ones(size(X,1),1);
    end
    p_old = p;
    [K,f] = FEM_matrices_steady(X,T,referenceElement,Kv,p);
    [K_bc,f] = Dirichlet_BC(K,f,nodesDir0,nodesDir1);
    
    p = K_bc\f;
    
    error = norm(p - p_old);
    
    if error <= eps
    disp('Solution Converged')
    elseif iteration > 1000
        disp('Solution not Converging')
        break
    end
end


% % POSTPROCESSING
% figure(21)
% xx  = reshape(X(:,1), npx, npy)';
% yy  = reshape(X(:,2), npx, npy)';
% sol = reshape(p, npx, npy)';
% surf(xx,yy,sol,'FaceColor','interp','EdgeColor','none');
% % set(gca, 'xTick',X(1,1):0.25:X(end,1), 'yTick',X(1,2):0.25:X(end,2), 'FontSize',12)
% xlabel('x','FontSize',12); 
% ylabel('y','FontSize',12); 
% zlabel('P','FontSize',12);
% grid on; %view(3)
