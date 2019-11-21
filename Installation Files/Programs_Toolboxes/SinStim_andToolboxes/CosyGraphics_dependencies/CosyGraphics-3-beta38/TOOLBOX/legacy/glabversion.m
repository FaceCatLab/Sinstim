function varargout = glabversion(varargin)
% GLABVERSION  <Obsolete - Replaced by cosyversion.>

[v,vstr] = cosyversion(varargin{:});
varargout = {v,vstr};