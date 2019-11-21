function closepsb
% CLOSEPSB  Close connection to Psychophysics Synchronisation Box (PSB).

global COSY_PSB

if ~isempty(COSY_PSB)
    dispinfo(mfilename,'info','Closing connexion with PSB...')

    %% Set photodiode off
    try, setphotodiodevalue(0); end

    %% Command
    cmd = '!#RB0000x$';  % blanking area = zero lines

    %% Close serial port
    v = version;
    if     v(1) <= '6'
        psb_sendserialcommand(cmd);
        closeserialport;
    elseif v(1) >= '7'
        % Get port object, open port if necessary
        if isfilledfield(COSY_PSB,'SerialPortObject')
            port = COSY_PSB.SerialPortObject;
        else
            port = serial(COSY_PSB.SerialPortName,'baudrate',115200); % Open communication with PSB
            fopen(port);
        end
        % Send "no blanking" command
        fprintf(port,cmd);
        % Close port
        fclose(port);
    end

    COSY_PSB = [];

    dispinfo(mfilename,'info','Connexion with PSB closed.')

end