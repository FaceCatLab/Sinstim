function ax = showrgb(I,Ihsv)
% SHOWRGB  Show red, green and blue planes composing an image.
%    SHOWRGB(I)
%
% Programmer only:
%    ax = SHOWRGB(I,Ihsv)  is used by the SHOWHSV function.
%
% See also: SHOWHSV
% 
% Ben, Sept-Nov. 2007

if nargin == 2, isHSV = 1; % Function has been called by SHOWHSV.
else,           isHSV = 0; % Normal mode.
end

ncols = 256; % Colormap size (bug above 400 and something)
fig = figure;
set(gcf,'units','norm','pos',[.01 .05 .98 .86])
colormap(gray(ncols))

% if size(I,3) == 1 || (all(all((I(:,:,1)) == I(:,:,2))) & all(all((I(:,:,1)) == I(:,:,3)))) % If it's a B&W image
if size(I,3) == 1 % If it's a B&W image	
	M = size(I,1);
	N = size(I,2);
	image(I(:,:,1) * (ncols-1) + 1);
	ax = gca;
	if size(I,3) == 1
		str = [int2str(M) '-by-' int2str(N) '-by-1 black & white image matrix.'];
	else
		str = [int2str(M) '-by-' int2str(N) '-by-3 image matrix. Red, green and blue values are the same.'];
	end
	set(get(gca,'title'),'str',str)
	
else % If it's a color image
	if isHSV, M = Ihsv;% * (ncols-1) + 1;
	else,     M = I;%    * (ncols-1) + 1;
	end
	% Red / H
	ax(1) = subplot(2,2,1);
	if ~isHSV
		subimage(M(:,:,1));
		set(get(gca,'title'),'str','Red','color',[1 0 0])
		set(gca,'xcolor','r','ycolor','r')
	else
% 		X = gray2ind(Ihsv,64); % Convert to indexed image. < UNKNOWN BUG WITH THIS >
% 		f = find(~Ihsv(:,:,2) | ~Ihsv(:,:,3));
		O = ones(size(Ihsv(:,:,2)));
% 		O(f) = NaN; < BUG WITH NANS ?? >
		Ihsv(:,:,2) = O;
		Ihsv(:,:,3) = O;
		subimage(hsv2rgb(Ihsv));
	end
	% Green / S
	ax(2) = subplot(2,2,2);
	subimage(M(:,:,2));
	if ~isHSV
		set(get(gca,'title'),'str','Green','color',[0 1 0])
		set(gca,'xcolor','g','ycolor','g')
	end
	% Blue / V
	ax(3) = subplot(2,2,3);
	subimage(M(:,:,3));
	if ~isHSV
		set(get(gca,'title'),'str','Blue','color',[0 0 1])
		set(gca,'xcolor','b','ycolor','b')
	end
	% True Color
	ax(4) = subplot(2,2,4);
	imshow(I);
	set(get(gca,'title'),'str','True Color')
end
