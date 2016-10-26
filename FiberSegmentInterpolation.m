% Fiber Segment Interpolation

clear;
clc;

% Input
numSegs = 4; % Number of segments to divide each current segment into

% Begin

folder_name = uigetdir; % Select the folder that contains the input folder

% The data below was pulled from Moldex3D
filePath=[folder_name '\input\Initial_Positions.txt'];
fileName=fopen(filePath);

% Read number of fibers
numFibers=fscanf(fileName,'%g',1)

% Open .txt file for new fibers
fileIDnew = fopen('coords.txt','w');
fprintf(fileIDnew,'%d\r\n',numFibers);

% format for writing new lines
formatSpec = '%d %E %E %E \r\n';

for i = 1:numFibers
    
    % number of nodes in fibers
    numNodes = fscanf(fileName,'%g',1);
    fprintf(fileIDnew,'%d\r\n',(numNodes-1)*numSegs+1);
    newNodes = zeros(numNodes*numSegs-1,4);
    numNodes*numSegs-1
    % scanning in position of nodes
    for j = 1:numNodes
        nodes(j, :) = fscanf(fileName,'%g',4);
    end
    
    %creating new nodes
    for j = 1:(numNodes-1)
        
        newNodes(j,:) = nodes(j,:); % Rewriting 1st existing node
        fprintf(fileIDnew,formatSpec,newNodes(j,:));
        nodeStep = (nodes(j+1,:)-nodes(j,:))/numSegs;
        % Creating new nodes
        for k = 1:(numSegs-1)
            newNodes(j+k,1) = nodes(j,1); % is fiber stationary
            newNodes(j+k,2:4) = nodes(j,2:4)+nodeStep(2:4)*k;
            fprintf(fileIDnew,formatSpec,newNodes(j+k,:));
        end
            
    end
    newNodes(j*k+1,:) = nodes(j+1,:); % Rewriting last existing node
    fprintf(fileIDnew,formatSpec,newNodes(j*k+1,:));
    newNodes

end

    fclose('all');
    