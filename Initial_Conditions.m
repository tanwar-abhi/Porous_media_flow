function p = Initial_Conditions(p,nodes_x0,nodes_xL,nodes_y0,nodes_yW)

% p = rand(size(p));
p(nodes_x0,1) = 0;
p(nodes_xL,1) = 1;

nodes_pValue = [nodes_xL';nodes_y0';nodes_yW'];
% ic_p_bdn = [nodes_x0, nodes_xL;
%             ones(size(nodes_x0), zeros(size(nodes_xL))];
end