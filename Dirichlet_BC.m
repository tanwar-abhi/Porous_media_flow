function [K_bc,f] = Dirichlet_BC(K,f,nodesDir0,nodesDir1)

K_bc = K;

for i=1:numel(nodesDir1)
    K_mv_rhs = K(:,nodesDir1(i));
    f = f - K_mv_rhs;
end

K_bc(:,nodesDir1) = 0;
K_bc(nodesDir1,:) = 0;
K_bc(:,nodesDir0) = 0;
K_bc(nodesDir0,:) = 0;

for i =1:numel(nodesDir1)
K_bc(nodesDir1(i),nodesDir1(i)) = 1;
f(nodesDir1) = 1;
end

for i =1:numel(nodesDir0)
K_bc(nodesDir0(i),nodesDir0(i)) = 1;
f(nodesDir0) = 0;
end

% p = rand(size(p));
% p(nodesDir1) = 1;
% p(nodesDir0) = 0;

K_bc = sparse(K_bc);

end