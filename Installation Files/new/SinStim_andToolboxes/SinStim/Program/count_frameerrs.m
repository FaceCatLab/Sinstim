
% cd M:\MyDocuments\MATLAB\SinStim\Save\Test
d = dir;
fls = d(~[d.isdir]); % 'd' is a var in sinstim
errs = zeros(1,length(fls));

tic

for i_ = 1 : length(fls)
    i_
    load(fls(i_).name,'FrameErr')
    errs(i_) = nansum(FrameErr); 
    if ~rem(i_,10)
        disp(i_)
    end
end

dt = toc

errs10k = [];
for i = 1 : floor(length(errs)/10)
    errs10k(i) = nansum(errs((i-1)*10+1:(i-1)*10+10));
end