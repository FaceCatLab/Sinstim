function settrailproperties(varargin)
% SETTRAILPROPERTIES  Set properties for TRAILMAKINGTEST.
%    <TODO: Write doc. In the meanwhile, read "help setpropstruct" to have an idea (just ommit the "P" arg.)>

global TRAINMAKING

if isempty(TRAINMAKING), gettrailproperties; end

TRAINMAKING = setpropstruct(TRAINMAKING, varargin{:});
