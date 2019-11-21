function [header,Samples,eyelinkEvents] = extractascfile(filename)
% EXTRACTASCFILE  Separate header, samples and events lines frome .asc file. <UNFINISHED>
%
% Alex Zenon, 2011.


%% Read file
fid = fopen(filename);
content = fread(fid);
fclose(fid);
content = char(content(:)');
content(13) = []; % remove carriage returns

% f = find(content==10); 
% header = char(content(1:f(25)))';
% F = content(f(25)+1:end);



eventTypes = {'EBLINK','ESACC','EFIX','MSG','SFIX','SSACC','SBLINK'};





LFs = strfind(content,10);
begLines = [1 LFs(1:end-1)+1];
endLines = LFs - 1;






for et = 1:length(eventTypes)
    f = findstr(char(F)',char([10 double(eventTypes{et})]))+1;
    next=0;
    for ev = f
        next=next+1;
        eof = find(F(ev:min([ev+1000, length(F)]))==10);
        evLine = char(F(ev:ev+eof(1)-2))';
        eyelinkEvents(et).evLine{next} = evLine;
    end
end
