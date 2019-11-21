function sendtrials2eyeview
% SENDTRIALS2EYEVIEW  Open CosyGraphics trials in Eyeview. <UNFINISHED>
%    SENDTRIALS2EYEVIEW  if Eyeview is present, opens last file saved by SAVETRIALS4EYEVIEW with
%    Eyeview.


global COSY_FUNCTIONS % CosyGraphics var
global USER % Eyeview var

try GdfFileName = COSY_FUNCTIONS.savetrials4eyeview.GdfFileName;
catch 
    beep
    warning('No file recorded. Use savetrials4eyeview first.')
    return % <===!!!
end

if exist('starteyeview') == 2
    if ~isstruct(USER)
        starteyeview glab
    end
    
    EdfFileName
    
    evMain(
    
    
    
    
else
    beep
    warning('Cannot find Eyeview.')
    
end
