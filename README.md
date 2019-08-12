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

Below is the table of the experimental file names and contents:\
src-11 is the most complicated one and detail explanation can be found in the src-11 file readme.txt.\
Note: We only showed the actual changed conditions here, all the planned conditions can be found in the code. \
(CHO is the meal carbohydrates)

| File name     | Trace Specification | Actual Changed Condition      | Contents               |
| ------------- | ---------------|--------------- |------------------------|
| data |  -|-| summarize 1.3, 3.3, 15.2, 16.2 file data |
| src  |  G >= 4.5 /\ G <= 9| CHO is 200 more than planned| results & figure & code|
| src-1.2  |  G >= 4.5 | CHO is 200 more than planned| results & figure & code|
| src-1.3  |  1. G >= 4.5 /\ G <= 9; 2. 2G >= 9 /\ G <= 9 | CHO is 200 more than planned| results & figure & code|
| src-3  | G >= 4.5 /\ G <= 9| CHO range is [100 200] |results & figure & code|
| src-3.2  | G >= 4.5 | CHO range is [100 200] |results & figure & code|
| src-3.3  |  1. G>= 4.5 /\ G <= 9; 2. 2G >= 9 /\ G <= 9 | CHO is [100 200] planned is 150| results & figure & code|
| src-4  | G >= 4.5 /\ G <= 9| meal duration [20 40]  |results & figure & code|
| src-4.2  | G >= 4.5| meal duration [20 40]  |results & figure & code|
| src-5  | G >= 4.5 /\ G <= 9| simulation glucose pick time [40 60]  |results & figure & code|
| src-5.2  | G >= 4.5| simulation glucose pick time [40 60]  |results & figure & code|
| src-6  | G>= 4.5 /\ G <= 9 |CHO range is [100 200];pick time [40 60] |results & figure & code|
| src-6.2  | G >= 4.5 |CHO range is [100 200];pick time [40 60] |results & figure & code|
| src-7  |  G >= 4.5 /\ G <= 9 | CHO range is [160 200] more than planned CHO |results & figure & code|
| src-7.2  |  G >= 4.5 | CHO range is [160 200] more than planned CHO |results & figure & code|
| src-8  | case 1: scale= 2; G >= 4.5 ; case 2: scale= 1; G <= 9 |CHO range is [160 200] more than planned CHO|results & figures & code|
| src-11  |1: G<=9; 2: G>=4.5;3:I>=0.04; 4: I<=0.14 with scaled robustness| CHO range is [160 200] more than planned CHO |results & figures & code|
| src-12  |1: G>=4.5; 2: dG>=4.5; 2: dG>=4.5  |CHO range is [100 140] less than planned CHO|results & figures & code|
| src-14  |1: G>=4.5; 2: dG>=4.5; 2: dG>=4.5  |CHO range is [70 100] less than planned CHO|results & figures & code|
| src-15  |G >= 4.5/d /\ G <= 9; d= 0.8  |CHO range is [160 200] more than planned CHO|results & figures & code|
| src-15.2  |1.G >= 4.5 /\ G <= 9; 2. G >= 9/2 /\ G <= 9;  |CHO range is [160 200] more than planned CHO|results & figures & code|
| src-15.3  |1. 1. G >= 4.5; 2. G<=9; 3. G >= 4.5 /\ G <= 9; 4. 2G >= 9 /\ G <= 9|CHO range is [160 200] or [70 140]|results & figures & code|
| src-16  |1. G >= 4.5; 2. G <= 9; with scaled robustness |CHO range is [30 40] much less than planned CHO 150|results & figures & code|
| src-16.2  |1. G >= 4.5 /\ G <= 9; 2. G >= 9/2 /\ G <= 9 | CHO is [30 40] much less than planned CHO 150| results & figure & code|


