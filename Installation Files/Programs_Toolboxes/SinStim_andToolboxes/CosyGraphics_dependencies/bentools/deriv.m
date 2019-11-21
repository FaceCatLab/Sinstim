function df = deriv(signal,sampfreq,halfwidth)
% DERIV  First order derivative.
%    df = DERIV(signal,sampfreq)  estimates the first order derivative of 'signal'. 'sampreq' is the
%    sampling frequency in Hz.
%
%    df = DERIV(signal,sampfreq,halfwidth)  'halfwidth' was .010 in Okulo.
%
%    sampfreq = 1/sfr;
%    halfwidth was .01 in Okulo
%	 Estimates the first order derivative of signal
%
% Ben Jacob, 9 Jun 2010.  Modified version of derivee.m from Okulo.

signal = signal(:); % ben 23/5/2006
if ~exist('halfwidth','var'), halfwidth = 0.010; end

delta = 1 / sampfreq;

q = round(halfwidth/delta);
denom = 2 * delta * sum((1:q).^2);

df = conv((-q:q),signal)/denom;
df = -df(q+1:length(df)-q);