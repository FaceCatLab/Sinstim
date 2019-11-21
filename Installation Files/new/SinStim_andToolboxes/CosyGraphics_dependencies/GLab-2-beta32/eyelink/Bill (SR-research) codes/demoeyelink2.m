% demoeyelink2
initializedummy=0;
if initializedummy~=1
    if Eyelink('initialize') ~= 0
        fprintf('error in connecting to the eye tracker');
        return;
    end
else
    Eyelink('initializedummy');
end

% STEP 2
% Added a dialog box to set your own EDF file name before opening 
% experiment graphics. Make sure the entered EDF file name is 1 to 8 
% characters in length and only numbers or letters are allowed.
prompt = {'Enter tracker EDF file name (1 to 8 letters or numbers)'};
dlg_title = 'Create EDF file';
num_lines= 1;
def     = {'DEMO'};
answer  = inputdlg(prompt,dlg_title,num_lines,def);
%edfFile= 'DEMO.EDF'
edfFile = answer{1}
   
try
    startpsych(0,800);
%     screenNumber=max(Screen('Screens'));
%     [window, wRect]=Screen('OpenWindow', screenNumber, 0,[],32,2);
%     Screen(window,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    el=EyelinkInitDefaults(gcw);

    % make sure that we get gaze data from the Eyelink
    Eyelink('command', 'link_sample_data = LEFT,RIGHT,GAZE,AREA');

    % open file to record data to
    Eyelink('openfile', 'demo.edf');
    
   % STEP 5    
    % SET UP TRACKER CONFIGURATION
    % Setting the proper recording resolution, proper calibration type, 
    % as well as the data file content;
    width=getscreenres(1);
    height=getscreenres(2);
    Eyelink('command','screen_pixel_coords = %ld %ld %ld %ld', 0, 0, width-1, height-1);
    Eyelink('message', 'DISPLAY_COORDS %ld %ld %ld %ld', 0, 0, width-1, height-1);                
    % set calibration type.
    Eyelink('command', 'calibration_type = HV9');
    % set parser (conservative saccade thresholds)
    Eyelink('command', 'saccade_velocity_threshold = 35');
    Eyelink('command', 'saccade_acceleration_threshold = 9500');
    % set EDF file contents
    Eyelink('command', 'file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON');
    Eyelink('command', 'file_sample_data  = LEFT,RIGHT,GAZE,HREF,AREA,GAZERES,STATUS');
    % set link data (used for gaze cursor)
    Eyelink('command', 'link_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON');
    Eyelink('command', 'link_sample_data  = LEFT,RIGHT,GAZE,GAZERES,AREA,STATUS');
    % allow to use the big button on the eyelink gamepad to accept the 
    % calibration/drift correction target
    Eyelink('command', 'button_function 5 "accept_target_fixation"');
   
    % STEP 4
    % Calibrate the eye tracker
    EyelinkDoTrackerSetup(el);

    % do a final check of calibration using driftcorrection
    EyelinkDoDriftCorrection(el);

    WaitSecs(0.1);    
    Eyelink('StartRecording');
    WaitSecs(0.1); % Eyelink('StartRecording') has a delay of about 15 ms

        eye_used = Eyelink('EyeAvailable'); % get eye that's tracked
    if eye_used == el.BINOCULAR; % if both eyes are tracked
        eye_used = el.LEFT_EYE; % use left eye
    end
    
ImageFile = 'C:\Documents and Settings\All Users\Documents\Mes images\Échantillons d''images\Nénuphars.jpg';
I = loadimage(ImageFile);

bIm = storeimage(I);
bMask = newbuffer;

setpriority OPTIMAL

while 1
        error=Eyelink('CheckRecording');
        if(error~=0)
            break;
        end
        
        % Query  eyetracker") -
        % (mx,my) is our gaze position.
        
        
        if Eyelink( 'NewFloatSampleAvailable') > 0
            % get the sample in the form of an event structure
            evt = Eyelink( 'NewestFloatSample');
%             evt = 
% 
%        time: 2518887
%        type: 200
%       flags: 42881
%          px: [-32768 -32768] pupil x
%          py: [-32768 -32768]
%          hx: [-32768 -32768] head target x
%          hy: [-32768 -32768]
%          pa: [1000 32768] pupil area
%          gx: [398.8000 -32768]  [left right], neg = NA
%          gy: [298.8000 -32768]
%          rx: 21.1000
%          ry: 19
%      status: 0
%       input: 32768
%     buttons: 0
%       htype: 0
%       hdata: [0 0 0 0 0 0 0 0]            
            
            if eye_used ~= -1 % do we know which eye to use yet?
                % if we do, get current gaze position from sample
                x = evt.gx(eye_used+1) - width/2; % +1 as we're accessing MATLAB array
                y = -evt.gy(eye_used+1) + height/2;
                % do we have valid data and is the pupil visible?
                if x~=el.MISSING_DATA & y~=el.MISSING_DATA & evt.pa(eye_used+1)>0

                    mx=x;
                    my=y;
                end
            end
        end
    clearbuffer(bMask,[0 0 0]);
    drawround(bMask,[x y],100,[0 0 0 0]);
%     drawround(bMask,getmouse('R'),100,[0 0 0 0]);
    copybuffer(bIm,0);
%     drawround(0,getmouse('R'),100,[0 0 0]);
    copybuffer(bMask,0);
    displaybuffer(0);
    
    if isabort, 
        break; 
    end 
end
        Eyelink('StopRecording');
    Eyelink('ShutDown');
    
    Screen CloseAll

setpriority NORMAL

catch
    Screen CloseAll
    rethrow(lasterror)
    
end
