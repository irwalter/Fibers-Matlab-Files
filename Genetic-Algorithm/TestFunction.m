function [ y ] = TestFunction( x,p,c )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
a = p;
b = c(1);
c = c(2);
y = a*x.^2+b*x+c;
end

