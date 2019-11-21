function psbarmtargetsync(state)
% PSBARMTARGETSYNC  Set PSB arm target sync on or off. <OBSOLETE>
%    PSBARMTARGETSYNC ON
%    PSBARMTARGETSYNC OFF

switch lower(state)
    case 'on',  setphotodiodevalue(1);
    case 'off', setphotodiodevalue(0);
    otherwise   error('Unknown argument.')
end


% %% Commands
% % cmd1: set end blanking 
% % cmd2: 
% switch lower(state)
%     case 'on'
%         n = int2str(COSY_PSB.nBlankingLines);
%         cmd1 = '!#RB0000x$';  % end red blanking area
%         cmd1(9-length(n):8) = n;
%         
%     case 'off'
%         cmd1 = '!#RB0000x$';  % red blanking area = zero lines => no target sync trigger
%         
%     otherwise 
%         error('Unknown argument.')
% end
% 
% %% Send Commands
% if isfield(COSY_PSB,'COM4')
%     fprintf(COM4,cmd);
% else
%     sendparallelbytes(4,[cmd1 cmd2]);
% end