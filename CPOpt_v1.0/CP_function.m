clear all
close all
clc




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% INPUT PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
directoryRESULTS = "FEM_results"; % Directory containing stress and strain results for each node
blocklength = 5;                  % How many load steps are present in the .csv files inside "directoryRESULTS"
kFS = 0.4;                        % Material constant of Fatemi-Socie critical plane factor
Sy = 350; % (MPa)                 % Yield strengh
NameFile = 'Final_results.txt';   % Name of the results file
LoadSteps = [1, 5];                % Considered loadsteps
CP = "FS";  % or "SWT"            % Which critical plane factor you want to plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%









%% START DATA READING %%
Files = dir(directoryRESULTS);
% Read Stress Strain from ANSYS files
FileNames = [];
for K=1:length(Files)
    
    if Files(K).bytes == 0
        continue % Eliminate the files with zero bytes extension
    else
        file = Files(K).name;
        FileNames = [FileNames, string(file)];
    end
    
end
% Variable PREALLOCATION FS
RESFS = zeros( length(FileNames), 6); % Matrix containing results
FSlist = zeros( length(FileNames), 2); % FS list
GammaFS = zeros( length(FileNames), 1); % DeltaGamma list
% Variable PREALLOCATION SWT
RESSWT = zeros( length(FileNames), 6); % Matrix containing results
SWTlist = zeros( length(FileNames), 2); % SWT list
DeltaESWT = zeros( length(FileNames), 1); % DeltaEps list
% Import data from files
index = 1; % Necessary for good preallocation of matrix
f = waitbar(0,'Simulation in progress...'); % PROGRESS BAR Option
for i = 1 : length(FileNames)
    file = csvread(strcat(directoryRESULTS,"\",FileNames(i)),2,1);
    nodenumber = sscanf(FileNames(i), 'risultati_%d.csv'); % get the node number
    %% FINISH DATA READING %%
    % Stress and Strain matrix creation through cell array
    % Preallocate cell memory
    E = cell(1, blocklength);
    S = cell(1, blocklength);
    for j = 1 : blocklength
        E0 = [file(j,1) + file(j,7), (file(j,4) + file(j,10))/2, (file(j,6) + file(j,12))/2;
            (file(j,4) + file(j,10))/2, file(j,2) + file(j,8), (file(j,5) + file(j,11))/2;
            (file(j,6) + file(j,12))/2, (file(j,5) + file(j,11))/2, file(j,3) + file(j,9)];
        E{j} = E0; % Strain Tensors
    end
    for j = 1 : blocklength
        S0 = [file(j,13), file(j,16), file(j,18);
            file(j,16), file(j,14), file(j,17);
            file(j,18), file(j,17), file(j,15)];
        S{j} = S0; % Stress Tensors
    end
    %Delta eps
    DeltaE = E{1, LoadSteps(1)} - E{1, LoadSteps(2)};
    % Calculate and sort principal strains
    [Vs, D0] = eig(DeltaE);
    [D0, ind] = sort(diag(D0), 'descend');
    V0 = Vs(:, ind);
    EigenvectE = V0; % Strain Tensor
    EigenvalE = D0; % Strain Tensor
    %% ANALYTICAL MODEL FS STARTS %%
    DeltaGammaMax = (max(EigenvalE(:)) - min(EigenvalE(:)))/2;
    % Principal directions
    xn = EigenvectE(:,1);
    yn = EigenvectE(:,2);
    zn = EigenvectE(:,3);
    % Rotation of 45° of the principal direction reference frame
    Matr = V0*[cos(pi/4)   0   sin(pi/4);
        0        1        0;
        -sin(pi/4)   0   cos(pi/4)];
    % Get the direction from the newly rotated matrix
    dir_1 = Matr(:,1); %x'
    n_rot = Matr(:,2);
    dir_2 = Matr(:,3); %z'
    % Stresses normal to the DeltaGamma max planes
    Sigman = [dir_1.'*S{1, LoadSteps(1)}*dir_1, dir_2.'*S{1, LoadSteps(1)}*dir_2, dir_1.'*S{1, LoadSteps(2)}*dir_1, dir_2.'*S{1, LoadSteps(2)}*dir_2];
    SmaxFS = max(Sigman);
    % FS calculation
    FS = DeltaGammaMax*(1 + kFS*(SmaxFS/Sy));
    % Get the XYZ rotation in order to reach the configuration [dir_1, n, dir_2]
    % Matr represent the principal direction matrix rotated in local around Y
    Matr = [xn yn zn]*[cos(pi/4)   0   sin(pi/4)
        0        1        0
        -sin(pi/4)   0   cos(pi/4)];
    ThetaFS = atan2(-Matr(2,3), Matr(3,3));
    PsiFS = atan2(Matr(1,3), (Matr(1,1)^2 + Matr(1,2)^2)^0.5);
    AlphaFS = atan2(-Matr(1,2), Matr(1,1));
    %%% ANALYTICAL MODEL FS ENDS %%%
    %% ANALYTICAL MODEL SWT STARTS %%
    [DeltaEmax, I] = max(abs(EigenvalE(:)));
    % Principal directions
    xn = EigenvectE(:,1);
    zn = EigenvectE(:,3);
    yn = EigenvectE(:,2);
    if I == 1
        vect = xn;
    elseif I == 3
        vect = zn;
    end
    Sigman = [vect.'*S{1, LoadSteps(1)}*vect, vect.'*S{1, LoadSteps(2)}*vect];
    SmaxSWT = max(Sigman);
    SWT = SmaxSWT*DeltaEmax/2;
    % Get the XYZ rotation in order to reach the configuration [xn, yn, zn]
    % Matr represent the principal direction matrix
    Matr = [xn yn zn];
    ThetaSWT = atan2(-Matr(2,3), Matr(3,3));
    PsiSWT = atan2(Matr(1,3), (Matr(1,1)^2 + Matr(1,2)^2)^0.5);
    AlphaSWT = atan2(-Matr(1,2), Matr(1,1));
    %%% ANALYTICAL MODEL SWT ENDS %%%
    %% RESULTS FS %%
    RESFS(i, :) = [nodenumber FS SmaxFS ThetaFS PsiFS AlphaFS];
    GammaFS(i, :) = DeltaGammaMax;
    FSlist(i, 2) = FS;
    FSlist(i, 1) = nodenumber;
    %% RESULTS SWT %%
    RESSWT(i, :) = [nodenumber SWT SmaxSWT ThetaSWT PsiSWT AlphaSWT];
    DeltaESWT(i, :) = DeltaEmax;
    SWTlist(i, 2) = SWT;
    SWTlist(i, 1) = nodenumber;
    index = index + 1;
    % PROGRESS BAR %
    waitbar(i/length(FileNames))
end
delete(f) % wait bar deleted
%% PLOT on .stl %%
coord = importdata('nodes_coordinates.txt','\t',1);
% We import data from FEM
% Mesh nodes coordinates in m
FemPoints = 1E-03*coord.data(:, 2:4);
% Critical plane factor values
switch CP
    case 'FS'
        FemStressCoef = FSlist(:,2);
    case 'SWT'
        FemStressCoef = SWTlist(:,2);
end
% The import can be viewed via the 'triplot' function.
ModelTriData = stlread('model.stl');
Dam_value = FemStressCoef;
F = scatteredInterpolant(FemPoints, Dam_value, 'linear','nearest');
Dam_stl = F(ModelTriData.Points);
h = trisurf(ModelTriData, Dam_stl,'HandleVisibility','off');
h.FaceColor = 'interp';
h.EdgeColor = 'black';
h.LineWidth = 0.01;
h.EdgeAlpha = 0.1;
colorbar
set(gca, 'color', 'none');
axis equal
title("Critical plane method: " + CP)
view(120,30)
%% FS %%
[M,I] = max(GammaFS); % Look for FS max index
FinalRESFS = RESFS(I,:);
gammamaxFS = M; % Look for gamma max
%% SWT %%
[M,I] = max(DeltaESWT); % Look for FS max index
FinalRESSWT = RESSWT(I,:);
epsmaxSWT = M; % Look for eps max
%% Plot critical node %%
hold on
scatter3(FemPoints(I,1), FemPoints(I,2), FemPoints(I,3),'o','MarkerEdgeColor','red','MarkerFaceColor','red')
legend('Critical node')
%% Write files
% open your file for writing
fid = fopen(NameFile,'wt');
% write the matrix
if fid > 0
    fprintf(fid,'Fatemi-Socie critical plane factor');
    fprintf(fid,'              %s           %s             %s        %s       %s       %s       %s\n', 'Critical node number', 'FS', 'Smax (MPa)', 'Theta (rad)', 'Psi (rad)', 'Alpha (rad)',char(916,947,' ','m','a','x'));
    fprintf(fid,'%s:                                                  %8.0f           %1.8f            %4.1f             %1.4f            %1.4f          %1.4f          %1.6f\n','Data',FinalRESFS',gammamaxFS);
    fprintf(fid,'Smith-Watson-Topper critical plane factor');
    fprintf(fid,'       %s           %s             %s        %s       %s       %s       %s\n', 'Critical node number', 'SWT', 'Smax (MPa)', 'Theta (rad)', 'Psi (rad)', 'Alpha (rad)',char(916,949,' ','m','a','x'));
    fprintf(fid,'%s:                                                  %8.0f           %1.8f            %4.1f             %1.4f            %1.4f          %1.4f          %1.6f\n','Data',FinalRESSWT',epsmaxSWT);
end
clear variables