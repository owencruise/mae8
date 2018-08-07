function [Xo, Yo, Zo, Uo, Vo, Wo, tstart, tend, maxthrust] = ...
    read_input(inputfile, sat_id)
% READ_INPUT retrieves data stored in the file corresponding to the
% 'inputfile' argument and the specified satellite ID and outputs the
% satellite's initial xyz-position in meters, initial xyz-velocity
% in meters per second, the starting and ending time of the satellite 
% engines' firing in seconds, and the maximum thrust produced in Newtons.

sats = importdata(inputfile, '\t', 3);
% Importing from file specified in inputfile string
% Delimiter: tab (escape sequence '\t')
% Three header lines at the top of the text file

numrows = size(sats.data, 1); %Number of rows in cell array 'sats'

if sat_id > 0 && sat_id <= numrows
    Xo = sats.data(sat_id, 2); %Initial x position
    Yo = sats.data(sat_id, 3); %Initial y position
    Zo = sats.data(sat_id, 4); %Initial z position
    
    Uo = sats.data(sat_id, 5); %Initial x velocity
    Vo = sats.data(sat_id, 6); %Initial y velocity
    Wo = sats.data(sat_id, 7); %Initial z velocity
    
    tstart    = sats.data(sat_id,  8); %Thrust start time
    tend      = sats.data(sat_id,  9); %Thrust end time
    maxthrust = sats.data(sat_id, 10); %Max value of thrust
    
else %sat_id is not contained within input_file
    [Xo, Yo, Zo, Uo, Vo, Wo, tstart, tend, maxthrust] = deal(NaN);
    errordlg('Invalid satellite ID'); %Error dialog
end

end
