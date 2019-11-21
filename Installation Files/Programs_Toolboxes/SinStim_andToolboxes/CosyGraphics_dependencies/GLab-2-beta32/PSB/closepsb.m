function closepsb
% CLOSEPSB  Close PSB.

global GLAB_PSB

if ~isempty(GLAB_PSB)
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
        if isfilledfield(GLAB_PSB,'SerialPortObject')
            port = GLAB_PSB.SerialPortObject;
        else
            port = serial(GLAB_PSB.SerialPortName,'baudrate',115200); % Open communication with PSB
            fopen(port);
        end
        % Send "no blanking" command
        fprintf(port,cmd);
        % Close port
        fclose(port);
    end

    GLAB_PSB = [];

    dispinfo(mfilename,'info','Connexion with PSB closed.')

end