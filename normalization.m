function [ output ] = normalization( input )
% shift start point of the input signal to zero, 
% and keep its amplitude within one.

input = input - input(1);
ratio = min(1./abs(max(input)), 1./abs(min(input)));
output = input*ratio;  

end

