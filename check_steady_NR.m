% This code is using the Newton-Raphson method for solving the nonlinear
% system of equations.
%
% Boundary conditions in the code are implemented using lagrange multipliers.

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

C = [nodesDir1, ones(size(nodesDir1));
     nodesDir0, zeros(size(nodesDir0))];
    
nDir = size(C,1);
neq  = size(X,1);                       % No. of equations to be solved i.e. for which we need solution excluding lambda


% A = sparse(zeros(nDir,neq));
A = zeros(nDir,neq);
A(:,C(:,1)) = eye(nDir);
b = C(:,2);


% Loop for Solving Nonlinear System of Equations (Newton-Raphson)
error = 1; iteration = 0; eps = 1e-9;

while error > eps
    iteration = iteration+1                      % Iteration counter
    if iteration == 1
        p = ones(size(X,1),1);
    end
    p_old = p;
    [K,Jacobian,f] = FEM_matrices_steady_NR(X,T,referenceElement,Kv,p);
    
    [K_bc,f] = Dirichlet_BC(K,f,nodesDir0,nodesDir1);
    
    % SOLUTION OF THE LINEAR SYSTEM
%     % Entire matrix
    Ktot = [Jacobian, A'; A, zeros(nDir,nDir)];
    pn = K_bc\f;
    f = (-K*pn);
    ftot = [f;b];
    sol = Ktot\ftot;
    p = sol(1:neq);
    
    error = norm(p - p_old);
    
    if error <= eps
    disp('Solution Converged')
    elseif iteration > 1000
        disp('Solution not Converging')
        break
    end
    
end



% % POSTPROCESSING
% figure(22)
% xx  = reshape(X(:,1), npx, npy)';
% yy  = reshape(X(:,2), npx, npy)';
% sol = reshape(p, npx, npy)';
% surf(xx,yy,sol,'FaceColor','interp','EdgeColor','none');
% % set(gca, 'xTick',X(1,1):0.25:X(end,1), 'yTick',X(1,2):0.25:X(end,2), 'FontSize',12)
% xlabel('x','FontSize',12); 
% ylabel('y','FontSize',12); 
% zlabel('P','FontSize',12);
% grid on; %view(3)
% 
% 
% x = linspace(dom(1),dom(2),npx);
% y = linspace(dom(3),dom(4),npy);
% 
% figure(32)
% p_Xc = sol(:,ceil(npx/2));               % Pressure at center of X
% plot(y,p_Xc,'b-','LineWidth',2);
% xlabel('y')
% ylabel('Pressure (P)')
% title('Pressure profile at x=1')
% set(gca, 'FontSize',12);
% 
% 
% figure(42)
% p_Yc = sol(ceil(npy/2),:);               % Pressure at centre of Y
% plot(x,p_Yc,'r-','LineWidth',2);
% xlabel('x')
% ylabel('Pressure (P)')
% title('Pressure profile at y=0.5')
% set(gca, 'FontSize',12);