function message = checkserial(iPort)
% CHECKSERIAL  Helper function.
%    ERROR(CHECKSERIAL(i))  Error if port #i is not open.

if ~isopen('serialport',iPort)
    istr = num2str(iPort);
    message = ['Serial port #' istr ' (COM' istr ') not open. See OPENSERIALPORT.'];
else
    message = [];
end