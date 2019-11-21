function cosyhelp(filename)
% COSYHELP  Help for the CosyGraphics toolbox.
%    COSYHELP  displays list of CosyGraphics functions. (Actually, it displays
%    the first header line of each m-file.)
%
% Programmer only:
%	 COSYHELP FILENAME  saves full help of all m-files in a file. (Concaten-
%    ates full headers.)  Used by COSYMANUAL <obsolete>.
%
% Ben.

% Sep. 2007		1.0
% Mar. 2008		2.0		Create file with headercat.


d = dir(cosydir('toolbox'));
ModuleNames = {};
for i = 1 : length(d)
    name = d(i).name;
    if d(i).isdir && any(name ~= '.') % If it's a dir, other than "." or ".."
        if strncmpi(name,'cosy',4)    % ...and it begins by 'cosy' <v3-alpha5>
            ModuleNames{end+1} = name;
        end
    end
end

switch nargin

    case 0  % COSYHELP
        disp(' ')
        disp(' ')
        dispbox({'C O S Y   G R A P H I C S'; ['version ' vnum2vstr(cosyversion)]});
        disp(' ')
        disp('                    Benvenuto (Ben) JACOB, Institute of NeuroSiences, Univ. Catholique de Louvain.')
        disp(' ')
        
        disp(' ')
        for m = 1 : length(ModuleNames)
            module = ModuleNames{m};
            disp([upper(module) ':'])
            help(module)
            disp(' ')
        end

    case 1  % COSYMANUAL  % <v2-beta43: BROKEN!!!> <TODO: Re-write for multible sub-dirs.>  <v3*: OBSOLETE>
        LF = char(10);
        sep = [repmat('=',1,75),LF];

        [v,vers] = cosyversion;
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
        cd([cosygraphicsroot '/Lib/Cogent2000/v1.25'])
        txt = [txt,LF,LF,LF,LF,TitleCog,LF,sep,LF,LF,headercat];
        cd(od)      % --!

        fid = fopen(filename,'w');
        fprintf(fid,'%s',txt);
        fclose(fid);

end