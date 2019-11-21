function b = isfieldtrue(s,field)
% ISFIELDTRUE  True if field is in structure array and contains a "true value".
%    ISFIELDTRUE(S,FIELD)  returns true if the string FIELD is the name of a
%    field in the structure array S and if that that field contains any non-zero,
%    non-NaN value.
%
% Ben,  July 2010.

b = false;

if isfield(s,field)
    if ~isempty(s.(field)) 
        if ~isnan(s.(field))
            if s.(field)
                b = true;
            end
        end
    end
end
