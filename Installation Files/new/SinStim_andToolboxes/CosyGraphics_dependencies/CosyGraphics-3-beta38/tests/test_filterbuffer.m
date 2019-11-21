function test_filterbuffer
% test_filterbuffer  Test filterbuffer() performancies.


cd(glabroot)
cd tests
F = loadimage('female');
M = loadimage('male');

kernel = fspecial('average',1);

startpsych(1,800);
bf = storeimage(F);
bm = storeimage(M);

bff = filterbuffer(bf,kernel);
bmf = filterbuffer(bm,kernel);
t0 = time;
bff = filterbuffer(bf,kernel);
bmf = filterbuffer(bm,kernel);
bff = filterbuffer(bf,kernel);
bmf = filterbuffer(bm,kernel);
dtFB4 = time-t0


starttrial;

for i = 1 : 100
    switch rem(i,4),
        case 1
            b = bff;
        case 2
            b = bf;
        case 3
            b = bmf;
        case 4
            b = bm;
    end
    
%     copybuffer(b,0);
    copybuffer(b,0,'-filter',kernel);
    displaybuffer(0,getframedur);
end

stoptrial;

stopglab;