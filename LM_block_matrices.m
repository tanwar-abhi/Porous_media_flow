function [A,C,b,neq] = LM_block_matrices(nodesDir1,nodesDir0,X)

if nodesDir1 == 0
    C = [nodesDir0, zeros(size(nodesDir0))];
elseif nodesDir0 == 0
    C = [nodesDir1, zeros(size(nodesDir1))];
else
    C = [nodesDir1, ones(size(nodesDir1));
        nodesDir0, zeros(size(nodesDir0))];
end


nDir = size(C,1);
neq  = size(X,1);                       % No. of equations to be solved i.e. for which we need solution excluding lambda


% Block matrix for lagrange multipliers ::>> [K, A'; A,0]*[x;lambda]=[f;b]
A = sparse(zeros(nDir,neq));
A(:,C(:,1)) = eye(nDir);
b = C(:,2);

end
