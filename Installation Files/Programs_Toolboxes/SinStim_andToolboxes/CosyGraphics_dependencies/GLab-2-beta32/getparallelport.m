function [dio,s] = getparallelport(PortNum)
% GETPARALLELPORT  Get parallel port digitalio object.
%    GETPARALLELPORT  displays infos on all open // port.
%
%    DIO = GETPARALLELPORT  returns the digitalio object (see DAQ toolbox documentation) of port
%    open with OPENPARALLELPORT. (If there is more than one, selects last open port.)
%
%    DIO = GETPARALLELPORT(n)  selects LPTn.
%
%    [DIO,S] = GETPARALLELPORT(...)  returns object's properties in structure S. Same as S=get(DIO); 
%   
%    Programmer note: Don't use GETPARALLELPORT syntax inside a function. Use GETPARALLELPORT(n) to
%    avoid unsusefull displays.

global GLAB_PARALLELPORT

dio = [];
s = [];

if ~isempty(GLAB_PARALLELPORT) % If // port open..
    
    if ~nargin, PortNum = GLAB_PARALLELPORT.PortNum(end); end  % Default= last open port.

    iPort = find(GLAB_PARALLELPORT.PortNum == PortNum);
    
    if length(iPort) > 1 && ~nargout
        for n = GLAB_PARALLELPORT.PortNum(1:end-1)
            getparallelport(n)
        end

    elseif iPort % If requested // port open..
        dio = GLAB_PARALLELPORT.PortObject{iPort};
        s = get(dio);
    end

end

if ~nargin && ~nargout % Command line use
    PortName = ['LPT' int2str(PortNum)];
    disp([10 PortName ':' 10])
    disp(s)
end