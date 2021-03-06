%%% Using implicit time integration

% This is a code to check and solve the transient pressure equation.

dt = tEnd/ntStep;

% Number of points(nodes) in each direction
npx = nx*interp+1;
npy = ny*interp+1;

% Boundary Nodes 
nodes_x0 = linspace(1,npx*npy-npx+1,npy);          % Nodes on boundary x=0
nodes_xL = linspace(npx,npx*npy,npy);              % Nodes on boundary x=L
nodes_y0 = (2:npx-1);                              % Nodes on boundary y=0
nodes_yW = (npx*npy-npx+2:npx*npy-1);              % Nodes on boundary y=W


%%%% Define value at DBC %%%%
nodesDir0 = [nodes_y0, nodes_yW]';            % Nodes at Dirichlet BC: p=0


C = [nodesDir0, zeros(size(nodesDir0))];

    
nDir = size(C,1);
neq  = size(X,1);               % No. of equations to be solved i.e. for which we need solution excluding lambda

% Block matrix for lagrange multipliers ::>> [K, A'; A,0]*[x;lambda]=[f;b]
A = sparse(zeros(nDir,neq));
A(:,C(:,1)) = eye(nDir);
b = C(:,2);


p = zeros(size(X,1),ntStep);
% p(:,1) = rand(size(p,1),1);

for i = 1:ntStep
    if i==1
        p(:,i) = Initial_Conditions(p(:,1),nodes_x0,nodes_xL,nodes_y0,nodes_yW);
        p_n = p(:,i);
        p_n_n = 0;
    elseif i==2
        p_n = p(:,i-1);             % Value at previous time step (n)
        p_n_n = zeros(size(p_n));
    else
        p_n = p(:,i-1);
        p_n_n = p(:,i-2);
    end

    % Loop for Solving Nonlinear System of Equations
    error = 1; iteration = 0; eps = 1e-9;
    while error > eps
        iteration = iteration+1;               % Iteration counter

        p_k = p(:,i);
        
        [M,K,f] = FEM_matrices_transient(X,T,referenceElement,Kv,p_k);
        
        K_g = 3*M - (2*dt)/(phi*mu)*K;
        fn = M*(4*p_n - p_n_n) + f;
        Ktot = [K_g, A'; A, zeros(nDir,nDir)];
        ftot = [fn;b];
        sol = Ktot\ftot;
        p(:,i) = sol(1:neq);
        
%         p(:,i) = M\(M*p_n + dt/(phi*mu)*(K*p_n));
        error = norm(p(:,i) - p_k);
%         err(iteration,i) = error;
        
        if error <= eps
            disp('Solution Converged')
%             disp(['Solution Converged, it took ',num2str(iteration),' iterations.'])
        elseif iteration >= 1000
            error('Solution did not Converged');
        end
        
    end
    if i ==1
        p(:,i) = Initial_Conditions(p(:,1),nodes_x0,nodes_xL,nodes_y0,nodes_yW);
    end
end

disp(' ');
disp('Calculations complete, now run Postprocessing file to view time graphs.');
disp(' ');

%%%%%%%%%%%%----POSTPROCESSING----%%%%%%%%%%%%%%
% n = 24;             % No. of time plots of process.
% it = interp*4;
% Ttime = linspace(0,tEnd,npx);
% xt = linspace(X(1,1),X(end,1),npx);
% for i = ceil(linspace(1,ntStep,n))
%     it = it+1;
%     figure(it+1)
% %     figure(40*it+1)
% if i==1
%     tt=(i-1)*dt;
% else
%     tt = i*dt;
% end
%     xx  = reshape(X(:,1), npx, npy)';
%     yy  = reshape(X(:,2), npx, npy)';
%     sol = reshape(p(:,i), npx, npy)';
%     surf(xx,yy,sol,'FaceColor','interp','EdgeColor','none');
%     xlabel('Distance x (m)','FontSize',12);
%     ylabel('Distance y (m)','FontSize',12);
%     zlabel('Pressure (kPa)','FontSize',12);
%     title(['time = ',num2str(tt),' (s)'])
%     grid on; %view(3)
% % %     
% %  
% % %     % For Pressure at center of 'y' i.e. along x-axis
% % % 
% % %     figure(it+20)
% % %     p_Yc = sol(ceil(npy/2),:);
% % %     plot(xt,p_Yc)
% % %     xlabel('x','FontSize',12);
% % %     ylabel('Pressure (kPa)','FontSize',12)
% % %     title(['time = ',num2str(tt),' (s)'])
% % %     grid on;
% 
% end


