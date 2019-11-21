function y = autoregfiltinpart(sampfrq,cutoff,sign)
% AUTOREGFILTINPART  Filter discontinuous signal.
%
%    signal = autoregfiltinpart(sampfrq,cutoff,signal)  filters the given discontinuous (with NaN's) 
%    signal at the refered cutoff frequency. Sampfrq must be given.
%
% This function comes from Okulo. It has been modified by Ben Jacob to become a standalone file.
%
% Ben,  14 May 2007: Merge autoregfilt_ok and autoregfiltinpart_ok in one file.
%       19 Aug 2009: Merge also group to get a standalone file.


y = sign;

IsNotNaN = find(isfinite(sign));
[pos,n] = group(IsNotNaN,1.5,25);
for kk = 1:n,
    y(IsNotNaN(pos(2*kk-1)):IsNotNaN(pos(2*kk))) = autoregfilt(sampfrq,cutoff,sign(IsNotNaN(pos(2*kk-1)):IsNotNaN(pos(2*kk))));
end;

%______________________________________________________________________________
function y = autoregfilt(sampfrq,cutoff,signal)
% this function filters the given continuous (no NaN's) signal at the refered cutoff frequency.
% Sampfrq must be given.

k=round(((sampfrq/cutoff)-1)/2);

[e1,e2]=size(signal);
if e2>e1;
   signal=signal';
end
lo=length(signal);

signal=[zeros(6*k+3,1);signal;zeros(3*k,1)];

arr=(3*k+4):(6*k+3+lo);
temp=-signal(arr-3*k-3)+3*signal(arr-k-2)-3*signal(arr+k-1)+signal(arr+3*k);

A=[1,-3,3,-1];
B=1;
y=filter(B,A,temp);%y(n)=y(n-3)-3*y(n-2)+3*y(n-1)+temp(n);
y=y/((2*k+1)^3);

y=y(end+1-lo:end);
y(1:3*k)=NaN;
y(end-3*k+1:end) = NaN;

%______________________________________________________________________________
function [pos,n]=group(x,crit,excl)
%function [pos,n]=group(x,crit,excl)
%determine the number of groups of an increasing vector with as criterium that it's group 
%all the elements which are distant of striclty less than 'crit' elements. It does not consider
%group that have less than 'excl' elements.
%pos gives the positions related to the vector x of the begins and ends of each group
%example group([1 2 4 6 10 11 15 16 18],2,2) gives n=2 and pos=[1 4 7 9];

[r l]=size(x);
if r~=1
  x=x';
end

temp=x(2:end)-x(1:end-1);
if min(temp)<1|min([r l])>1 %not increasing vector | a single element
  pos=[];
  n=0;
else
  s=find(temp>crit);
  pos(1)=1;
  t=2;
  for i=1:length(s)
     if (s(i)-pos(t-1))>=excl
        pos(t)=s(i);
        t=t+1;
        pos(t)=s(i)+1;
        t=t+1;
     else
        pos=setdiff(pos,pos(t-1));
        pos(t-1)=s(i)+1;
     end
  end
  if (length(x)-pos(t-1))>=excl
     pos(t)=length(x);
  else
     pos=setdiff(pos,pos(t-1));
     t=t-1;
  end   
  n=length(pos)/2;
end