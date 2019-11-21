function calibbgrightness(graylevel)
% CALIBBRIGHTNESS  Program for calibration of the screen brightness.
%    CALIBBRIGHTNESS(graylevel)  <TODO: Add doc>
%
% See also GAMA.

if graylevel >= 1
    graylevel = graylevel / 255;
end

startcogent(0, [800 600], [0 0 0]);
keys = getbelgianmap;
numkeys = keys.K1 : keys.K9;

finish = 0;
while ~finish
    xy = rand(1,2) * 400 - 200;
    rgb = graylevel .* [1 1 1];
    
    drawsquare(0, xy, 100, rgb);
    displaybuffer(0);
    
    k = waitkeydown;
    if keys.K1 <= k && k <= keys.K9
        graylevel = find(numkeys == k) / 255;
        graylevel = graylevel(1);
        
    elseif k == keys.Escape
        finish = 1;
        
    end
    
end

stopcogent;