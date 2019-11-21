% TEST_DRAW3  Debug program: Test DRAW function, v3.0 (GLab v2-beta37+), for syntax errors.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n = 12;
Lib = 'cog';
isFullScreen = 0;
DispDur = 100;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


sw = 1024;
sh =  768;


b = 0;

RGB = {rand(1,3), rand(n,3)};
XY = {[rand*sw-sw/2 rand*sh-sh/2], [rand(n,1)*sw-sw/2 rand(n,1)*sh-sh/2]};
WH = {50, [60 40], 50*ones(n,1), rand(n,1)*200+1};
penWidth = {1,2,3,20,0};

switch lower(Lib)
    case 'ptb'
        startpsych(isFullScreen, [sw sh], [0 0 0]);
        setcoordsystem cartesian  % <--!!!
    case 'cog'
        startcogent(isFullScreen, [sw sh], [0 0 0]);
end

for iRGB = 1 : length(RGB)
    iRGB
    for iXY = 1 : length(XY)
        iXY, XY{iXY}
        for iWH = 1 : length(WH)
            iWH, WH{iWH}

            %    DRAW(shape,    RGB, b, XY, W|WH          <,penWidth>)
            shape = {'round','polygon3','triangle','cross','square','rect','oval','polygon4','polygon6'};
            for sh = 1 : length(shape)
                draw(shape{sh}, RGB{iRGB}, b, XY{iXY}, WH{iWH}); db(0,DispDur);
                for p = 1 : length(penWidth)
                    draw(shape{sh}, RGB{iRGB}, b, XY{iXY}, WH{iWH}, penWidth{p}); db(0,DispDur);
                    if isabort, sg; return, end
                end
            end

        end
    end
end

stopglab;
