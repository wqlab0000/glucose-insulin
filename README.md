# glucose-insulin


Install matlab (tested with matlab R2019a)

Install S-taliro from https://sites.google.com/a/asu.edu/s-taliro/s-taliro

Save the files in insulinGlucoseHumanCtrlRisk benchmark.

Toolboxes required for running the Robust Testing Toolbox:
\begin{itemize}
	\item Multi Parametric Toolbox (http://control.ee.ethz.ch/~mpt/)
	   Tested version 3.0
	\item Ellipsoidal Toolbox (http://code.google.com/p/ellipsoids/)
	   Tested version 1.1.2
	\item CVX: Disciplined Convex Optimization (http://cvxr.com/cvx/)
	   Tested version 1.21
  \item MatlabBGL: for the hybrid distance metric with distances to the location guards
  : http://www.mathworks.com/matlabcentral/fileexchange/10922
\end{itemize}

To setup S-TaLiRo run the following in the Matlab command window:
>> setup_staliro
