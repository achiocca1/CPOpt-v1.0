
ALL THE FILES PRESENT IN THE FOLDER REFER TO A READY-TO-USE MODEL. 
JUST TRY TO RUN CP_function.m IN MATLAB ENVIRONMENT TO TEST THE CODE.

********************************************
DESCRIPTION OF FILES CONTAINED IN THE FOLDER
********************************************

ANSYS_Post_Process_Results.mac = APDL command necessary for a correct post-processing of results in Ansys (it can be used only in Ansys, if any other FEM software is used you need to correctly post-process results as the ones contained in the "FEM_results" folder)
CP_function.m = main Matlab function to be run
model.stl =  STL model of the simulated component
FEM_results = folder containing all the nodal results of stress and strain from the finite element analysis
nodes_coordinates.txt = text file containing all information of nodal numbers and coordinates


*********************************
NECESSARY STEPS TO RUN THE SCRIPT 
*********************************

0) Generate the stress and strain tensors result files and copy them into the "FEM_results" folder. 
***Only in the case of Ansys Workbench you can use the ready-to-use code provided (ANSYS_Post_Process_Results.mac). If another FEM software is used you have to export stress and strain results creating .csv files structured as the ones contained in FEM_results folder***

1) Generate an .STL file of your model and call it model.stl

2) Generate a file containing the following nodal information: Node Number, X Location (mm), Y Location (mm), Z Location (mm). Call it nodes_coordinates.txt

3) Open CP_function.m with the Matlab program

4) Under PARAMETERS set the quantities you are interested in:

- directoryRESULTS      % Directory containing stress and strain results for each node (default "FEM_results")
- blocklength           % How many load steps are present in the .csv files inside "directoryRESULTS" (default 5)
- kFS                   % Material constant of Fatemi-Socie critical plane factor (default 0.4)
- Sy                    % Yield strength (default 355)
- NameFile              % Name of the results file (default "Final_results.txt")
- LoadSteps             % Considered load steps (default [1, 5])
- CP                    % Which critical plane factor is evaluated (default "FS")

5) RUN the script in Matlab
