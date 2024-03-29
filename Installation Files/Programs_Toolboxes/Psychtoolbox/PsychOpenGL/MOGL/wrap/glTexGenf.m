function glTexGenf( coord, pname, param )

% glTexGenf  Interface to OpenGL function glTexGenf
%
% usage:  glTexGenf( coord, pname, param )
%
% C function:  void glTexGenf(GLenum coord, GLenum pname, GLfloat param)

% 05-Mar-2006 -- created (generated automatically from header files)

if nargin~=3,
    error('invalid number of arguments');
end

moglcore( 'glTexGenf', coord, pname, param );

return
