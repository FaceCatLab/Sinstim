function id = getboardid(AdaptorName,BoardName)
% GETBOARDID  Get acquisition board ID.
%    BoardID = GETBOARDID(AdaptorName)
%    BoardID = GETBOARDID(AdaptorName,BoardName)

if nargin < 2
    BoardName = '';
end

adapt = daqhwinfo(AdaptorName);
nBoards = length(adapt.BoardNames);
if isempty(BoardName)
    if nBoards == 1
        iBoard = 1;
    elseif nBoards == 0 % Error: No board.
        if isopen('display'), stopcosy; end
        line1 = 'Board not plugged!';
        line2 = ['Found no board that you can control with the ''' AdaptorName ''' adaptor.'];
        line3 = 'Please, plug a board, then restart MATLAB!';
        error([line1 10 line2 10 line3]);
    else % Error: More than one board.
        if isopen('display'), stopcosy; end
        error(['More than one ' AdaptorName ' board found. You must provide a board name as input argument.'])
    end
else
    iBoard = strmatch(BoardName,adapt.BoardNames);
end
id = adapt.InstalledBoardIds{iBoard};