function M = isocolormap(n)
% ISOCOLORMAP  Colormap for TRAILMAKINGTEST. Not yet tested!

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
k = .3;  % green & blue level
r = .45; % ration cyan/pink
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if n == 1
    M = [0 k k];
else
    n1 = round(n*r);
    M = k * ones(n,3);
    M(1:n1,1) = linspace(0, .9*k, n1)';
    M(n1+1:end,1) = linspace(1.1*k, 1, n-n1)';
%     M(n/2+1:end,1) = linspace(k+.1*(1-k), 1, n/2)';
end