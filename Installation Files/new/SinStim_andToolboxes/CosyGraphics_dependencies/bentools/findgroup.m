function [i0,i1,n] = group(v,maxdiff,minsize)
% FINDGROUP  Find groups of elements in an increasing vector.
%    [i0,i1] = FINDGROUP(v, maxdiff, minsize)  finds groups in the increasing vector v  
%    with as criterium that it groups all the elements which are distant of 'maxdiff' 
%    elements or less. It does not consider groups that have less than 'minsize' elements.
%
%    [i0,i1] = FINDGROUP(v)  is the same than:  [i0,i1] = FINDGROUP(v,1,2);
%
% Example:
%    findgroup([1 2 4 6 10 11 15 16 18], 2, 2)  returns i0 = [1 5 7] and i1 = [4 6 9].


% This function is a modified version of GROUP, written by an anonymous student of Ph. Lefèvre.
%
% Ben:  6 march 2007    Change name!: GROUP -> evFindGroups (Eyeview function).
%                       Change 'pos' output args: 1-by-2n -> 2-by-n.
%                       Fix one element error in minsize.
%       21 aug. 2009    Change name!: evFindGroups -> FINDGROUP (BenTools function).
%                       Change output args: pos -> i0,i1.
%                       maxdiff: strictly less -> less or equal.
%                       Fix case minsize = 0.
%       05 may 2011     Default arg. values.


%% Input Args
if nargin < 3
    minsize = 2;
end
if nargin < 2
    maxdiff = 1;
end
minsize = minsize - 1; % Bug in GROUP: error of one element. Fix from ben, 6 march 2007
minsize = max([minsize 0]); % Fix case minsize=0. Ben, 21 aug. 2009

%% Find Groups
[r l]=size(v);
if r~=1
    v=v';
end

temp=v(2:end)-v(1:end-1);
if min(temp)<1|min([r l])>1 %not increasing vector | a single element
    pos=[];
    n=0;
else
    s=find(temp>maxdiff);
    pos(1)=1;
    t=2;
    for i=1:length(s)
        if (s(i)-pos(t-1))>=minsize
            pos(t)=s(i);
            t=t+1;
            pos(t)=s(i)+1;
            t=t+1;
        else
            pos=setdiff(pos,pos(t-1));
            pos(t-1)=s(i)+1;
        end
    end
    if (length(v)-pos(t-1))>=minsize
        pos(t)=length(v);
    else
        pos=setdiff(pos,pos(t-1));
        t=t-1;
    end   
    n=length(pos)/2;
end

% Ben: Change output args, 21 aug. 2009
i0 = pos(1:2:end);
i1 = pos(2:2:end);
