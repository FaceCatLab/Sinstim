function P = setparamstruct(P, varargin)
% SETPARAMSTRUCT  Modify a structure of parameters. Used by SET*PARAMS functions.
%    P = SETPARAMSTRUCT(P,'PropertyName',PropertyValue)  checks if 'PropertyName' corresponds to
%    a field in structure P (the check is case insensitive) and, if yes, updates the property's 
%    value ; if no generates an error.
%
%    P = SETPARAMSTRUCT(P,'PropertyName1',PropertyValue1,'PropertyName2',PropertyValue2,...)
%    sets multiple property values with a single statement. 
%
%    P = SETPARAMSTRUCT(P,p)  where p is a structure whose field names are property names, 
%    sets the properties named in each field name with the values contained in the structure.
%    In clear, p must contains a subset of the fields of P, case inconsistencies being tolerated.
%
%    P = SETPARAMSTRUCT(P,pn,pv)  sets the named properties specified in the cell array of strings 
%    pn to the corresponding values in the cell array pv.

%% Input Args: varargin -> pn, pv
if nargin==3 && iscell(varargin{1}) && iscell(varargin{2})
    pn = varargin{1};
    pv = varargin{2};
    
elseif nargin==1 && isstruct(varargin{1})
    p = varargin{1};
    pn = fieldnames(p);
    pv = cell(size(pn));
    for f = 1:length(pn)
        pv{f} = p.(pn{f});
    end
    
elseif nargin==3 && ischar(varargin{1})
    pn = varargin(1);
    pv = varargin(2);
    
elseif rem(nargin,2)
    for i = 1:nargin-1
        if ~ischar(varargin{i})
            stopfullscreen;
            error('Invalid arguments.')
        end
    end
    pn = varargin(1:2:end);
    pn = varargin(2:2:end);
    
else
    stopfullscreen;
    error('Invalid arguments.')
    
end

%% Update structure P
fields = fieldnames(P);
for f = 1:length(pn)
    matches = strcmpi(fields,pn{f});
    switch sum(matches)
        case 1
            P.(pn{f}) = pv{f};
        case 2
            matches = strcmp(fields,pn{f});
            switch sum(matches)
                case 1
                    P.(pn{f}) = pv{f};
                otherwise
                    stopfullscreen;
                    error(['Ambiguous property name: ''' pn{f} '''. Check case!'])
            end
        case 0
            stopfullscreen;
            error(['Invalid property name: ''' pn{f} ''' is not a field name in the property structure.'])
    end
end
