clear 
mdl = 'insulinGlucose';


load_system(mdl);
warning off all
init_cond = [];
input_range = [40 40;   % meal time announced
               30  30;  % meal duration announced
               150 150; % meal carbohydrates
                50 50;   % meal GI factor announced
               150 250; % time for correction bolus administration
                40 40;   % meal time actual
                20 40;  % meal duration actual
               100 200; % meal carbohydrates actual
                50 50;   % meal GI factor actualal pha=1;
                -.1 .1];   % calibration error in CGM monitor

cp_array=[1 1 1 1 1 1 1 1 1 1];


disp(' What would you like to explore ? ')
% disp(' 1. Hypoglycemia  <> G < 4.0 ' )
% disp(' 2. Significant hypoglycemia <> G < 2.5 ')
% disp(' 3. post-prandial hyperglycemia <> G > 7.0 ')
% disp(' 4. Significant post-prandial hyperglycemia <> G > 17.0 ')
% disp(' 1. G >= 4 /\ G <= 17 after time 200 ' )
disp(' 1. G >= 4 /\ G <= 10 ' )
disp(' 2. G >= 2.5 /\ G <= 17 after time 200 ')
disp(' 3. G <= 17 /\ G <= 7 after time 200 ')
disp(' 4. G <= 17 /\ G <= 7 in time [60,200] ')
% disp(' 5. i >= 6.5 \/ G <= 25 after time 200 ')
% disp(' 6. i >= 1.8 \/ G <= 12 after time 200 ')
% disp(' 7. i <= 1.4 \/ G >= 3 after time 200 ')


disp(' Please select option: ' )
opt = input( 'Please select an option : ')

disp('You selected')
disp(opt)

if (opt < 1 || opt > 4) 
    disp('Not a legal option!')
    return
end


switch opt
%     case 1
%         phi = '[] a /\ [] b';
%         preds(1).str='a';
%         preds(1).A = [-1 0 0];
%         preds(1).b = [-4 0 0]; 
%         preds(2).str = 'b';
%         preds(2).A = [1 0 0 ];
%         preds(2).b = [17 0 0 ]
% 
%         propName=' (G >= 4 /\ G <= 17 after time 200 ) ';
%         fName='runData-p1.txt';
%         
        
   case 1
        phi = '[] a /\ [] b';
        preds(1).str='a'; % G_1>=4.5
        preds(1).A = [-1 0 0];
        preds(1).b = [-4.5 0 0]; 
        preds(2).str ='b'; % G_2<=10
        preds(2).A = [1 0 0 ];
        preds(2).b = [9 0 0];

        propName=' (G_1 >= 4.5 /\ G_2 <= 10 ) ';
        fName='Data-01.txt';
        
    case 2
        phi = '[] a  /\ []_[200,400] b';
        preds(1).str='a';
        preds(1).A = [-1 0 0 ];
        preds(1).b = [-2.5 0 0 ];
        preds(2).str = 'b';
        preds(2).A = [1 0 0 ];
        preds(2).b = [17 0 0 ];
        
        propName=' (G >= 2.5 /\ G <= 17 after time 200) ';
        fName = 'Data-02.txt'
    case 3
        phi = '[] a /\ []_[200,400] b';
        preds(1).str = 'a';
        preds(1).A = [1 0 0 ];
        preds(1).b = [17 0 0 ];
        preds(2).str = 'b';
        preds(2).A = [1 0 0 ];
        preds(2).b = [7 0 0 ];
        propName=' (G <= 17 /\ G <= 7 after time 200 ) ';
        fName = 'Data-03.txt';
    case 4
        phi = '[] a  /\ []_[60,200] b';
        preds(1).str='a';
        preds(1).A = [1 0 0 ];
        preds(1).b = [17 0 0 ];
        preds(2).str = 'b';
        preds(2).A = [1 0 0 ];
        preds(2).b = [7 0 0 ];
        propName=' ( G <= 17 /\ G <= 7 in time [60,200]  ) ';
        fName = 'Data-04.txt';
        
%     case 5
%         phi = '[] a \/ []_[200,400] b';
%         preds(1).str='a';
%         preds(1).A = [1 0 0];
%         preds(1).b = [18 0 0]; 
%         preds(2).str = 'b';
%         preds(2).A = [1 0 0 ];
%         preds(2).b = [25 0 0 ]
% 
%         propName='Hypoglycemia (i >= 6.5 \/ G <= 25 after time 200 ) ';
%         fName='runData-p5.txt';
%         
%     case 6
%         phi = '[] a \/ []_[200,400] b';
%         preds(1).str='a';
%         preds(1).A = [1 0 0];
%         preds(1).b = [5 0 0]; 
%         preds(2).str = 'b';
%         preds(2).A = [1 0 0 ];
%         preds(2).b = [12 0 0 ]
% 
%         propName='Hypoglycemia (i >= 1.8 \/ G <= 12 after time 200 ) ';
%         fName='runData-p6.txt';
%     
%     case 7
%         phi = '[] a \/ []_[200,400] b';
%         preds(1).str='a';
%         preds(1).A = [-1 0 0];
%         preds(1).b = [-4 0 0]; 
%         preds(2).str = 'b';
%         preds(2).A = [-1 0 0 ];
%         preds(2).b = [-3 0 0 ]
% 
%         propName='Hypoglycemia (i <= 1.4 \/ G >= 3 after time 200 ) ';
%         fName='runData-p7.txt';
%              
end

time = 400;
opt = staliro_options();

nRuns = input('How many runs would you like?');
if (nRuns <= 0)
    nRuns = 1;
end
opt.runs = 1;
disp('I am testing for property')
disp(propName)

opt.falsification=0;
opt.spec_space='Y';
opt.interpolationtype={'const'};
opt;

opt.optimization_solver = 'SA_Taliro';
% opt.optimization_solver = 'MS_Taliro';
% opt.optimization_solver = 'UR_Taliro';

% opt.optim_params.n_tests=1000;
opt.optim_params.n_tests=100;
% opt.taliro = 'dp_taliro';


fid = fopen(fName,'a');
    
    
    for i = 1:opt.runs
     [results, history] = staliro(mdl, init_cond, input_range, cp_array, phi, preds,time,opt);
     [T,~,Y,IT] = SimSimulinkMdl(mdl,init_cond,input_range,cp_array,results.run(results.optRobIndex).bestSample(:,1),time,opt);
    
%     [robustnessValues,nrTests,posteriorMean,confidenceInterval] = bayesianSMC(mdl,phi,preds,delta,c,alpha,beta)


    figure ;
    title('Run #'+num2str(i));
    subplot(1,3,1);
    plot(T , Y(:,1) );
    subplot(1,3,2);
    plot(T, Y(:,2));
    subplot(1,3,3);
    plot(T, Y(:,3));
         
   
   fprintf (fid,' Best input for simulation run # %d\n',i);
   fprintf (fid, ' Robustness: %f, Runtime: %f seconds\n', results.run(results.optRobIndex).bestRob,results.run(results.optRobIndex).time);
   fprintf (fid,' Meal time announced: %f, actual: %f \n', IT(1,2), IT(1,7));
   fprintf (fid,' Meal duration announced: %f, actual: %f \n', IT(1,3), IT(1,8));
   fprintf (fid,' Meal carbohydrate announced: %f, actual: %f \n', IT(1,4), IT(1,9));
   fprintf (fid,' Meal GI announced: %f, actual %f \n', IT(1,5), IT(1,10));
   fprintf (fid,' Calibration Error: %f \n', IT(1,11));
   
   disp ('Best input for simulation run # ')
   disp(i)
   disp('Robustness:')
   disp(results.run(results.optRobIndex).bestRob)
   disp ('Meal time announced: ')
   disp(IT(1,2))
   disp ('Meal time actual:' )
   disp(IT(1,7))
   disp ('Meal carbohydrate announced:')
   disp(IT(1,4))
   disp ('Meal carbohydrate actual:' )
   disp(IT(1,9))
   disp ('Meal GI announced: ' )
   disp(IT(1,5))
   disp ('Meal GI actual: ' )
   disp(IT(1,10))
   disp ('Calibration Error: ')
   disp(IT(1,11))
   disp ('Correct bolus administered at time')
   disp(IT(1,6))
   
end
fclose(fid);
