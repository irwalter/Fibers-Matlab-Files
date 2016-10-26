% Script that extracts position of fibers inside certain volume control

clc
clear all
close all

folder_name = uigetdir; % Select the folder that contains the output folder

% The data below was pulled from Moldex3D
filePath=[folder_name '\output\Positions_0010.txt'];
fileName=fopen(filePath);
f_bound = 15; % number of boundary fibers

% Read number of fibers
numFibers=fscanf(fileName,'%g',1);

% Box boundaries
x = -.081311-.028;
x1 = -.039201-.028;
min_coor = [x,-.049843,-.002501];
max_coor = [x1,.049843,.000501];

% Fiber Counter
f = 0;

for i = 1:numFibers
    
    % number of nodes in fibers
    numNodes = fscanf(fileName,'%g',1);
    nodes = zeros(numNodes,4);
    
    % scanning in position of nodes
    for j = 1:numNodes
        nodes(j, :) = fscanf(fileName,'%g',4);
    end
    
    % deleting whether moving or not
    nodes = nodes(:,2:4);
    
    % number of nodes in boundary
    n = 0;
    for j = 1:numNodes
        % checks if each node within boundaries
        %if ( nodes(j,1) <= max_coor(1) && nodes(j,1) >= min_coor(1))
         %   if ( nodes(j,2) <= max_coor(2) && nodes(j,2) >= min_coor(2))
                if ( nodes(j,3) >= max_coor(3))% && nodes(j,3) >= min_coor(3))
                    n = n+1;
                end
          %  end
        %end
    end
    % if all nodes in boundary, entire fiber in boundary, add one to fiber
    % count
    if n == numNodes && i > f_bound;
        f = f+1;
    end
end


% total number of fibers in rib
numFibers
fibers_inside = f

