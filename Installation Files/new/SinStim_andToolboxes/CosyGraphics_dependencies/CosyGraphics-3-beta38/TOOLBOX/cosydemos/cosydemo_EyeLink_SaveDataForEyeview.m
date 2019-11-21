% cosydemo_EyeLink_SaveDataForEyeview  Data export to Eyeview 0.25. <todo: untested>


% function cosydemo_EyeLink_SaveDataForEyeview


%% Init CosyGraphics
startcosy('PTB', 0, [640 480], [.5 .5 .5]);  % (note that startcogent(...) does the same than startcosy('Cog',...) )
openeyelink; % <TODO: add comments...>


%% Trial loop
NbOfTrials = 2;

x0 = -200;
x1 = 200;
y = 0;

for tr = 1 : NbOfTrials
    starttrial; 
    
    % Fixation:
    drawtarget(1,'round',[1 0 0], 0, [x0 y], 12);
    displaybuffer(0, 700, 'fix');
    
    % Rampe:
    for i = 1 : 100
        x = x0 + (x1-x0) * i/100;
        
        % Draw target:
        drawtarget(1, 'round', [1 0 0], 0, [x y], 12); % drawtarget: 1) draws the target and 2) logs it's position.

        % Draw eye (for demo):
        draw('round', [0 1 1], 0, geteye, 6);
        
        displaybuffer(0, oneframe, 'rampe');
    end
    
    % Blank screen:
    displaybuffer(0, 500, 'blank');
    
    % Stop trial: 
    stoptrial;
    waitintertrial(1000);
end


%% Stop
stopcosy;
workspaceexport; %export all variable in the workspace.

%% Save!
savetrials4eyeview('gui');  % Save variables in EyeView's format.