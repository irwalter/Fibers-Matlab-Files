
clc
clear all
close all

% Script that finds RSC constants from a mechanistic model Simulation

% STEP 1%
% Load mechanistic model data and transform it into tensors.
folder_name = uigetdir; % select the folder that contains the output folder
numFramesFileName=[folder_name '\output\nbr_frames.txt'];
positionsFileName=[folder_name '\output\positions.out'];
% the data below was pulled from Fibers.in

dt = 1e-6;
shear_rate = 100;
write_freq = 5000;
fprintf('Loading Mechanistic model results \n' );
[a_ij_mech, totalDeformation_mech ] =  compute_a_ij_fromFile(numFramesFileName, positionsFileName, dt, shear_rate, write_freq  );
fprintf('Mechanistic model results loaded \n' );


% STEP 2%
% Initialize values
%%%%%%%%%%%%%%%%%%%%%%%   INPUT   %%%%%%%%%%%%%%%%%%%%%%%
shear_rate =100;  %Shear Flow
epsilon_dot=+1; %Elongational rate
delta_time=0.001;
totalStrain=max(totalDeformation_mech*1.1);
ndim=3;
minDeformation = totalDeformation_mech/2;
maxDeformation = 300;
if ndim == 3
    a_ij_calc_indices = [1 2 3 5 6 9];
    titles = ['a_{11}'; 'a_{12}'; 'a_{13}'; 'a_{22}'; 'a_{23}'; 'a_{33}' ];
end
if ndim == 2
    a_ij_calc_indices = [1 2 4];
    titles = ['a_{11}'; 'a_{12}'; 'a_{22}'];
end
re=20;
Ci=0.1;
flow_type=1;
lambda=1;%(1-re^2)/(1+re^2)
kappa=1;
closureType = 9;
% 3D Random initial orientation
a2=zeros(ndim,ndim);

if ndim == 2
    a2(1,1)= a_ij_mech(1,1); %a11
    a2(1,2)= a_ij_mech(1,2); %a12
    a2(2,1)= a_ij_mech(1,2); %a12
    a2(2,2)= a_ij_mech(1,3); %a11
end

if ndim ==3
    a2(1,1)= a_ij_mech(1,1); %a11
    a2(1,2)= a_ij_mech(1,2); %a12
    a2(2,1) = a2(1,2);
    a2(1,3)= a_ij_mech(1,3); %a12
    a2(3,1) = a2(1,3);
    a2(2,2)= a_ij_mech(1,4); %a22
    a2(2,3)= a_ij_mech(1,5); %a23
    a2(3,2) = a2(2,3);
    a2(3,3)= a_ij_mech(1,6); %a33
end

minIndex =1;
for i = 1 : length(totalDeformation_mech)
    if totalDeformation_mech(i) > minDeformation
        minIndex = i;
        break
    end
end

maxIndex =1;
for i = 1 : length(totalDeformation_mech)
    if totalDeformation_mech(i) > maxDeformation
        maxIndex = i;
        break
    end
end


[ omega, gamma_dot ] = InitializeFlowVars(shear_rate, epsilon_dot, flow_type,ndim );

plotIntermidiateResults =0;% 1 if want to plot intermediate results, 0 if not
% Start Loop

numComponents = 3* (ndim-1);

% STEP 3%
% Find Best Ci for each tensorial Component

figure(1)

for component = 1:4
    i = 1;
    % optimization will stop when tolerance or maximum number of iterations are
    % reached
    
    % Data used in the optimization
    % we know y for certain x, we want to find Beta
    % y is y_observed
    
    % y_observed comes from the mechanistic model data, that is a_ij_mech
    y_observed = a_ij_mech(:,i)';
    x = totalDeformation_mech;
    
    
    % Plot points we want to fit
    %figure(component)
    subplot(ndim,ndim,a_ij_calc_indices(component))
    plot(x,y_observed,'r-X')
    hold on
    
    % Function call!!!!!!!!!
    % you should be able to calculate the value of the function for the x given
    % above and Beta.
    % it is here where you would put your specific function.
    
    %-----------------------------------------------------------
    % Begin Genetic Algorithm Optimization
    
    % Function and known parameters
    f = @ComputeRSC_Evolution;
    % knowns = [a2,omega,gamma_dot,totalStrain,closureType,delta_time,a_ij_calc_indices(component), a_ij_mech];

    % Function Call
    [p,e] = OptimizeGA(f,a2,omega,gamma_dot,totalStrain,closureType,delta_time,a_ij_calc_indices(i), a_ij_mech,x,y_observed);
    
    % y values with optimized parameters
    [ y_calculated ] = ComputeRSC_Evolution( a2, omega, gamma_dot, totalStrain, p(1),p(2), closureType,delta_time,a_ij_calc_indices(i), a_ij_mech, x);

    %-----------------------------------------------------------
    
    % Plot best guess
    % plot(x,y_calculated,'g' )
    
   
    fprintf('------------------------------------------------')    
    fprintf('Component: %d \n', i )
    fprintf('Error is: %f \n', e )
    fprintf('Ci: %f \n',p(1))
    fprintf('Kappa: %f \n ',p(2))
    subplot(ndim,ndim,a_ij_calc_indices(component))
    plot(x,y_calculated );
    
    str = sprintf(' %s Optimized',titles(i,:));
    title(str);
    ylim([0 1 ]);
    hold off
    
    % Store the Ci
    BestCis(component) = p(1);
    BestKappas(component) = p(2);
    Errors(component) = e;
end
fprintf('Cis and Kappas found \n')


% store results in a file

fileID = fopen([folder_name '\output\Best Parameters.txt'],'w');
fprintf(fileID,'%12s %12s %12s %12s\n','Component', 'Best Ci', 'Best Kappa', 'Error');
for i=1:4
    fprintf(fileID,'%12s %12f %12f %12f\n',titles(component,:), BestCis(i) ,BestKappas(i), Errors(i));
end
fclose('all');


