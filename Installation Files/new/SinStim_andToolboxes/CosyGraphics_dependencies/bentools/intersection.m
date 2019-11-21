function I = intersection(varargin)
% I = intersection(a,b,c,...)  Intersection of a, b, c...
%    (Same as Matlab's INTERSECT, but with any number of arguments)

I = varargin{1};
for i = 2 : length(varargin)
    I = intersect(I,varargin{i});
end
    