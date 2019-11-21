
% "M" matrix:
% col#:     1       2       3       4       5       6
% data:     y       m       d       h    adr/esth   #err

jExp = 5;
jMF = 6;

dirs{1} = 'G:\Data_SinStim_v1.0-1.3\adriano\';
dirs{2} = 'G:\Data_SinStim_v1.0-1.3\esther\';

d1 = dir([dirs{1} '*.mat']);
d2 = dir([dirs{2} '*.mat']);

d = [d1; d2];
nFiles = length(d);

M = zeros(nFiles,3);

M(1:length(d1),jExp)     = 1;  % 1 = Adriano
M(length(d1)+1:end,jExp) = 2;  % 2 = Esther

for i = 1 : nFiles
    name = d(i).name;
    f = strfind(name,'_200');
    M(i,1) = str2num(name(f+1:f+4));	% y
    M(i,2) = str2num(name(f+6:f+7));    % m
    M(i,3) = str2num(name(f+9:f+10));   % d
    M(i,4) = str2num(name(f+12:f+13));  % h
    
    fullname = fullfile(dirs{M(i,jExp)},name);
    load(fullname,'MissedFrames','Times')
    M(i,jMF) = MissedFrames;
    
%     if MissedFrames > 20
%         ttt = Times;
%     end

    s = findmissedframes(Times);
    M(i,jMF+1) = s.nMissedFrames;
    
    if ~rem(i,20), disp([int2str(i/nFiles*100) ' %']), end
end

% Sort
[c,order] = sort(10000*M(:,1) + 100*M(:,2) + 1*M(:,3) + .01*M(:,4));
M = M(order,:);

% Plot
figure;
h = plot(M(:,jMF),'r');
set(h,'marker','o')

% Day
day = M(:,3) + 100 * M(:,2) + 10000 * M(:,1);
d1 = unique(day);
f = find(diff(day));
hold on
for i = 1 : length(f)
    plot(f([i i]) + .5, [0 50], 'c');
end