********************************************
DESCRIPTION OF FILES CONTAINED IN THE FOLDER
********************************************

CP_function.m = main Matlab function to be run
model.stl =  STL model of the simulated component
FEM_results = folder containing all the nodal results of stress and strain from the finite element analysis
nodes_coordinates.txt = text file containing all information of nodal numbers and coordinates

*********************************
NECESSARY STEPS TO RUN THE SCRIPT 
*********************************

0) Generate the stress and strain tensors result files and copy them in the "FEM_results" folder. 
***Only in the case of Ansys Workbench you can use the ready-to-use code provided. If another FEM software is used you have to export stress and strain results creating .csv files structured as the ones contained in FEM_results folder***

1) Open CP_function.m with the Matlab program

2) Under PARAMETERS set the quantities you are interested in:

- directoryRESULTS      % Directory containing stress and strain results for each node (default "FEM_results")
- blocklength           % How many load steps are present in the .csv files inside "directoryRESULTS" (default 5)
- kFS                   % Material constant of Fatemi-Socie critical plane factor (default 0.4)
- Sy                    % Yield strengh (default 355)
- NameFile              % Name of the results file (default 0.4)
- LoadSteps             % Considered loadsteps (default 0.4)
- CP                    % Which critical plane factor you want to evaluate (default "FS")

3) RUN the script in Matlab
