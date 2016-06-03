function [] = readBrukerFid();
%% Reads Bruker data from two animal experiment (animal interleaved) into 
%% matlab environment and writes them one after the other

%-------------------------------------------------------------------
%   Paths
%prog_path = pwd;
 
fprintf('Preparing Bruker data...');
 
%%   Read files: method, acqp ...
method = read_metafile('method');
acqp = read_metafile('acqp');
 
%%   Read variables
data_size = read_metafile_variable(acqp,'$ACQ_size=', '%f');
dim = read_metafile_variable(acqp, '$ACQ_dim=', '%f');
bytorda = read_metafile_variable(acqp,'$BYTORDA=', '%s');
NI = read_metafile_variable(acqp, '$NI=', '%f');
NR = read_metafile_variable(acqp, '$NR=', '%f');
 
switch (bytorda)
    case('little')
        bytorda = 'l';
    case('big')
        bytorda = 'b';
end
 
switch dim
    case{1} 
        data_size(2)=1; data_size(3)=1;
    case{2}
        data_size(3)=1;
end

%%   Read raw data
data_length = data_size(1)*data_size(2)*data_size(3)*NI*NR;
fid = fopen('ser','r');
data = fread(fid, (data_length), 'long', bytorda);
fclose(fid);
 
fid = fopen('ser','w');
% Slice 1
data1(1:2:(data_length/2),1) = data(1:4:end,1);
data1(2:2:(data_length/2),1) = data(2:4:end,1);
 
% Slice 2
data1((data_length/2+1):2:(data_length),1) = data(3:4:end,1);
data1((data_length/2+2):2:(data_length),1) = data(4:4:end,1);
 
fwrite(fid, data1, 'long', bytorda);
fclose(fid);
 
%%   Make complex data
data = data(1:2:data_length) + 1i.*data(2:2:data_length);
 
end
 
function [metafile]=read_metafile(data_name)
%%   Reads Bruker metafile
%   IN: metafile name as string (data_name) 
%   OUT: metafile as text (metafile)
 
fid = fopen(data_name,'r');
 
if (fid==-1) 
    'Fehler: fid bei method = -1'
else
    metafile = fread(fid);
    metafile = char(metafile');
    fclose(fid);
end
end
 
function [value]=read_metafile_variable(metafile, variable_name, format)
%%   Reads Bruker metafile variable and returns its value
%   IN: metafile file as text (metafile), name of metafile variable to be returned (variable.name)
%   format of variable value (format)
%   OUT: value of the variable (value) 
      
match = findstr(char(metafile), variable_name);
file_size = max(size(metafile));
variable_row = char(metafile(match:file_size));
x = strtok(variable_row,'##');
 
if findstr(char(x), '(')
    [x, y] = strtok(x, ')');
    y = strrep(y, ')','');
else
    [x, y] = strtok(x, '=');
    y = strtok(strrep(y, '=',''));
end
 
if findstr(char(y), '<')
    [x, y] = strtok(y, '<');
    y = strrep(y, '>', '');
    y = strrep(y, '<', '');
end
 
value = sscanf(y, format);
 
end