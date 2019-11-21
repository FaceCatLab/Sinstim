function b = newsoundbuffer
% NEWSOUNDBUFFER  Open a new audio buffer.
%    b = NEWSOUNDBUFFER  opens one more audio buffers and returns it's handle.  OPENSOUND opens one 
%    audio buffer ; if you need more than one, use this function.  
%
%    Note: If you use a "professional" sound card (i.e.: over PsychTB with the ASIO driver enabled)
%    for accurate precision timings, you must know that you can open only one precision sound buffer
%    at a time: NEWSOUNDBUFFER will open "normal" buffers only, not ASIO buffers.

%% Global Vars
global COSY_SOUND cogent 

%% Lib
Lib = getcosylib('Sound');

%% Create buffer
switch Lib
    case 'PTB'
        if nargin < 2  % <v2-beta34: TODO: review>
            reqlatencyclass = 0; % Cannot open more than one ASIO device <TODO: review>
            b = PsychPortAudio('Open', [], COSY_SOUND.PTB.mode, reqlatencyclass, COSY_SOUND.SampleFrequency, COSY_SOUND.nChannelsOut);
        end
        
    case 'Cog'
        b = max(COSY_SOUND.OpenBuffers) + 1;
        
        % Create buffer
        if( cogent.sound.buffer(b) )
            CogSound( 'Destroy', cogent.sound.buffer(b) );
        end
        cogent.sound.buffer( b ) = CogSound( 'Create', size(matrix,1), 'any', cogent.sound.nbits, ...
            cogent.sound.frequency, size(matrix,2) );
        
        % Set buffer
        switch cogent.sound.nbits
            case 8
                matrix = (matrix + 1) .* 127.5;
            case 16
                matrix = matrix * 32767;
            otherwise
                error( 'cogent.sound.nbit must be 8 or 16' );
        end
        CogSound( 'SetWave', cogent.sound.buffer(b), floor(matrix)' );
        
end

COSY_SOUND.OpenBuffers(end+1) = b;