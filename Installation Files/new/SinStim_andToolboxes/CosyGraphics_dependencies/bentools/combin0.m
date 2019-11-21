function M = combin0(v)
% COMBIN0  Matrix of combinaisons
%
% M = combin0(v)
%
% exemple:
%           
% >> combin0([2 2 3])
%
% ans =
%
%      0     0     0
%      0     0     1
%      0     0     2
%      0     1     0
%      0     1     1
%      0     1     2
%      1     0     0
%      1     0     1
%      1     0     2
%      1     1     0
%      1     1     1
%      1     1     2
     
M = zeros(prod(v),length(v));

for i = 1 : prod(v)
    n = i - 1;
    for j = length(v) : -1 : 1
        r = rem(n,prod(v(j:end)));
        n = n - r;
        if j < length(v)
            r = r / prod(v(j+1:end));
        end
        M(i,j) = r;
    end
end
