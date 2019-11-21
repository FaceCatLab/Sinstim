function opendaq
% OPENDAQ  Initialize data acquisition.
%    You don't need to use this function directly.

global COSY_DAQ

dispinfo(mfilename,'info','Collecting information about installed acquisition devices... This can take several seconds...')
info = daqhwinfo;

str = '...Found installed drivers for the following devices: ';
for i = 1 : length(info.InstalledAdaptors), str = [str info.InstalledAdaptors{i} ', ']; end
str(end-1) = '.';
dispinfo(mfilename,'info',str);

COSY_DAQ.InstalledAdaptors = info.InstalledAdaptors;
