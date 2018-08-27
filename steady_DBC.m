
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
nodesDir0 = [nodes_y0, nodes_xL, nodes_yW]';   % Nodes at Dirichlet BC: p=0
    
C = [nodesDir1, ones(size(nodesDir1));
     nodesDir0, zeros(size(nodesDir0))];
    
nDir = size(C,1);
neq  = size(X,1);                       % No. of equations to be solved i.e. for which we need solution excluding lambda

A = sparse(zeros(nDir,neq));
A(:,C(:,1)) = eye(nDir);
b = C(:,2);

% Loop for Solving Nonlinear System of Equations (Fixed Point iteration method)
error = 1; iteration = 0;
eps = 1e-9;

while error > eps
    iteration = iteration+1                      % Iteration counter
    if iteration == 1
        p = ones(size(X,1),1);
    end
    p_old = p;
%     [K,f] = old_FEM_matrices_steady(X,T,referenceElement,Kv,p);
    [K,f] = FEM_matrices_steady(X,T,referenceElement,Kv,p);
    
    % SOLUTION OF THE LINEAR SYSTEM
    % Entire matrix
    Ktot = [K, A'; A, zeros(nDir,nDir)];
    ftot = [f;b];
    sol = Ktot\ftot;
    p = sol(1:neq);
    
    error = norm(p - p_old);
    
    if error <= eps
    disp(['Solution Converged, it took ',num2str(iteration),' iterations.'])
    elseif iteration > 1000
        disp('Solution not Converging')
        break
    end
end


%%%%%%-% POSTPROCESSING %-%%%%%%
figure(2)
xx  = reshape(X(:,1), npx, npy)';
yy  = reshape(X(:,2), npx, npy)';
sol = reshape(p, npx, npy)';
surf(xx,yy,sol,'FaceColor','interp','EdgeColor','none');
% set(gca, 'xTick',X(1,1):0.25:X(end,1), 'yTick',X(1,2):0.25:X(end,2), 'FontSize',12)
xlabel('Distance x (m)','FontSize',14); 
ylabel('Distance y (m)','FontSize',14); 
zlabel('Pressure (kPa)','FontSize',14);
% set(gca, 'FontSize',14);
grid on; %view(3)
colorbar;
% 
% 
x = linspace(dom(1),dom(2),npx);
y = linspace(dom(3),dom(4),npy);
% 
% figure(3)
% p_Xc = sol(:,ceil(npx/2));               % Pressure at center of X
% plot(y,p_Xc,'b-','LineWidth',2);
% xlabel('y')
% ylabel('Pressure (kPa)')
% title('Pressure profile at x=1')
% set(gca, 'FontSize',12);
% 
% 
figure(4)
p_Yc = sol(ceil(npy/2),:);               % Pressure at centre of Y
plot(x,p_Yc,'r-','LineWidth',1);
xlabel('x-axis (m)')
ylabel('Pressure (kPa)')
title('Pressure profile at y=0.5')
set(gca, 'FontSize',16);
grid on;
