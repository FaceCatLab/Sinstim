function Table = calibtextfont(FontName)
% CALIBTEXTFONT  Correspondance table: font size (points) - font heigth (pixels).
%   Table = CALIBTEXTFONT(FontName)
%
% <TODO: Cogent implementation.>

%%%%%%%%%%%%%%%%%%%
MAXSIZE = 100;
%%%%%%%%%%%%%%%%%%%

Table = zeros(100,2);
Table(:,1) = (1:MAXSIZE)';
b = newbuffer([1 600]);

for pts = 1 : MAXSIZE % Loop once for each size in points
    clearbuffer(b, [0 0 0]);
    drawtext('Z', b, [0 0], pts, FontName, [1 1 1]);
    if isptb, M = Screen('GetImage',b);
    else      %<TODO>
    end
    f = find(M(:,1));
    if ~isempty(f)
        Table(pts,2) = max(f)-min(f)+1;
    else
        warning('No white pixels found.')
    end
end

deletebuffer all;
