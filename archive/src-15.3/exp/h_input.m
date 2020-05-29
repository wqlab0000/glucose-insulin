function [input_range] = h_input(~) % heavy meal input CHO over 150

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


