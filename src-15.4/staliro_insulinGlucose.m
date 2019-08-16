clear 
mdl = 'insulinGlucose';
cp_array=[1 1 1 1 1 1 1 1 1 1];

init_cond = [];

type file_name.txt;

x = input('\n Input a file name you want to explore \n','s')

input_range = importdata(x); %import input_range data from text file
b = reshape(input_range, 10, 2);
disp(b)


disp(' What would you like to explore ? ')

disp(' 1. G >= 4.5 ' )
disp(' 2. G <= 9 ' )
disp(' 3. G >= 4.5 /\ G <= 9 ' )
disp(' 4. 2G >= 9 /\ G <= 9 ' )

disp(' Please select option: ' )
choice = input( 'Please select an option : ')

disp('You selected')
disp(choice)

if (choice < 1 || choice > 4) 
    disp('Not a legal option!')
    return
end


switch choice
    
   case 1
        phi = '[] g_1';
        
        preds(1).str='g_1'; % G>=4.5
        preds(1).A = [-1 0 0];
        preds(1).b = -4.5; 
        
        propName='phi = (G >= 4.5) ';
        fName='15.4-case1.txt';
        
   case 2
        phi = '[] g_2';
       
        preds(1).str ='g_2'; % G<=9
        preds(1).A = [1 0 0 ];
        preds(1).b = 9 ;

        propName='phi = (G <= 9 ) ';
        fName='15.4-case2.txt';

   case 3
        phi = '[] g_1 /\ [] g_2';
        preds(1).str='g_1'; % G>=4.5
        preds(1).A = [-1 0 0];
        preds(1).b = -4.5; 
        preds(2).str ='g_2'; % G<=9
        preds(2).A = [1 0 0 ];
        preds(2).b = 9 ;

        propName='phi = (G >= 4.5 /\ G <= 9 ) ';
        fName='15.4-case3.txt';
        
   case 4
        phi = '[] g_1 /\ [] g_2';
        preds(1).str='g_1'; % 2G >= 9
        preds(1).A = [-2 0 0];
        preds(1).b = -9 ; 
        preds(2).str ='g_2'; % G<=9
        preds(2).A = [1 0 0 ];
        preds(2).b = 9 ;

        propName='phi = (2G >= 9 /\ G <= 9 ) ';
        fName='15.4-case4.txt';
        
        
 
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

opt.optim_params.n_tests=10; %The total number of tests to be executed
% opt.taliro = 'dp_taliro';



mkdir 15.4 % create a result folder and save output file in result folder
savePath = '/path/to/15.4/'; 
fid = fopen([savePath fName],'at'); 
result =[fName '\t'];

fprintf (fid,'------------------------------------------------------------------------------------\n');
fprintf (fid, 'file name: %s \n', fName);

    
    for i = 1:opt.runs
     [results, history] = staliro(mdl, init_cond, input_range, cp_array, phi, preds,time,opt);
     [T,~,Y,IT] = SimSimulinkMdl(mdl,init_cond,input_range,cp_array,results.run(results.optRobIndex).bestSample(:,1),time,opt);

   
   
    rob = results.run(results.optRobIndex).bestRob; % robustness value
    
    [min_Y, index]= min(Y,[],1) %find the lowest glucose level
    minG = min_Y(1,1)
    minIndex = index(1,1) % lowest glucose corresponding index
    minT = T(minIndex,1)  % lowest glucose corresponding time
        
    
    if  minG < 4.5 && minG >=2.5   % lowest glucose level is [2.5 4.5]--dangerous
       rob = rob * 2;  % we scale the robustness to twice larger than the original robustness
    elseif minG < 2.5  % glucose level is within [0, 2.5)-- extremely dangerous
       rob = -9999;    % robustness is set to negative infinity, here we set to -9999                   
    else rob = rob;    % otherwise robustness keep the original value
    end

 
     
     
   fprintf (fid, '\n Input file name: %s \n', x);
   fprintf (fid, '%f %f \n', b(1, :)); 
   fprintf (fid, '%f %f \n', b(2, :));
   fprintf (fid, '%f %f \n', b(3, :)); 
   fprintf (fid, '%f %f \n', b(4, :)); 
   fprintf (fid, '%f %f \n', b(5, :)); 
   fprintf (fid, '%f %f \n', b(6, :)); 
   fprintf (fid, '%f %f \n', b(7, :)); 
   fprintf (fid, '%f %f \n', b(8, :));
   fprintf (fid, '%f %f \n', b(9, :)); 
   fprintf (fid, '%f %f \n', b(10, :)); 
   
     
   
     
   fprintf (fid, '\n i: %d \n' , i); 
   fprintf (fid, 'propName: %s \n' , propName); 
   
   fprintf (fid,'\n Meal CHO planned: %f, actual: %f \n', IT(1,4), IT(1,9));
   fprintf (fid,'\n Lowest Glucose level: %f, Time: %f \n', minG, minT); 

   fprintf (fid, ' \n Scaled-Robustness: %f', rob);
   fprintf (fid, ' \n Robustness: %f, Runtime: %f seconds\n', results.run(results.optRobIndex).bestRob,results.run(results.optRobIndex).time);
   fprintf (fid,' \n Meal time planned: %f, actual: %f \n', IT(1,2), IT(1,7));
   fprintf (fid,' Meal duration planned: %f, actual: %f \n', IT(1,3), IT(1,8));
   fprintf (fid,' Meal GI planned: %f, actual %f \n', IT(1,5), IT(1,10));
   fprintf (fid,' Calibration Error: %f \n', IT(1,11));
   fprintf (fid,'------------------------------------------------------------------------------------\n');   

   
   
   
    figure ;
    subplot(1,2,1);
    plot(T, Y(:,1));



    
   disp ('Best input for simulation run # ')
   disp(i)
   disp('Robustness:')
   disp(results.run(results.optRobIndex).bestRob)
   disp('Scaled- Robustness:')
   disp(rob)
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
