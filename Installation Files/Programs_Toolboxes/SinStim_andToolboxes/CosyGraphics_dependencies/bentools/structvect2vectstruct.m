
% STRUCTVECT2VECTSTRUCT  Convert scalar structure containing vectors to vector of structures containing scalars.
%    VS = STRUCTVECT2VECTSTRUCT(SV)  
%    VS = STRUCTVECT2VECTSTRUCT(SV,M)

function vs = structvect2vectstruct(varargin)

c = structvect2cell(varargin{:});
vs = cell2vectstruct(c);
