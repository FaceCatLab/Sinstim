function stopeyelinkrecord(DestDir,EdfFile)
% STOPEYELINKRECORD  Stop data recording and transfer data file to CosyGraphics PC.
%    STOPEYELINKRECORD  stops recording. Data are transfered to "<cosygraphicstmp>\active.edf",
%    which will be used by SAVETRIALS* functions.
%
%    STOPEYELINKRECORD(DESTDIR)  writes file in DESTDIR directory.
%
%    STOPEYELINKRECORD(DESTDIR,FILENAME)  gets a custom EDF file. Normally you should not need that.


global COSY_EYELINK

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 1, DestDir = cosydir('tmp'); end
if nargin < 2, EdfFile = 'active.edf'; end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if checkeyelink('isrecording')
    dispinfo(mfilename,'info','Stopping EyeLink recording...')
    COSY_EYELINK.isRecording = 0;
    Eyelink('StopRecording');
end
