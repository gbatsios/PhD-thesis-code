%% Code to process the AMARES graphs
% load the data from the txt file, plot the evolution of the metabolites and saves the data to a file with the same name as the txt file
% ability to process more than one files
% extract from txt file: Peak amplitude, peak frequency, residual of AMARES
% quantification
% bottom - code for extracting the data for origin processing/Excel
% database
 
% Date: 20130202
% Revision: 20141017
 
function [] = AMARESPeakProcess();
% Function to process the AMARES peak results
 
[FileName, folder] = uigetfile('*.txt','Select the AMARES peak file','MultiSelect','on');
FileName = strtok(FileName,'.');
 
if not(ischar(FileName))
    for i = 1:length(FileName)
        LocalFileName = char(FileName(i));
        AMARESdataProcess(folder,LocalFileName,1);
    end
else
    AMARESdataProcess(folder,FileName,1);
end
end
 
 
 
function [l] = AMARESdataProcess(folder,FileName,l);

fid = fopen([folder FileName '.txt'],'r');
metafile = fread(fid);
metafile = char(metafile');
fclose(fid);
 
x = dataExtraction(metafile,'Frequencies (ppm)');
[x, y] = strtok(x,'Standard');
PeakFreq = str2num(x);
 
x = dataExtraction(metafile,'Amplitudes (-)');
[x, y] = strtok(x,'Standard');
PeakAmpl = str2num(x);
 
x = dataExtraction(metafile,'Noise :');
[x, y] = strtok(x,'p');
Residual = str2num(x);
 
x = dataExtraction(metafile,'Phases (degrees)');
[x, y] = strtok(x,'Standard');
Phases = str2num(x);
 
 
plotting(PeakAmpl,PeakFreq,FileName,l)
l = l + 1;
 
%% prepare data for Excel & Origin
[OriginMatrix,ExcelValues] = OriginFitPrep(PeakAmpl);
 
%% Save data
save([folder FileName '.mat'], 'PeakAmpl', 'PeakFreq', 'Residual', 'Phases');
save([folder FileName '_OrigExc.mat'], 'OriginMatrix', 'ExcelValues', 'PeakAmpl');
 
clear PeakAmpl PeakFreq Residual x y Phases
end


function [variable_row] = dataExtraction(metafile, variable_Name)
 
match = findstr(char(metafile),variable_Name);
file_size = max(size(metafile));
sizeRowName = max(size(variable_Name));
variable_row = char(metafile((match+sizeRowName):file_size));
 
end



function [] = plotting(PeakAmpl,PeakFreq,FileName,l);
%% Plotting the graphs
 
figure(l)
time = [0:3:(3*(size(PeakAmpl,1)-1))]; 
plot(time,PeakAmpl);
for i = 1:size(PeakAmpl,2)
    a(1,i) = {num2str(PeakFreq(1,i))};
end
 
% add legend with the frequency of the substance to distinguish between the different metabolites
legend(a)
 
xlabel('Time [sec]');
ylabel('Signal');
title(FileName);
 
end
 
