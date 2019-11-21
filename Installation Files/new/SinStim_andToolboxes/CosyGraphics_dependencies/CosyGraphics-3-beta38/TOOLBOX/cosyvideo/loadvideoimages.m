function [images,fps,info] = loadvideoimages(avifile)
% LOADVIDEOIMAGES  <unfinished> <TODO>
%    [images,fps,info] = LOADVIDEOIMAGES(avifile)


info = aviinfo(avifile);
fps  = info.FramesPerSecond;
mov  = aviread(avifile);

images = cell(size(mov));
for i = 1 : length(images)
    images{i} = mov(i).cdata;
end