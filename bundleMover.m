% Move fiber bundles

clear;
clc;

% Input
% distance user desires to move bundle
move_x = 0;
move_y = 0;
move_z = -0.0006;

% number of boundary fibers (0 if none)
boundary_fibers = 20;

% Begin

folder_name = uigetdir; % Select the folder that contains the input folder

% The data below is from the fiber positions input into mechanistic model
% simulation
filePath=[folder_name '\input\Initial_Positions.txt'];
fileName=fopen(filePath);

% Read number of fibers
numFibers=fscanf(fileName,'%g',1)

% Open .txt file for new fibers
fileIDnew = fopen('Initial_Positions.txt','w');
fprintf(fileIDnew,'%d\r\n',numFibers);

% format for writing new lines
formatSpec = '%d %E %E %E \r\n';

% keep track of box dimensions
dimensions = zeros(2,3);

for i = 1:numFibers
    
    % number of nodes in fibers
    numNodes = fscanf(fileName,'%g',1);
    fprintf(fileIDnew,'%d\r\n',numNodes);
    
    for j = 1:numNodes
        % Scanning in nodes
        nodes(1, :) = fscanf(fileName,'%g',4);
        % doesn't move boundary fibers or count their positions for box
        % dimensions
        if i > boundary_fibers
            % initializing bundle dimensions
            if i == boundary_fibers+1
                dimensions(1,:) = nodes(2:4);
                dimensions(2,:) = nodes(2:4);
            end
            % determining current dimensions of bundle
            if nodes(2) < dimensions(1,1)
                dimensions(1,1) = nodes(2);
            end
            if nodes(2) > dimensions(2,1)
                dimensions(2,1) = nodes(2);
            end
            if nodes(3) < dimensions(1,2)
                dimensions(1,2) = nodes(2);
            end
            if nodes(3) > dimensions(2,2)
                dimensions(2,2) = nodes(2);
            end
            if nodes(4) < dimensions(1,3)
                dimensions(1,3) = nodes(4);
            end
            if nodes(4) > dimensions(2,3)
                dimensions(2,3) = nodes(4);
            end
            % updating position of bundle
            nodes(2) = nodes(2) + move_x;
            nodes(3) = nodes(3) + move_y;
            nodes(4) = nodes(4) + move_z;
        end
        % writing to new file
        fprintf(fileIDnew,formatSpec,nodes);
        
    end
    
end

fclose('all');

dimensions

