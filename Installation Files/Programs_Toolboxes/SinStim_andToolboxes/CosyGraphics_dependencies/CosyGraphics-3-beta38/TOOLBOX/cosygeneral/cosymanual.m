function cosymanual(filename)
% COSYMANUAL  Generate and edit a file with full CosyGraphics documentation.
% <OBSOLETE: BROKEN>
% See also COSYHELP.
%
% Ben, March 2008.

if ~nargin
    filename = 'CosyGraphicsManual.txt';
end




LF = char(10);
sep = [repmat('=',1,75),LF];

[v,vers] = cosyversion;

txt = dispbox({'C O S Y   G R A P H I C S'; ...
    ['version ' vnum2vstr(cosyversion)];
    '';
    'R e f e r e n c e   M a n u a l'}, ...
    10, 0, 1);


od = cd;
cd(cosydir('root')) % --!
txt = [txt,LF,LF,LF,sep,LF,LF,headercat];
cd(od)      % --!

fid = fopen(filename,'w');
fprintf(fid,'%s',txt);
fclose(fid);





edit('CosyGraphicsManual.txt');
cd(od) %         --!
