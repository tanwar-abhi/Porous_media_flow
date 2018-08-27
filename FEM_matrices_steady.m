function [K,f]= FEM_matrices_steady(X,T,referenceElement,Kv,p,NBC)
%
% [K,f] = FEM_matrices_steady(X,T,referenceElement,Kv)
% Matrix K and r.h.s vector f obtained after discretizing the governing equation
%
% X: nodal coordinates
% T: connectivities (elements)
% referenceElement: reference element properties (quadrature, shape functions...)
% Kv: material permeability tensor

if nargin < 6
    NBC = ' ';
%     referenceElement.nodes_nbc = 0;
end

nElem = size(T,1);
nPts = size(X,1);

% Global Matrices
K = zeros(nPts);
f = zeros(nPts,1);

% Loop on Elements
for ielem = 1:nElem
    Te = T(ielem,:);
    Xe = X(Te,:);
    p_elem = p(Te,:);
    
    [Ke,fe] = Element_Matrix(Xe,referenceElement,Kv,p_elem,NBC,ielem,nElem);
    
    % Global Assembly of Matrices
    K(Te,Te) = K(Te,Te) + Ke;
    f(Te) = f(Te) + fe;
   
end
% K = sparse(K);
end




function [Ke, fe] = Element_Matrix(Xe,referenceElement,Kv,p,NBC,ielem,nElem)

nen = referenceElement.nen;
ngaus = referenceElement.ngaus;
wgp = referenceElement.GaussWeights;
N = referenceElement.N;
Nxi = referenceElement.Nxi;
Neta = referenceElement.Neta;
N2xi = referenceElement.N2xi; 
N2eta = referenceElement.N2eta;
N2xieta = referenceElement.N2xieta;
N2etaxi = referenceElement.N2etaxi;
nx = referenceElement.nx;

% Element Matrices
Ke = zeros(nen);
fe = zeros(nen,1);

    % Loop on Gauss points (computation of integrals on the local element)
    for ig = 1:ngaus
        N_ig = N(ig,:);
        Nxi_ig = Nxi(ig,:);
        Neta_ig = Neta(ig,:);
        
        Jacob = [Nxi_ig*(Xe(:,1)), Nxi_ig*(Xe(:,2));
            Neta_ig*(Xe(:,1)), Neta_ig*(Xe(:,2))];
            
        res = Jacob\[Nxi_ig;Neta_ig];
        Nx = res(1,:);
        Ny = res(2,:);

        dvolu = wgp(ig)*det(Jacob);
        KvdotDelN = Kv*[Nx;Ny];     
        
%         Ke = Ke - ((N_ig*p*[Nx;Ny])'*(Kv*[Nx;Ny]))*dvolu;
        
        Ke = Ke + (N_ig*p*(Nx'*KvdotDelN(1,:)+Ny'*KvdotDelN(2,:)) - 2*(N_ig*p*[Nx;Ny]'*Kv'*[Nx;Ny]))*dvolu;
        
        rhs = rhs_element(N_ig,dvolu);
        
        if NBC == 1
            nbc = Element_Neumann(N_ig,dvolu,p,ielem,Kv,nElem,nx);
            fe = fe + rhs' + nbc;
        else
            fe = fe + rhs';
        end

    end

end