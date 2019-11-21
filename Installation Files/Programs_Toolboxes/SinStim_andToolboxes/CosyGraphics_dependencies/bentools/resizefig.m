function resizefig(res)
% resizefig 1152
% resizefig 1280

persistent p

if nargin==0, res = '1152'; end

if strcmp(res,'1152')
	p = get(gcf,'pos');
	p(3:4) = p(3:4) * 1152 / 1280;
end

set(gcf,'pos',p)

figure(gcf)