function [y,fs,nbits] = loadsound(filename)
% LOADSOUND  Read Microsoft WAVE (".wav") sound file.
%    This is a simple, easy-to-use, function. For advanced usage, see WAVREAD (MatLab 
%    standard function).
%
%    [Y,FS] = LOADSOUND(FILENAME) reads a WAVE file specified by the string FILENAME,
%    returning the sampled data in Y and the sampling frequency FS. The ".wav" extension
%    is appended if no extension is given.
%
% Ben, Jan 2011.

if strncmpi(filename(end:-1:1),'3pm.',4) % *.mp3
    [y,fs,nbits] = mp3read(filename);
else                                     % *.wav
    [y,fs,nbits] = wavread(filename);
end
y = y';