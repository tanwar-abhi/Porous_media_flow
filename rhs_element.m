function rhs = rhs_element(N,dvolu)
%
% rhs = rhs_element(N,dvolu,p,NBC,ielem,Kv,nElem,nx)
% Defiine your rhs here only for cases when rhs is non zero
% 
% s: source term
% N: Shape Funcion
% dvolu: Volume term


s=0;

% if nargin < 4
%     rhs = N*s*dvolu;
% 
% elseif NBC == 0
%     rhs = N*s*dvolu;
% 
% elseif ielem > nElem-nx
%     R = N*p*Kv(2,2)*dvolu;
%     if ielem == nElem-nx+1
% %         rhs = N*p*(Kv(1,1)*dpnx + Kv(2,2)*dpny )
%         rhs = [0,0,R,0];
%     elseif ielem == nElem;
%         rhs = [0,0,0,R];
%     else
%         rhs = [0,0,R,R];
%     end
% 
% %     rhs = N*p*Kv(2,2)*dvolu;
% else
%     rhs = N*s*dvolu;
% end

rhs = N*s*dvolu;

end