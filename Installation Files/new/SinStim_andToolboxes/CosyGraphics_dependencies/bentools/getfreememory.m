function MB = getfreememory()
% GETFREEMEMORY  Return Matlab's free memory, in megabytes.

rt = java.lang.Runtime.getRuntime;
MB = rt.freeMemory / 1048576;