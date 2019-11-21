% test_copybuffer_perf

cd(whichdir(mfilename));
startpsych(0,800);
I = loadimage('male');
b = storeimage(I);

starttrial;
for x = -300 : 30 : 300
    clearbuffer(0);
    copybuffer(b, 0, [x 0], '-filter', ones(7)/49);
    displaybuffer(0);
end
stoptrial;

stopglab;