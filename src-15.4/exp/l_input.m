function [input_range] = l_input(~) % heavy meal input CHO under 150

input_range = [40 40;   % meal time planned
               30  30;  % meal duration planned
               150 150; % meal CHO planned
                50 50;   % meal GI factor announced
               150 250; % time for correction bolus administration
                40 40;   % meal time actual
                30 30;  % meal duration actual
               70 140; % //meal CHO actual
                50 50;   % meal GI factoractual
                -.1 .1];   % calibration error in CGM monitor


