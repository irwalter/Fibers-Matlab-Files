% Allows user to create a new Initial_Positions.txt file for restarting a
% precompression run

% Also saves the max and min values for x positions to aid in determining
% new compression ratio

clc
clear all
close all

folder_name = uigetdir; % Select the folder that contains the output folder

% File containing the fibers in the last frame
fileName=fopen('Positions.txt');

% Read number of fibers
numFibers=fscanf(fileName,'%g',1);

% Open .txt file for fibers
fileIDnew = fopen('Initial_Positions.txt','w');
fprintf(fileIDnew,'%d\r\n',numFibers);

% format for writing new lines
formatSpec = '%d %E %E %E \r\n';

% keep track of extreme values
min_z = 0;
max_z = 0;


% Main Loop
for i = 1:numFibers
    
    % number of nodes in fibers
    numNodes = fscanf(fileName,'%g',1);
    % Writing number of nodes to new fiber file
    fprintf(fileIDnew,'%d\r\n',numNodes); 
    
    
    % scanning in position of nodes and adding 0 to denote moving
    for j = 1:numNodes
        nodes = zeros(1,4);
        nodes(2:4) = fscanf(fileName,'%g',3);
        fprintf(fileIDnew,formatSpec,nodes);
        if nodes(4) < min_z
            min_z = nodes(4);
        elseif nodes(4) > max_z
            max_z = nodes(4);
        end
    end
    
    
end

fclose('all');

min_z
max_z

