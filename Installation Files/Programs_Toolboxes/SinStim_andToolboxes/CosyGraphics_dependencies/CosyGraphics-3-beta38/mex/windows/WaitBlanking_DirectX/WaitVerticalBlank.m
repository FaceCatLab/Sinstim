% Wait for the next video card Vertical Blanking.  
% Arguments are not case-sensitive.
% Arguments :
%
% 'INIT'		->  Load the dll and initiliase the directx device
%					second Argument : directory where the dll file is.
%				    Return value : no return value
% 'UNINIT'		->  Unload the dll and uninitialise the directx device
%				    Return value : no return value
% 'RESET'		->  Reset the directx device in case an error occured during
%                   a wait blanking call or when the screen changes to
%				    fullscreen or windowed screen and vice-versa.
%				    Return value : no return value
% 'ISINIT'		->  Tell wether the device and dll are initialised.
%				    Return value :
%                   1 -> (true) 
%                   0 -> (false)      
% 'WAIT'		->  Wait the next Vertical Blank 
%					return value :
%					0   -> means the device is not initialise and the wait cannot be call. 
%					1   -> means was OK. 
%					-1  -> means the device was lost and the wait could not be
%                          done. The function returned without waiting the vertical blank. 
%					-2  -> means the device recovered from a lost state but it was not reset after. 
%                          The function has reset it itself and has waited the next vertical blank. 
%                          You could have lost or not some vertical blank(s) during resetting the device.
% 'LASTERROR'   ->	Get the last error message that a function call could produced.
%                   Return value : message
% 'LASTINFO'    ->  Get the last information that a function call could produced.
%                   Return value : message
% 'INFO'		->	Turn on and off the information seen on the command line when a function is called.
%					second Argument is : 'TRUE' or 'FALSE'
%                   Return value : no return value