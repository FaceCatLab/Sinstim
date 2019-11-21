function drawtriangle(varargin)
% DRAWTRIANGLE  Draw triangle(s) in offscreen buffer. {fast}
%    DRAWTRIANGLE(RGB,b,XY,D)  draws an equilateral triangle. XY is a N-by-2 matrix 
%    of coordinates (in pixels), where N is the number of triangles to draw. D is  
%    the diameter of the circle(s) circumscribing the triangle(s). If there are more  
%    than one triangle, D can either  be a scalar (all triangles share the same width)  
%    or a N-by-1 matrix. RGB specifies color (red-green-blue, in the range 0.0 to 1.0).   
%    Similarly to D, if there are more than one triangle, RGB can either be a scalar 
%    or a N-by-3 matrix. 
%
%                  / \
%                /     \
%           <-------o-------> D (= diameter of the circumscribing circle)
%             /    (x,y)  \
%            /_____________\
%                     
%    DRAWTRIANGLE(RGB,b,XY,WH)  draws an isosceles triangle. WH is a 1-by-2 or N-by-2 
%    defining width and height of the triagle.
%
%                  /|\
%                /  |  \
%              /   H|    \
%            /______|______\
%                   W
%
%    DRAWTRIANGLE(RGB,b,XY,D|WH,theta)  rotates the triangle clocwise of theta degrees.
%    'theta' is a 1-by-1 or N-by-1 array.

% Ben, 2009-2011.

error(nargchk(4,5,nargin));
draw('triangle',varargin{:});