function PlotMesh(T,X,elem,str,nonum)
% PlotMesh(T,X,str,nonum)
% X:    nodal coordinates
% T:    connectivities 
% str:  linestyle, color and marker used in the plot (optional)
% nonum = 1 to show nodes' number(optional)


% Line style and color
if nargin == 3
  str1 = 'yo';
  str2 = 'y-';
else
  if str(1) == ':' | str(1) == '-'  
    str1 = 'yo'; 
    str2 = ['y' str];
  else
    str1 = [str(1) 'o'];
    str2 = str;
  end
end
 
nen = size(T,2);


if elem == 0
    if nen <= 4
        order = [1:nen,1]; 
    elseif nen == 9
        order = [1,5,2,6,3,7,4,8,1]; 
    end
elseif elem == 1
    if nen <= 3
        order = [1:nen,1];
    elseif nen == 6
        order = [1,4,2,5,3,6,1]; 
    end
elseif elem == 11
    order = [1:3,1]; 
end


% Nodes
plot(X(:,1),X(:,2),str1)
hold on
% Elements
for j = 1:size(T,1)
    plot(X(T(j,order),1),X(T(j,order),2),str2)
end

    
% nodes number
if nargin==5 
    if nonum==1
        for I=1:size(X,1)
            text(X(I,1)+0.02,X(I,2)+0.03,int2str(I),'FontSize',10)
        end
    end
end

axis('equal')    
axis('off') 

hold off 
