function p_nn = check_transient_2D(X,T,referenceElement,p,Kv,NBC,dt)


    % Loop for Solving Nonlinear System of Equations
    error = 1; iteration = 0; eps = 1e-9;
    while error > eps
        iteration = iteration+1;               % Iteration counter

        p_k = p(:,1);
        p_n = p(:,1);
%         [M,K] = old_FEM_matrices_transient(X,T,referenceElement,Kv,p_k);
        [M,K,f] = FEM_matrices_transient(X,T,referenceElement,Kv,p_k,NBC);
        
        LHS = M - dt/(phi*mu)*K;
        fn = M*p_n;
        Ktot = [LHS, A'; A, zeros(nDir,nDir)];
        ftot = [fn+f;b];
        sol = Ktot\ftot;
        p_nn = sol(1:neq);
        
%         p(:,i) = M\(M*p_n + dt/(phi*mu)*(K*p_n));
        error = norm(p_nn(:,1) - p_k);
%         err(iteration,i) = error;
        
        if error <= eps
            disp('Solution Converged')
%             disp(['Solution Converged, it took ',num2str(iteration),' iterations.'])
        elseif iteration >= 1000
            disp('Solution did not Converged');
        end
        
    end
    p_nn(:,1) = Initial_Conditions(p(:,1),nodes_x0,nodes_xL,nodes_y0,nodes_yW);

end



%%%%%%%%%%%%%----POSTPROCESSING----%%%%%%%%%%%%%%
% n = 14;             % No. of time plots of process.
% it = interp;
% Ttime = linspace(0,tEnd,npx);
% xt = linspace(X(1,1),X(end,1),npx);
% for i = ceil(linspace(1,ntStep,n))
%     it = it+1;
%     figure(it+1)
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
% %     
% % 
% %  
% %     % Pressure profiles at center of 'y' i.e. along x-axis
% % 
% %     figure(it+20)
% %     p_Yc = sol(ceil(npy/2),:);
% %     plot(xt,p_Yc)
% %     xlabel('x','FontSize',12);
% %     ylabel('Pressure [Pa]','FontSize',12)
% %     title(['time = ',num2str(tt),' (s)'])
% %     grid on;
% end

