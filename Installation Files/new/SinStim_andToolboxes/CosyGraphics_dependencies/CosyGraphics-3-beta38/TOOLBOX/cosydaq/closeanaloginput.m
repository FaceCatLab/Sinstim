function AI = closeanaloginput(AdaptorName,BoardName,Channels,SampleRate,MaxDurationSec)
% CLOSEANALOGINPUT  Close analogue input.
%    CLOSEANALOGINPUT  closes analog input acquisition initialized by OPENANALOGINPUT.
%
% Ben.J., Oct 2012.

global COSY_DAQ
global AI

if ~isempty(COSY_DAQ.AI.AiObject)
    try
        stop(COSY_DAQ.AI.AiObject);
        delete(COSY_DAQ.AI.AiObject);
        dispinfo(mfilename,'info','Analog input closed.')
    catch
        dispinfo(mfilename,'error',['Failed to close AI object: ' 10 lasterr])
    end
end

try stop(AI), catch end

COSY_DAQ.isAI = false;
COSY_DAQ.AI.AIObject = []; % <TODO: Remove??? AI is already a global object!>
