function Enbc = Element_Neumann(N,dvolu,p,ielem,Kv,nElem,nx)
% 
% 
% This function calculates neumann values at each element.
% 
% output
% Enbc: Vector of Element nodal Neumann conditions
% 
% Intput:
% N: Shape function; dvolu: Volume integral
% p: Element nodal pressure values; Kv: Permeability tensor
% ielem: Iteration of element; nElem: Total no. of elements
% nx: No. of elements in x-axis


if ielem > nElem-nx
%     Enbc = N'*N*p*(Kv(2,2))*dvolu;
    Enbc = N'*N*p*(Kv(1,1))*dvolu;
%     Enbc = N'*N*p*(Kv(1,1)+Kv(2,2))*dvolu;
    if ielem == nElem-nx+1
        Enbc(1:2) = 0; Enbc(4) = 0;
    elseif ielem == nElem
        Enbc(1:3) = 0;
    else
        Enbc(1:2) = 0;
    end
    
else
    Enbc = zeros(size(p));

end