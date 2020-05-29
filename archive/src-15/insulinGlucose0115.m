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
                30 30;  % meal duration actual
               160 200; % //meal carbohydrates actual
                50 50;   % meal GI factor actualal pha=1;
                -.1 .1];   % calibration error in CGM monitor

cp_array=[1 1 1 1 1 1 1 1 1 1];


disp(' What would you like to explore ? ')
disp(' 1. G >= 4.5 /\ G <= 9 ' )

disp(' Please select option: ' )
opt = input( 'Please select an option : ')

disp('You selected')
disp(opt)


       
        d = 0.8;
        phi = '[] g_1 /\ [] g_2';
        preds(1).str='g_1'; % G_1>=4.5
        preds(1).A = [-d 0 0];
        preds(1).b = [-4.5 0 0]; 
        preds(2).str ='g_2'; % G_2<=10
        preds(2).A = [1 0 0 ];
        preds(2).b = [9 0 0];

        propName=' (G_1 >= 4.5 /\ G_2 <= 9 ) ';
        fName='Data-01.txt';
        


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
opt.optim_params.n_tests=10;
% opt.taliro = 'dp_taliro';


fid = fopen(fName,'a');
    
    
    for i = 1:opt.runs
     [results, history] = staliro(mdl, init_cond, input_range, cp_array, phi, preds,time,opt);
     [T,~,Y,IT] = SimSimulinkMdl(mdl,init_cond,input_range,cp_array,results.run(results.optRobIndex).bestSample(:,1),time,opt);
    


    figure ;
    title('Run #'+num2str(i));
    subplot(1,2,1);
    plot(T, Y(:,1));
    subplot(1,2,2);
    plot(T, Y(:,2));
         
         
   
   fprintf (fid,' Best input for simulation run # %d\n',i);
   fprintf (fid, ' Robustness: %f, Runtime: %f seconds\n',2 * results.run(results.optRobIndex).bestRob,results.run(results.optRobIndex).time);
   fprintf (fid,' Meal time announced: %f, actual: %f \n', IT(1,2), IT(1,7));
   fprintf (fid,' Meal duration announced: %f, actual: %f \n', IT(1,3), IT(1,8));
   fprintf (fid,' Meal carbohydrate announced: %f, actual: %f \n', IT(1,4), IT(1,9));
   fprintf (fid,' Meal GI announced: %f, actual %f \n', IT(1,5), IT(1,10));
   fprintf (fid,' Calibration Error: %f \n', IT(1,11));
   
   disp ('Best input for simulation run # ')
   disp(i)
   disp('Robustness:')
   disp(2 * results.run(results.optRobIndex).bestRob)
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
