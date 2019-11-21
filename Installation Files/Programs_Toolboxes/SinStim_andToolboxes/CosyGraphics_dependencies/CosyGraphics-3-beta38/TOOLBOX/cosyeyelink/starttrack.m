function starttrack
% STARTTRACK  Run SR-Research's Track program, for EyeLink's camera setup.

exefile = '"C:\Program Files\SR Research\EyeLink\bin\track.exe"';
dispinfo(mfilename,'info',['Starting ' exefile '...']);
dos(exefile);
dispinfo(mfilename,'info','Done.')