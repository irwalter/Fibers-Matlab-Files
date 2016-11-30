% Script that calculates orientation tensors in specified volume

clc
clear all
close all

folder_name = uigetdir; % Select the folder that contains the output folder

% counting number of boundary fibers
FiberInput =[folder_name '\input\Initial_Positions.txt'];
FileName=fopen(FiberInput);

f_bound = 0; % number of boundary fibers

% Read number of fibers
numFibers=fscanf(FileName,'%g',1);

% Checking if fiber is stationary
for i = 1:numFibers
    
    % number of nodes in fibers
    numNodes = fscanf(FileName,'%g',1);
    % Checking if node is stationary
    for j = 1:numNodes
        node = fscanf(FileName,'%g',4);
        % if 1st node is stationary, counts as boundary fiber
        if (j == 1 && node(1) == 1)
            f_bound = f_bound+1;
        end
    end
end


% The data below will be pulled from position files
baseFileName =[folder_name '\output\Positions_'];

% output file
fileIDnew = 'orientation.csv';
% Header
xlswrite(fileIDnew, {'frame', 'a11' 'a12' 'a13' 'a22' 'a23' 'a33' 'fibers inside' 'percentage inside'})


% Box boundaries
min_coor = [0.00082,-.049843,-.002501];
max_coor = [0.00408,.049843,.000501];


% counter that keeps track of position in fibers matrix for orientation
% calculation
f_spot = 1;

for frameNum = 1:1000
    
    fileNum=int2str(frameNum);
    % For modifying so 39 is 0039 for file names
    if length(fileNum)==3
        fileNum=horzcat('0', fileNum);
    elseif length(fileNum)==2
        fileNum=horzcat('00', fileNum);
    elseif length(fileNum)==1
        fileNum=horzcat('000', fileNum);
    end
    filePath=horzcat(baseFileName, fileNum, '.txt');
    
    if exist(filePath, 'file')
        A_ij(1,frameNum) = frameNum;
        fileName=fopen(filePath);
        % Read number of fibers
        numFibers=fscanf(fileName,'%g',1);
        
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
                if ( nodes(j,1) <= max_coor(1) && nodes(j,1) >= min_coor(1))
                    %   if ( nodes(j,2) <= max_coor(2) && nodes(j,2) >= min_coor(2))
                    if ( nodes(j,3) >= max_coor(3))% && nodes(j,3) >= min_coor(3))
                        n = n+1;
                    end
                    %  end
                end
            end
            % if all nodes in boundary, entire fiber in boundary, add one to fiber
            % count
            if n == numNodes && i > f_bound;
                f = f+1; % number of fibers inside volume
                
                % Adding fiber to matrix for use in calculating orientation
                fibers(f_spot,:) = [numNodes 0 0];
                for k = 1:numNodes
                    fibers(f_spot+k,:) = nodes(k,:);
                end
                f_spot = f_spot+numNodes+1;
            end
        end
        if f > 0
            % Calculation of orientation tensors if fibers in volume of
            % interest
            A_ij(2:7, frameNum) = compute_a_ij(fibers, f);
        end
        
        % total number of fibers in rib
        numFibers;
        fibers_inside = f;
        A_ij(8,frameNum) = f;
        percentage_inside = f/(numFibers-f_bound);
        A_ij(9,frameNum) = percentage_inside;
        
    end
    
end
% writing to new file
A_ij = A_ij';
xlswrite(fileIDnew, A_ij, 'sheet1','A2')



