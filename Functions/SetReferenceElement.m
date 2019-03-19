function [ Element ] = SetReferenceElement( elem,interp )
%element = SetReferenceElement( elem,p )
%   Input
%   the element type : quadrilateral :0, triangular:1
%   Order of interpolation (p) = 1-first order, 2-second order;
%   Output
%   struct element with all its properties {Element co-ordinates measured CCW}

if elem == 0
    if interp == 1
        ngaus = 4;
        Xe_ref = [-1,-1; 1,-1; 1,1; -1,1];
    elseif  interp == 2
        ngaus = 9;
        Xe_ref = [-1,-1; 0,-1; 1,-1; 1,0; 1,1; ...
                  0,1; -1,1; -1,0; 0,0];
    else
        error('Interpolation Degree not available');
    end
    
elseif elem == 1
    if interp == 1
        ngaus = 3; 
        Xe_ref = [0,0; 1,0; 0,1];
    elseif interp == 2
        ngaus = 6; 
        Xe_ref = [0,0; 1,0; 0,1; 0.5,0; 0.5,0.5; 0,0.5];
    else
        error('not avilable interpolation degree');
    end
else
    error('unavailable element')
end

[zgp,wgp] = Quadrature(elem,ngaus);

[N,Nxi,Neta,N2xi,N2eta,N2xieta,N2etaxi] = ShapeFunc(elem,interp,zgp);

Element.degree = interp;
Element.elem = elem;
Element.Xe_ref = Xe_ref;
Element.nen = size(Xe_ref,1); 
Element.ngaus = ngaus; 
Element.GaussPoints = zgp; 
Element.GaussWeights = wgp; 
Element.N = N; 
Element.Nxi = Nxi; 
Element.Neta = Neta; 
Element.N2xi = N2xi;
Element.N2eta = N2eta;
Element.N2xieta = N2xieta;
Element.N2etaxi = N2etaxi;
end
