function varargout = dealvect(varargin)
% DEALVECT  Deal elements of a vector.
%    DEALVECT(V)  is the same than DEAL(V(1),V(2),...,V(end)).  See DEAL.
%
% Ben, Aug. 2009

% Check input & output
error(nargchk(1,1,nargin,'struct'))
if nargout ~= nargin
    error('MATLAB:deal:narginNargoutMismatch',...
        'The number of outputs should match the number of inputs.')
end

% Deal vector's elements
vect = varargin{1};
varargout = num2cell(vect(:)');