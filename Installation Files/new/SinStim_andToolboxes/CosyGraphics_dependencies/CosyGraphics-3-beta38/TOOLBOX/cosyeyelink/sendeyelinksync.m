function sendeyelinksync
% SENDEYELINKSYNC  Send synchronization signal to EyeLink.
%    This function is used by STARTTRIAL & DISPLAYBUFFER in a transparent way for the user. You don't
%    need to use it directly, except if you don't use STARTTRIAL (not suggested).
%
%    SENDEYELINKSYNC  sends the 'TRIALSYNCTIME' message which will mark the actual trial onset
%    in the data file (.edf). This mark will be used by EYEVIEW to synchronize eye and display signals.

global COSY_GENERAL COSY_TRIALLOG

if checkeyelink('isrecording')
    Eyelink('Message',sprintf('TRIALSYNCTIME #%d',COSY_TRIALLOG.iTrial));
%     if isfield(COSY_GENERAL,'doDispEvents') %<v3-alpha4: Suppr. because of performance issue on AMADEO> <confusion!: dispinfo ~= helper_dispevent!!!>
%         if COSY_GENERAL.doDispEvents
%             str = ['Sent ''TRIALSYNCTIME'' signal to EyeLink PC at ' num2str(time) ' ms'];
%             dispinfo(mfilename,'debuginfo',str)
%         end
%     end
else
    error('Eyelink tracker not recording. See OPENEYELINK and STARTEYELINKRECORD.')
end