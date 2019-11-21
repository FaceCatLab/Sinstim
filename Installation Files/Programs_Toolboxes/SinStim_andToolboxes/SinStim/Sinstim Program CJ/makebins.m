function [startbins endbins] = makebins(varargin)
% USAGE:
% [startbins endbins] = makebins(firstbin,lastbin,binsize,'method');
%
% MAKEBINS creates two vectors STARTBINS and ENDBINS that can be used to
% index successive bins with size BINSIZE between two points (FIRSTBIN
% and LASTBIN). If omitted binsize default is 5.
% 
% METHOD (default: 'constant')
% ----------------------------
% 
% 'constant'   The length of each bin matches the length of binsize. 
%              If the lenght of [FIRSTBIN:LASTBIN] is not an integer multiple
%              of BINSIZE, the size of the last bin will be adapted (i.e. shorter than
%              other bins) so as to match the lenght of [FIRSTBIN:LASTBIN].
%
%              Exemple:
%
%              [starbins endbins] = makebins(1,54,10,'constant')
%              starbins =  1    11    21    31    41    51
%              endbins =   10    20    30    40    50    54
%
% 
% 'linear'     The length of each bin is computed so that the space between
%              FIRSTBIN and LASTBIN is (roughly) linear (roughly because integers are
%              MAKEBINS only returns integers). The size of the bins will be as close a
%              match to binsize as to allow linearity.
%
%              Exemple:
% 
%              [starbins endbins] = makebins(1,54,10,'linear')
%              starbins = 1    12    23    33    44
%              endbins = 11    22    32    43    54
% 
% See also: LINSPACE
% 
% Version 1.0 
% Corentin Jacques - Octobre 2010 
% 
if nargin == 0;
    help makebins;
    return;
end

firstbin = varargin{1};
lastbin = varargin{2};

if length(varargin)< 3
    binsize=5;
else
    binsize=varargin{3};
end
if length(varargin)<4
    varargin{4} = 'constant';
end

switch varargin{4};
    case 'constant';
        startbins=firstbin:binsize:lastbin;
        endbins=binsize+firstbin-1:binsize:lastbin;
        if length(startbins)> length(endbins);
            endbins(length(startbins))=lastbin;
        end
    case 'linear';
        startbins = ceil(linspace(firstbin,lastbin,round(lastbin/binsize)+1));
        endbins = startbins-1;
        endbins(1)=[];
        endbins(end)=startbins(end);
        startbins(end)=[];
end
