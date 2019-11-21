function T = gettargetdata
% GETTARGETDATA  Get data automatically recorded when DRAWTARGET is used.
%    T = GETTARGETDATA  returns target data in structure T. T is a vector structure;
%    one element per trial, with fields:
%         ... <todo>
%    
% See also: DRAWTARGET.

block = gettrials;

for tr = 1 : length(block)
    nT = block(tr).nTargets;
    nF = block(tr).nFrames;
    iiD = find(block(tr).PERFRAME.isDisplay); % index of frames where display changed
    T(tr).Xpix = zeros(nT,nF)-999;% + NaN;
    T(tr).Ypix = zeros(nT,nF)-999;% + NaN;
    T(tr).Xdeg = [];
    T(tr).Ydeg = [];
    T(tr).TimeStamps = zeros(1,nF)-999;% + NaN;
    T(tr).FrameErrors = zeros(1,nF)-999;% + NaN;
    
    T(tr).TimeStamps(iiD) = block(tr).PERDISPLAY.TimeStamps;
    T(tr).isDisplayChange = block(tr).PERFRAME.isDisplay;
    T(tr).NbFramesToLate(iiD) = block(tr).PERDISPLAY.MissedFramesPerDisplay;
    T(tr).isError = any(T(tr).NbFramesToLate(iiD));
    
    for ta = 1 : nT
        T(tr).Xpix(ta,iiD) = block(tr).PERDISPLAY.TARGETS(ta).XY(:,1)';
        T(tr).Ypix(ta,iiD) = block(tr).PERDISPLAY.TARGETS(ta).XY(:,2)';
        
        f = 1;
        while f < nF
            if block(tr).PERFRAME.isDisplay(f+1) == 0,
                T(tr).Xpix(ta,f+1) = T(tr).Xpix(ta,f);
                T(tr).Ypix(ta,f+1) = T(tr).Ypix(ta,f);
            end
            if isnan(T(tr).TimeStamps(f+1))
                T(tr).TimeStamps(f+1) = T(tr).TimeStamps(f) + oneframe;
            end
            f = f+1;
        end
    end
    
    T(tr).Xdeg = pix2deg(T(tr).Xpix);
    T(tr).Ydeg = pix2deg(T(tr).Ypix);

end
