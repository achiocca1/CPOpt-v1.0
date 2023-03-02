******************************************
DESCRIPTION OF WHAT YOU FIND IN THE FOLDER
******************************************


CP_function.m = main Matlab function to be run
model.stl =  STL model of the simulated component
FEM_results = folder containing all the nodal results of stress and strain from the finite element analysis
nodes_coordinates.txt = text file containing all information of nodal numbers and coordinates

1) Open CP_function.m
2) Set in PARAMETERS the quantities you are interested in:

- directoryRESULTS      % Directory containing stress and strain results for each node
- blocklength           % How many load steps are present in the .csv files inside "directoryRESULTS"
- kFS                   % Material constant of Fatemi-Socie critical plane factor
- Sy                    % Yield strengh
- NameFile              % Name of the results file
- LoadSteps             % Considered loadsteps
- CP                    % Which critical plane factor you want to evaluate

3) RUN the script
4) Read the text file that was generated, it will bring back all the key information
