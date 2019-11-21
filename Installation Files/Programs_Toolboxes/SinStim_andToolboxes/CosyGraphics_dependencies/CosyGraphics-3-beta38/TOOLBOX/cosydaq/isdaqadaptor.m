function b = isdaqadaptor(AdaptorName)
% ISDAQADAPTOR  True for installed data acquisition adaptor with an existing physical board plugged.
%    b = ISDAQADAPTOR(AdaptorName)  returns true if adaptor is installed and if a physical board is
%    plugged.

global COSY_DAQ

if isempty(COSY_DAQ), 
    dispinfo(mfilename,'warning','Daq was not initialized. Lauching OPENDAQ...')
    opendaq; 
end

b = ~isempty(strmatch(AdaptorName,COSY_DAQ.InstalledAdaptors)); % <TODO: as in checkdaqadaptor>
