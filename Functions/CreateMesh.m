function [ X,T ] = CreateMesh(dom,nx,ny,referenceElement)
%
% X: Matrix containing coordinates of meshed domain
% T: Conectivity Matrix


elem = referenceElement.elem;
nen = referenceElement.nen; % No. of element nodes
p = referenceElement.degree;

x1 = dom(1); x2 = dom(2);
y1 = dom(3); y2 = dom(4);

npx = p*nx+1; % No. of nodes in x-direction
npy = p*ny+1; % No. of nodes in y-direction
npt = npx * npy; % Total No. of nodes

x = linspace(x1,x2,npx);
y = linspace(y1,y2,npy);
[x,y] = meshgrid(x,y);
[X] = [reshape(x',npt,1) reshape(y',npt,1)];

if elem == 0
    T = zeros(nx*ny,nen);
    if nen == 4
        for i = 1:ny
            for j = 1:nx
                ilem = (i-1)*nx + j;
                inode = (i-1)*npx +j;
                T(ilem,:) = [inode inode+1 npx+inode+1 npx+inode];
            end
        end
  elseif nen == 9
        T = zeros(nx*ny,9);
        for i=1:ny
            for j=1:nx
                ielem = (i-1)*nx + j;
                inode = (i-1)*2*npx + 2*(j-1) + 1;
                nodes_aux = [inode+(0:2)  inode+npx+(0:2)  inode+2*npx+(0:2)];
                T(ielem,:) = nodes_aux([1  3  9  7  2  6  8  4  5]); 
            end
        end
    else
        error('not available element')        
    end
    
elseif elem == 1
    if nen == 3
        T = zeros(nx*ny,3);
        for i=1:ny
            for j=1:nx
                ielem = 2*((i-1)*nx+j)-1;
                inode = (i-1)*(npx)+j;
                T(ielem,:) = [inode   inode+1   inode+(npx)];
                T(ielem+1,:) = [inode+1   inode+1+npx   inode+npx];
            end   
        end
        % Modification of left lower and right upper corner elements to avoid them 
        % having all their nodes on the boundary
        if npx > 2
            T(1,:) = [1  npx+2   npx+1];
            T(2,:) = [1    2     npx+2];
            aux = size(T,1);
            T(aux-1,:) = [npx*ny-1    npx*npy   npx*npy-1];
            T(aux,:)   = [npx*ny-1    npx*ny    npx*npy];
        end
    elseif nen == 6
        T = zeros(2*nx*ny,6); 
        for i=1:ny
            for j=1:nx
                ielem=2*((i-1)*nx+j)-1;
                inode=(i-1)*2*(npx)+2*(j-1)+1;
                nodes_aux = [inode+(0:2)  inode+npx+(0:2)  inode+2*npx+(0:2)];
                T(ielem,:) = nodes_aux([1  3  7  2  5  4]);
                T(ielem+1,:) = nodes_aux([3  9  7  6  8  5]);
            end    
        end
        % Modification of left lower and right upper corner elements to avoid them 
        % having all their nodes on the boundary
        if npx > 3
            inode = 1; 
            nodes_aux = [inode+(0:2)  inode+npx+(0:2)  inode+2*npx+(0:2)];
            T(1,:) = nodes_aux([1  9  7  5  8  4]);
            T(2,:) = nodes_aux([1  3  9  2  6  5]);

            ielem  = size(T,1)-1;
            inode = npx*(npy-2)-2; 
            nodes_aux = [inode+(0:2)  inode+npx+(0:2)  inode+2*npx+(0:2)];
            T(ielem,:) = nodes_aux([1  9  7  5  8  4]);
            T(ielem+1,:) = nodes_aux([1  3  9  2  6  5]);
        end
    else
        error('not available element')
    end
else
    error('not available element')
end      

end
