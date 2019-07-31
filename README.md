# glucose-insulin


Install matlab (tested with matlab R2019a)

Install S-taliro from https://sites.google.com/a/asu.edu/s-taliro/s-taliro

Save the files in benchmarks.

Toolboxes required for running the Robust Testing Toolbox:
```bash

Multi Parametric Toolbox (http://control.ee.ethz.ch/~mpt/)
	   Tested version 3.0
	
CVX: Disciplined Convex Optimization (http://cvxr.com/cvx/)
	   Tested version 2.1
 
MatlabBGL: the hybrid distance metric with distances to the location guards
           (http://www.mathworks.com/matlabcentral/fileexchange/10922)
```


To setup S-TaLiRo run the following in the Matlab command window:
```bash
setup_staliro
```

Below is the table of the experiments file names and contents:
src-11 is the most complicated one and detail explanation can be found in the src-11 file readme.txt.
Note: We only showed the actual changed conditions here, all the planned conditions can be found in the code. 


| File name     | Specification | Actual Changed Condition      | Contents               |
| ------------- | ---------------|--------------- |------------------------|
| src  |  G_1 >= 4.5 /\ G_2 <= 9| CHO is 200 higher than planned| results & figure & code|
| src-3  | G_1 >= 4.5 /\ G_2 <= 9| CHO range is [100 200] |results & figure & code|
| src-4  | G_1 >= 4.5 /\ G_2 <= 9| meal duration [20 40]  |results & figure & code|
| src-5  | G_1 >= 4.5 /\ G_2 <= 9| simulation glucose pick time [40 60]  |results & figure & code|
| src-6  | G_1 >= 4.5 /\ G_2 <= 9 |CHO range is [100 200];pick time [40 60] |results & figure & code|
| src-7  |  G_1 >= 4.5 /\ G_2 <= 9 | CHO range is [160 200]  |results & figure & code|
| src-8  | case 1: scale= 2; G_1 >= 4.5 ; case 2: scale= 1; G_2 <= 9 |CHO range is [160 200]  |results & figures & code|
| src-11  |1. G_1<=9; 2. G_2>=4.5;3.I_1>=0.04; 4.I_2<=0.14 with scaled| CHO range is [160 200] |results & figures & code|
| src-12  |1. G_2>=4.5 2. G_2>=4.5/0.9=5  |CHO range is [100 140] lower than planned|results & figures & code|
