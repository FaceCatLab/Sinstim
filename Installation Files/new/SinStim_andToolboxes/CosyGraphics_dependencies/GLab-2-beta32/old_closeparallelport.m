function closeparallelport(PortNum)
% CLOSEPARALLELPORT  Close parallel port.
%    CLOSEPARALLELPORT  closes all open parallel ports.
%
%    CLOSEPARALLELPORT(n)  closes LPTn.
%
% Ben, Nov. 2007 v1.0

%      Jan. 2008 Suppress unusefull output arg.
%      Feb. 2009 v2.0 Rewrite.

global GLAB_PARALLELPORT

if isempty(GLAB_PARALLELPORT)
    return % !!!
end

if ~exist('PortNum','var')   %    CLOSEPARALLELPORT
    iPorts = 1 : length(GLAB_PARALLELPORT.PortNum);
else                         %    CLOSEPARALLELPORT(n)
    iPorts = find(GLAB_PARALLELPORT.PortNum == PortNum);
end

for i = iPorts
    stop(GLAB_PARALLELPORT.PortObject{i})
	delete(GLAB_PARALLELPORT.PortObject{i})
    GLAB_PARALLELPORT.PortNum(i) = [];
    GLAB_PARALLELPORT.PortObject(i) = [];
end

if isempty(GLAB_PARALLELPORT.PortNum)
    GLAB_PARALLELPORT = [];
end