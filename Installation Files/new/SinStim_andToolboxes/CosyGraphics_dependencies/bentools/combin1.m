function M = combin1(v)
% COMBIN1  Matrix of combinaisons
%
% M = combin1(v)
%
% exemple:
%           
% >> combin1([2 2 3])
%
% ans =
%
%      1     1     1
%      1     1     2
%      1     1     3
%      1     2     1
%      1     2     2
%      1     2     3
%      2     1     1
%      2     1     2
%      2     1     3
%      2     2     1
%      2     2     2
%      2     2     3
%
% >> combin1({[-1 1],[1 0],1:3})
%
% ans =
%
%     -1     1     1
%     -1     1     2
%     -1     1     3
%     -1     0     1
%     -1     0     2
%     -1     0     3
%      1     1     1
%      1     1     2
%      1     1     3
%      1     0     1
%      1     0     2
%      1     0     3
%
% >> combin1({'XY','12','ABC'})
% 
% ans =
% 
% X1A
% X1B
% X1C
% X2A
% X2B
% X2C
% Y1A
% Y1B
% Y1C
% Y2A
% Y2B
% Y2C


if iscell(v)
	values = v;
	v = zeros(size(v));
	for i = 1 : length(v)
		v(i) = length(values{i});
	end
end
     
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

M = M + 1;

if exist('values','var')
	for i = 1 : size(M,1)
		for j = 1 : size(M,2)
			M(i,j) = values{j}(M(i,j));
		end
	end
	if ischar(values{1})
		M = char(M);
	end
end