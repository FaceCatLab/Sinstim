function sendeyelinksync
% SENDEYELINKSYNC  Send synchronization signal to EyeLink.
%    SENDEYELINKSYNC  sends the 'TRIALSYNCTIME' message which will mark the actual trial onset in
%    the data file (.edf). This mark will be used by EYEVIEW to synchronize eye and display signals.

global GLAB_DEBUG

if checkeyelink('isrecording')
    Eyelink('Message','TRIALSYNCTIME');
    if isfield(GLAB_DEBUG,'doDispTimes')
        if GLAB_DEBUG.doDispTimes
            str = ['Sent ''TRIALSYNCTIME'' signal to EyeLink PC at ' num2str(time) ' ms'];
            dispinfo(mfilename,'debuginfo',str)
        end
    end
else
    error('Eyelink tracker not recording. See OPENEYELINK and STARTEYELINKRECORD.')
end