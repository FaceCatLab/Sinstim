function [start,finish] = globfind(Str,Pattern,SepChar)
% GLOBFIND  Find matches of a pattern. Pattern can contain wildcards ("*" and "?").
%    GLOBFIND(String,Pattern)
%    GLOBFIND(String,SepChar)
%
% See also GLOBCMP.
%
% Ben, 02 Apr. 2008

% \ --> \\
isbackslash = find(Pattern == '\');
for i = isbackslash(end:-1:1)
	bef = i - 1;
	Pattern = [Pattern(1:i-1) '\' Pattern(i:end)];
end

% . --> \.
isdot = find(Pattern == '.');
for i = isdot(end:-1:1)
	bef = i - 1;
	Pattern = [Pattern(1:i-1) '\' Pattern(i:end)];
end

% ? --> .
Pattern(find(Pattern == '?')) = '.';

% * --> [...]*
all = '\\ !"#$%&()\*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ\[\]^_`abcdefghijklmnopqrstuvwxyz{|}~€?‚ƒ„…†‡ˆ‰Š‹Œ???‘’“”•–—˜™š›œ?Ÿ ¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏĞÑÒÓÔÕÖ×ØÙÚÛÜİŞßàáâãäåæçèéêëìíîïğñòóôõö÷øùúûüışÿ';
if exist('SepChar','var')
	for i = 1 : length(SepChar)
		if SepChar ~= '\'
			all(find(all == SepChar(i))) = [];
		else
			all = all(3:end);
		end
	end
end
isstar = find(Pattern == '*');
for i = isstar(end:-1:1)
	bef = i - 1;
	Pattern = [Pattern(1:i-1) '[' all ']' Pattern(i:end)];
end

[start,finish] = regexp(Str,Pattern);