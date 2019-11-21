function dirpath = documentsdir
% USERDIR  User directory.


if ispc % Windows
    [s,msg] = dos('CSIDL_DEFAULT_MYDOCUMENTS');
    f = strfind(msg,'''"');
    dirpath = msg(2:f-1);
    
else % UNIX
    
    
end
