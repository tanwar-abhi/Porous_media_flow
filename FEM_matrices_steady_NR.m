function [K,Jacobian,f]= FEM_matrices_steady_NR(X,T,referenceElement,Kv,p)
%
% [K,f] = FEM_matrices_steady(X,T,referenceElement,Kv)
% Matrix K and r.h.s vector f obtained after discretizing the governing equation
% Jacobian: 
% 
% X: nodal coordinates
% T: connectivities (elements)
% referenceElement: reference element properties (quadrature, shape functions...)
% Kv: material permeability tensor

nElem = size(T,1);
nPts = size(X,1);

% Global Matrices
K = zeros(nPts);
f = zeros(nPts,1);
Jacobian = zeros(nPts);

% Loop on Elements
for ielem = 1:nElem
    Te = T(ielem,:);
    Xe = X(Te,:);
    p_elem = p(Te,:);
    
    [Ke,fe,Jacobian_NRe] = Element_Matrix(Xe,referenceElement,Kv,p_elem);
    
    % Global Assembly of Matrices
    K(Te,Te) = K(Te,Te) + Ke;
    f(Te) = f(Te) + fe;
    Jacobian(Te,Te) = Jacobian(Te,Te) + Jacobian_NRe;
end
% K = sparse(K);
end




function [Ke,fe,Jacobian_NRe] = Element_Matrix(Xe,referenceElement,Kv,p)

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
        rhs = rhs_element(N_ig,dvolu);
%         Ke = Ke - ((N_ig*p*[Nx;Ny])'*(Kv*[Nx;Ny]))*dvolu;
        
        Ke = Ke + (N_ig*p*(Nx'*KvdotDelN(1,:)+Ny'*KvdotDelN(2,:)) - 2*(N_ig*p*[Nx;Ny]'*KvdotDelN))*dvolu;

        fe = fe + rhs';
        
        Jacobian_NRe = Jacobian_NRe + (2*N_ig*p*([Nx;Ny]'*Kv*[Nx;Ny]) - 4*N_ig*p*[Nx;Ny]'*Kv*[Nx;Ny])*dvolu;
        
    end

end
