function M = gammaexpand(M,gamma)
% GAMMAEXPAND  Apply gamma correction on a matrix.
%    M = GAMMAEXPAND(M,gamma)
%    C = GAMMAEXPAND(C,gamma)


if iscell(M)    %    M = GAMMAEXPAND(M,gamma)
    for i = 1 : numel(M)
        M{i} = gammaexpand(M{i},gamma);
    end
    
else            %    C = GAMMAEXPAND(C,gamma)
    if max(M(:)) > 1, error('Values out of range (0.0 to 1.0).'), end    
    M = M .^ (1/gamma);
    
end