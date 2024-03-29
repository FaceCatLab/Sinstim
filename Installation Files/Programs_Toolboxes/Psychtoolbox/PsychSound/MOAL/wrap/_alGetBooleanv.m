function data = alGetBooleanv( param )

% alGetBooleanv  Interface to OpenAL function alGetBooleanv
%
% usage:  data = alGetBooleanv( param )
%
% C function:  void alGetBooleanv(ALenum param, ALboolean* data)

% 06-Feb-2007 -- created (generated automatically from header files)

% ---allocate---

if nargin~=1,
    error('invalid number of arguments');
end

data = uint8(0);

moalcore( 'alGetBooleanv', param, data );

return
