function b = checkdaqadaptor(AdaptorName)
% CHECKDAQADAPTOR  Check that a data acquisition adaptor is installed and that daq is initialized.
%    b = CHECKDAQADAPTOR(AdaptorName)  issues an error if adaptor is not an installed data acquisition 
%    adaptor.
%
%    The supported adaptors are:
%       'nidaq'         National Instrument
%       'mcc'           Measurement Computing
%       'keithley'      Keithley
%       'advantech'     Advantech
%       'hpe1432'       Agilent Technologies
%       'winsound'      Windows sound system: Can be used as a 2-channel analog board with the following 
%                       particularities: Sample freq. from 8kHz to 96kHz. High-pass filter at 20Hz.
%       'parallel'      Standard parallel port. Don't use exept for testing. Use the CosyParallelPort 
%                       module, which is more user-friendly and fixes performance issue of the Daq Toolbox.
%                       Note also that only standard parallel (i.e.: // port on the mother board) is 
%                       supported. PCI/PCI-Express ports are not supported.
%
%    Examples:
%       checkdaqadaptor nidaq
%       checkdaqadaptor winsound

global COSY_DAQ

if ~ispc
    if isopen('display'), stopcosy; end
    cosyerror('Sorry Matlab´s DAQ toolbox is only supported on MS-Windows.')
end

if isempty(COSY_DAQ) % opendaq takes about 10s, we don't want to run each more than once.
    dispinfo(mfilename,'info','Daq not yet initialized. Lauching OPENDAQ...')
    opendaq; 
end

if isempty(strmatch(AdaptorName,COSY_DAQ.InstalledAdaptors)) % Error: Adaptor not installed.
    if isopen('display'), stopcosy; end
    
    line0 = 'Adaptor not installed!'
    line1 = ['Unknown adaptor name: ''' AdaptorName ''' is not the name of an installed adaptor.'];
    line2 = ['Installed adaptors are:'];
    for c = 1 : length(COSY_DAQ.InstalledAdaptors);
        line2 = [line2 ' ''' COSY_DAQ.InstalledAdaptors{c} ''','];
    end
    line2(end) = '.';
    line3 = ['If your adaptor is plugged but doesn´t appear on the list, it means that you didn´t install it´s driver.'];
    error([line0 10 line1 10 line2 10 line3]);
    
else
    % Adaptor is installed
    line = ['Found ''' AdaptorName ''' among installed adaptors. Good.'];
    dispinfo(mfilename,'info',line)
    
    % Is a board plugged ?
    adapt = daqhwinfo(AdaptorName); 
    if isempty(adapt.InstalledBoardIds) % Error: No board present.
        if isopen('display'), stopcosy; end
        
        line1 = 'Board not plugged!';
        line2 = ['Found no board that you can control with the ''' AdaptorName ''' adaptor.'];
        line3 = 'Please, plug a board, then restart MATLAB!';
        error([line1 10 line2 10 line3]);
    end

end

% No error, alles goed!
boards = '';
for i = 1:length(adapt.BoardNames), boards = [boards adapt.BoardNames{i} ', ']; end
boards(end-1:end) = [];
line = ['Supported board found at MATLAB´s startup: ''' boards '''. Good.'];
dispinfo(mfilename,'info',line)
if length(adapt.BoardNames) < 1
    warning('Multiple bord not yet supported!!!') % <TODO!>
end