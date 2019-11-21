function test_soundlatencyclass(reallyneedlowlatency,classes)
% TEST_SOUNDLATENCYCLASS  Test PTB's sound latency classes.
%    TEST_SOUNDLATENCYCLASS(reallyneedlowlatency,classes)
%
% Ben, Jan 2011.


%% Input Arg.
if ~nargin
    reallyneedlowlatency = 0:1;
    classes = 1:4;
end


%% Get sound
load handel % -> y, Fs
y = y(1:19000)'; % first hallelujah


%% Test
for r = reallyneedlowlatency
    disp(' ')
    sprintf('reallyneedlowlatency = %d  ===================================================', r)
    disp(' ')
    
    InitializePsychSound(r)
    
    for c = classes
        sprintf('reallyneedlowlatency = %d.  Latency class = %d  ---------------', r, c)
        switch c
            case 0
                disp(' Level 0 means: Don''t care about latency, this mode')
                disp(' works always and with all settings, plays nicely with other sound applications.')
            case 1
                disp(' Level 1 (the default) means: Try to get the lowest latency that is possible')
                disp(' under the constraint of reliable playback, freedom of choice for all parameters')
                disp(' and interoperability with other applications.')
            case 2
                disp(' Level 2 means: Take full control over the audio device, even if this')
                disp(' causes other sound applications to fail or shutdown.')
            case 3
                disp(' Level 3 means: As level 2, but request the most aggressive settings for the given device.')
            case 4
                disp(' Level 4: Same as 3, but fail if device can''t meet the strictest requirements.')
        end
        disp(' ')
        
        wait(2000)

        h = PsychPortAudio('Open', [], [], c, Fs, 1);
        PsychPortAudio('FillBuffer',h, y);
        PsychPortAudio('Start',h);
        wait(4000);
        PsychPortAudio('Stop',h);
        wait(3000);
    
    end
    
end

closesound;
disp('Done.')