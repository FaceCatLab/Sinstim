function f = fullfile(varargin)
%FULLFILE Build full filename from parts. <Fixed version of MATLAB standard function.>
%  <MATLAB standard eponymous function pretends "to handle the cases where the directory
%   parts D1, D2, etc. may begin or end in a filesep". It's not true when using "/" on Windows.
%   This fixed version replaces the standard one. --Ben JACOB, 29-09-2010>
%
%   FULLFILE(D1,D2, ... ,FILE) builds a full file name from the
%   directories D1,D2, etc and filename FILE specified.  This is
%   conceptually equivalent to
%
%      F = [D1 filesep D2 filesep ... filesep FILE] 
%
%   except that care is taken to handle the cases where the directory
%   parts D1, D2, etc. may begin or end in a filesep. <fixed for "\", ben 29-09-2010>
%   Specify FILE = '' to build a pathname from parts. 
%
%   Examples
%     To build platform dependent paths to files:
%        fullfile(matlabroot,'toolbox','matlab','general','Contents.m')
%
%     To build platform dependent paths to a directory:
%        addpath(fullfile(matlabroot,'toolbox','matlab',''))
%
%   See also FILESEP, PATHSEP, FILEPARTS.

% error(nargchk(2, Inf, nargin, 'struct'));

fs = '/'; % <ben>
f = varargin{1};
f(f=='\') = '/'; % <ben>
bIsPC = ispc;

for i=2:nargin,
   part = varargin{i};
   if isempty(f) | isempty(part)
      f = [f part];
   else
      part(part=='\') = '/'; % <ben>
      % Handle the three possible cases
      if (f(end)==fs) & (part(1)==fs),
         f = [f part(2:end)];
      elseif (f(end)==fs) | (part(1)==fs | (bIsPC & (f(end)=='/' | part(1)=='/')) )
         f = [f part];
      else
         f = [f fs part];
      end
   end
end

% Be robust to / or \ on PC
if bIsPC
   f = strrep(f,'/','\');
end



