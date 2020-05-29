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

disp(' 1. G_1 >= 4.5 /\ G_2 <= 9 ' )
disp(' 2. G_1 >= 9 /\ G_2 <= 9 ' )




disp(' Please select option: ' )
choice = input( 'Please select an option : ')

disp('You selected')
disp(choice)

if (choice < 1 || choice > 2) 
    disp('Not a legal option!')
    return
end


switch choice


   case 1
        phi = '[] g_1 /\ [] g_2';
        preds(1).str='g_1'; % G_1>=4.5
        preds(1).A = [-1 0 0];
        preds(1).b = -4.5; 
        preds(2).str ='g_2'; % G_2<=9
        preds(2).A = [1 0 0 ];
        preds(2).b = 9 ;

        propName='phi = (G_1 >= 4.5 /\ G_2 <= 9 ) ';
        fName='15.2-case1.txt';
        
   case 2
        phi = '[] g_1 /\ [] g_2';
        preds(1).str='g_1'; % 
        preds(1).A = [-2 0 0];
        preds(1).b = -9 ; 
        preds(2).str ='g_2'; % G_2<=9
        preds(2).A = [1 0 0 ];
        preds(2).b = 9 ;

        propName='phi = (G_1 >= 9 /\ G_2 <= 9 ) ';
        fName='15.2-case2.txt';
        
 
end

        


time = 400;
opt = staliro_options();

nRuns = input('How many runs would you like?');
if (nRuns <= 0)
    nRuns = 1;
end
opt.runs = nRuns;
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
opt.optim_params.n_tests=10; %The total number of tests to be executed
% opt.taliro = 'dp_taliro';


 fid = fopen(fName,'a');
 fprintf (fid,'------------------------------------------------------------------------------------\n');
fprintf (fid, 'file name: %s \n', fName);
fprintf (fid,  'propName: %s \n',propName );

fprintf (fid, '\n preds(1).str: %s \n', preds(1).str);
fprintf (fid, 'preds(1).A:');
fprintf (fid, '[');
fprintf (fid,  '  %d', preds(1).A);
fprintf (fid, ']');
fprintf (fid, '\n preds(1).b: %f \n', preds(1).b);

fprintf (fid, '\n preds(2).str: %s \n', preds(2).str);
fprintf (fid, 'preds(2).A:');
fprintf (fid, '[');
fprintf (fid,  ' %d', preds(2).A);
fprintf (fid, ']');
fprintf (fid, '\n preds(2).b: %f \n', preds(2).b);

fprintf (fid, '\n starting opt runs\n');




    
    
    for i = 1:opt.runs
     [results, history] = staliro(mdl, init_cond, input_range, cp_array, phi, preds,time,opt);
     [T,~,Y,IT] = SimSimulinkMdl(mdl,init_cond,input_range,cp_array,results.run(results.optRobIndex).bestSample(:,1),time,opt);

     
     
fprintf (fid, 'i: %d \n' , i); 
   
fprintf (fid, 'propName: %s \n' , propName); 



   fprintf (fid, ' \n Robustness: %f, Runtime: %f seconds\n', results.run(results.optRobIndex).bestRob,results.run(results.optRobIndex).time);
   fprintf (fid,' \n Meal time announced: %f, actual: %f \n', IT(1,2), IT(1,7));
   fprintf (fid,' Meal duration announced: %f, actual: %f \n', IT(1,3), IT(1,8));
   fprintf (fid,' Meal carbohydrate announced: %f, actual: %f \n', IT(1,4), IT(1,9));
   fprintf (fid,' Meal GI announced: %f, actual %f \n', IT(1,5), IT(1,10));
   fprintf (fid,' Calibration Error: %f \n', IT(1,11));
   fprintf (fid,'------------------------------------------------------------------------------------\n');   

  
    figure ;
    title('Run #'+num2str(i));
    subplot(1,2,1);
    plot(T, Y(:,1));

    
   disp ('Best input for simulation run # ')
   disp(i)
   disp('Robustness:')
   disp(results.run(results.optRobIndex).bestRob)
   disp ('Meal time planned: ')
   disp(IT(1,2))
   disp ('Meal time actual:' )
   disp(IT(1,7))
   disp ('Meal CHO planned:')
   disp(IT(1,4))
   disp ('Meal CHO actual:' )
   disp(IT(1,9))
   disp ('Meal GI planned: ' )
   disp(IT(1,5))
   disp ('Meal GI actual: ' )
   disp(IT(1,10))
   disp ('Calibration Error: ')
   disp(IT(1,11))
   disp ('Correct bolus administered at time')
   disp(IT(1,6))
   
end
fclose(fid);
