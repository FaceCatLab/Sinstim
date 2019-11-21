function cosydemo_display_PerfTest_DrawDots 
% cosydemo_display_PerfTest_DrawDots  <unfinished. todo: Add comments>
%    


%% Init CosyGraphics
lib = 'PTB';
startcosy(lib, 1, [640 480], [.5 .5 .5]);


%% Trial loop
NbOfDots = [10 100 1000 10000 100000];
NbOfTrials = length(NbOfDots);
NbOfFrames = 100;
[w,h] = getscreenres;

for tr = 1 : NbOfTrials
        n = NbOfDots(tr);
        RGB = rand(n,3);
        X = rand(n,1,NbOfFrames) * w - w/2;
        Y = rand(n,1,NbOfFrames) * h - h/2;
        XY = [X Y];
        
        starttrial;
        %--------------------------------- REAL-TIME PART ---------------------------------
        
        message = ['Drawing ' num2str(n) ' dots per frame...'];
        drawtext(message, 0);
        displaybuffer(0, 1500, [num2str(n) ' dots']);
        
        for fr = 1 : NbOfFrames
            draw('rounddots', RGB, 0, XY(:,:,fr), 12);
            displaybuffer(0, oneframe, 'dots');
        end

        stoptrial; %-------------------- END REAL-TIME PART --------------------------------
        waitintertrial(1000);
        
end


%% Stop
stopcosy;
% workspaceexport; % export all function's variables into matlab's workspace. <commented to avoid Matlab "out of memory" error>