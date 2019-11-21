function octave2matlab
% OCTAVE2MATLAB  Convert all m-files in the current directory
%    from Octave to Matlab syntax and save the output files in 
%    a subdir called 'matlab'. Add 'octave_' at the begin of
%    the file name if it is the same than that of an already 
%    existing file in Matlab's path.

% ben   7 sep 2006


warning off MATLAB:MKDIR:DirectoryExists
mkdir('matlab');

cd

filelist = doublons%;

d = dir;
for i = find(~[d.isdir])
    if strcmpi(d(i).name(end-1:end),'.m')
        
        fid = fopen(d(i).name);  % Ouverture du fichier (fid = file identificator).
        text = fscanf(fid,'%c'); % Crée un vecteur "text", avec le contenu du fichier ascii.
        fclose(fid);

        if length(strfind(filelist,d(i).name))
            d(i).name = ['octave_' d(i).name];
        end
        disp(d(i).name)
        
        text = convert(text);
        
        fid = fopen(['matlab\' d(i).name],'w');
        fprintf(fid,'%s',text);
        fclose(fid);
    end
end


%----------------------------
function text = convert(text)


% Convert header :

f = strfind(text,'-*- texinfo -*-');
text = text(f+16:end); % Suppress copyright info

text = delete_string(text,'deftypefn {Function File}');
text = delete_string(text,'deftypefnx {Function File}');
text = delete_string(text,[char(10) '## @end deftypefn']);
text = delete_string(text,'@ ');
text = delete_string(text,'@var{');
text = delete_string(text,'@code{');

z = strfind(text,'## Author:');
text = [text(1:z-2) '%' text(z-1:end)]; % Add a comment symbol

f1 = strfind(text(1:z),'{');
f2 = strfind(text(1:z),'}');
text = text(setdiff(1:length(text),[f1 f2]));


% Convert code :

f = strfind(text,'#');
text(f) = repmat('%',1,length(f));

f = strfind(text,'!');
text(f) = repmat('~',1,length(f));

b  = strfind(text,' ');
l  = strfind(text,'`');
q0 = strfind(text,'''');
q = zeros(size(l));
for i = 1 : length(l)
    q(i) = min(find(q0 > l(i))); 
end
text(q) = repmat('´',1,length(q)); % replace ' by ´ when a ' follows a `, likes this:  `str'
if isempty(l) & length(q0) > 1
    disp([num2str(length(q0)) ' quotes ('') to verify in this file.'])
end

f = strfind(text,'"');
text(f) = repmat('''',1,length(f));

f = strfind(text,'endif');
text = text(setdiff(1:length(text),[f+3 f+4]));
f = strfind(text,'endfor');
text = text(setdiff(1:length(text),[f+3 f+4 f+5]));
f = strfind(text,'endwhile');
text = text(setdiff(1:length(text),[f+3 f+4 f+5 f+6 f+7]));
text = delete_string(text,'endfunction');
f = strfind(text,'endfunction');


%----------------------------
function text = delete_string(text,string)

f = strfind(text,string);
for i = length(f) : -1 : 1
    text = text(setdiff(1:length(text),f(i):f(i)+length(string)-1));
end


%----------------------------
function filelist = doublons % Give the list of files in Matlab's path which have
%                              the same name than a file in the current dir.

filelist = [];
directory = cd;
isinpath = ~isempty(strfind(path,directory));

if isinpath
    rmpath(directory)
end

d = dir;
cd C:        % @@@   !

for i = find(~[d.isdir])
    if strcmpi(d(i).name(end-1:end),'.m')
        if exist(d(i).name,'file')
            filelist = [filelist which(d(i).name) char(10)];
        end
    end
end

cd(directory) % @@@  !

if isinpath
    addpath(directory)
end