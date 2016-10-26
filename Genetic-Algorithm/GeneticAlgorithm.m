clear;
clc;

% x and y represent the data from the curve you are trying to fit
x = 0:.1:10;
y = 2*x.^2+3*x+4;

% f is the fucntion that you are trying to match
% it's input parameters need to be arranged in the following manner
% first entry is the vector x
% second entry is a vector with variables to be optimized
% third entry is  vector with constant variables
f = @TestFunction;
% the second entry is a vector with all your known variables
% the final two are the vectors containing the x and y positions of the
% data you're matching
for i = 1:4 % if you would like to run multiple iterations
    [p(i),e(i)] = OptimizeGA(f,[3,4],x,y);
end
for i = 1:4
       fprintf('parameters run %d of %d: %f\n',i,4, p(i))
       fprintf('error run %d of %d: %f\n', i, 4, e(i));
end