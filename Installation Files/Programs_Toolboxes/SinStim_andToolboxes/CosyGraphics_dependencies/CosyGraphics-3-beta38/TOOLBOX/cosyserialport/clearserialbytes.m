function clearserialbytes()
% CLEARSERIALBYTES  Clear serial port's buffer.
%    CLEARSERIALBYTES(port)

if nargin, getserialbytes(port);
else       getserialbytes;
end
