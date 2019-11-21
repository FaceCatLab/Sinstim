function glabhelp(filename)
% GLABHELP  Help for the G-Lab toolbox.
%    GLABHELP  displays list of G-Lab functions. (Actually, it displays
%    the first header line of each m-file.)
%
% Programmer only:
%	 GLABHELP FILENAME  saves full help of all m-files in a file. (Concaten-
%    ates full headers.)  Used by GLABMANUAL.
%
% See also GLABMANUAL.
%
% Ben.

% Sep. 2007		1.0
% Mar. 2008		2.0		Create file with headercat.

dirpath = which('glabhelp');
f = find(dirpath == filesep);
dirname = dirpath(f(end-1)+1:f(end));
dirpath = dirpath(1:f(end));

TitleGL  = 'I. G-LAB FUNCTIONS (by Ben Jacob):';
TitleCog = 'II. ORIGINAL COGENT 2000 FUNCTIONS:';

switch nargin
	
	case 0
		disp(' ')
		disp(TitleGL)
		help(dirname)
		
		disp(TitleCog)
        disp('This functions may be a little bit less well integrated in the toolbox,')
        disp('but should work properly. They all will be replaced in a further versions.')
		help('v1.25')
		
	case 1
		LF = char(10);
		sep = [repmat('=',1,75),LF];
		
		[v,vers] = glabversion;
		txt = [ ...
				'                _______________________________________________ ',LF,...
				'               |                                               |',LF,...
				'               |                  G - L  A  B                  |',LF,...
                '               |              Graphics Laboratory              |',LF,...
                '               |                                               |',LF,...
				'               |        R e f e r e n c e   M a n u a l        |',LF,...
				'               |_______________________________________________|',LF,...
				LF,LF,...
				'Version ',vers,...
			];
		
		od = cd;
		cd(dirpath) % --!
		txt = [txt,LF,LF,LF,LF,TitleGL,LF,sep,LF,LF,headercat];
		cd([glabroot '/Lib/Cogent2000/v1.25'])
		txt = [txt,LF,LF,LF,LF,TitleCog,LF,sep,LF,LF,headercat];
		cd(od)      % --!
		
		fid = fopen(filename,'w');
		fprintf(fid,'%s',txt);
		fclose(fid);
		
end