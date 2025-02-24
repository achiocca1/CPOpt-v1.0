# CPOpt
```diff
- Be sure you are running the latest release available (v2.0.0)!
```
This repository contains the implementation of the CPOpt method, an efficient algorithm designed to optimize the calculation of critical plane factors for fatigue assessment. Traditional critical plane methods are often time-consuming due to the use of nested loops, making them impractical for complex geometries or time-sensitive applications. CPOpt addresses this challenge by using tensor invariants and coordinate transformation laws to streamline the process, significantly reducing computation time while maintaining accuracy.

This method is applicable to various critical plane factors that require parameter maximization based on stress and strain components. The repository includes the algorithm, validation data, and examples, demonstrating its effectiveness across different geometries and loading conditions.

CPOpt is a valuable tool for both researchers and engineers working on fatigue analysis in demanding industrial contexts.

The mathematical procedure is described in the article:

**A. Chiocca, F. Frendo, G. Marulo, "An efficient algorithm for critical plane factors evaluation", International Journal of Mechanical Sciences, Volume 242, 2023, 10.1016/j.ijmecsci.2022.107974.**

Bug reports and suggestions are welcome!  
This software is regularly maintained.

Contact me at andrea.chiocca@unipi.it if you need assistance or you need to implement a specific critical plane model within the code.

---

# FS and SWT Analysis

This repository contains a MATLAB-based analysis tool that computes critical plane factors using the Fatemi-Socie (FS) and Smith-Watson-Topper (SWT) criteria. It is designed to analyze simulation data extracted from ANSYS for a specimen subjected to tensile loading.

## Repository Contents

- **MAIN.m**  
  The primary MATLAB script containing the analysis code. It reads the simulation data from CSV files, performs the FS and SWT analysis, and generates 3D visualizations.

- **Results.csv**  
  An example CSV file containing simulation results extracted from ANSYS. This file includes node numbers, elastic strain components (EPEL), plastic strain components (EPPL), and stress components.

- **COORD.csv**  
  An example CSV file containing nodal coordinate data corresponding to the simulation. Each row lists the node number and its X, Y, and Z coordinates.

- **ANSYS_Post_Process_Results.mac**  
  An ANSYS macro that extracts simulation results and nodal coordinates from ANSYS. The macro creates the `Results.csv` and `COORD.csv` files used by the MATLAB script.

## Getting Started

### Prerequisites

- **MATLAB**  
  This script was developed and tested using MATLAB. Ensure that you have MATLAB installed on your computer. No additional toolboxes are required.

- **ANSYS** (optional)  
  If you wish to generate your own simulation data, you will need ANSYS to run the provided macro (`ANSYS_Post_Process_Results.mac`).

### Installation

1. Clone or download this repository to your local machine.
2. Ensure that the following files are in the same folder:
   - `MAIN.m`
   - `Results.csv`
   - `COORD.csv`

### Usage

1. **Running the MATLAB Analysis**  
   - Open MATLAB.
   - Navigate to the repository folder.
   - Open and run the `MAIN.m` script by typing `MAIN` in the MATLAB command window or by pressing F5.
   - The script will import the CSV files, perform the FS and SWT analysis, and display several 3D plots with the results.

2. **Generating Your Own Data with ANSYS**  
   - Run your simulation in ANSYS.
   - Use the provided ANSYS macro (`ANSYS_Post_Process_Results.mac`) to extract the necessary data into CSV files.
   - Replace the example CSV files in the repository with your own generated files and run `MAIN.m` again.

## Using the ANSYS Macro

The file `ANSYS_Post_Process_Results.mac` is provided to extract simulation data from ANSYS. Follow these steps to use it:

1. **Named Selection – Node_SET**  
   - Create a named selection in ANSYS called **Node_SET** that selects the nodes of interest.
   - *Important:* Select only the corner node(s) of the specimen. Avoid including midside nodes to ensure accurate results.

2. **Running the Macro**  
   - **In ANSYS Workbench:**  
     Add a "Command" object under the "Solution" section and paste the contents of `ANSYS_Post_Process_Results.mac` or reference the file. This will execute the macro when you update the solution.
   - **In ANSYS APDL:**  
     Run the macro directly by executing the file from the command window.

3. **Expected Structure of Generated CSV Files**  
   - **RESULTS.csv:**  
     Each row corresponds to a node for a given load step. The columns (in order) are:
     - **Node Number**  
     - **Load Step Index (j)**  
     - **Elastic Strain Components (EPEL):** x, y, z, xy, yz, xz  
     - **Plastic Strain Components (EPPL):** x, y, z, xy, yz, xz  
     - **Stress Components:** s_x, s_y, s_z, s_xy, s_yz, s_xz
     
   - **COORD.csv:**  
     Each row corresponds to a node, with the following columns:
     - **Node Number**  
     - **X Coordinate**  
     - **Y Coordinate**  
     - **Z Coordinate**

## Customization

- **Parameters in MAIN.m**  
  You can modify various parameters at the top of `MAIN.m`, such as:
  - `FileName` and `FileNameCoord` for specifying the names of your CSV files.
  - `LoadSteps` to define which load steps to analyze.
  - `kFS` and `Sy` for adjusting the Fatemi-Socie model parameters.

- **Visualization Settings**  
  The script includes sections for plotting results and critical planes. Adjust marker sizes, transparency, and other plot settings as needed.

## Support and Contributions

If you encounter any issues or have suggestions for improvement, please open an issue or submit a pull request. Contributions to enhance the tool are welcome!
