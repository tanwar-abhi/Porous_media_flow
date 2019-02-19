function [ out ] = cinput( r,def )
%to input the value of the coefficients

% text = [s  ' (default '  num2str(value)  ')= ']; 
% res = input(text); 
% out = input(text);

out = input(r);

if isempty(out)
    out = def;
end

end

