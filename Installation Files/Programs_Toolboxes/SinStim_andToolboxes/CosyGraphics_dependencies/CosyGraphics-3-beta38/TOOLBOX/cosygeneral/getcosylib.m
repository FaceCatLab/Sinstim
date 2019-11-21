function varargout = getcosylib(varargin)
% GETCOSYLIB   Get name and version of lower-level C libraries in use.
%    GETCOSYLIB  displays all current libraries info.
%
%    LIB = GETCOSYLIB(MODULE)  returns the name library in use for the given
%    module. Type 'getcosylib' to get module names.
%
%    [LIB,V] = GETCOSYLIB(MODULE)  returns library name and version number, in 
%    the form of a [x y] or [x y z] vector.
%
%    V = GETCOSYLIB(LIB,'version')  returns version number of library LIB.
%
%    S = GETCOSYLIB  returns all library infos in a structure. Usefull to save
%    it.
%
% See also SETCOSYLIB, ISCOG, ISPTB.
%    
% Ben, Sept-Oct 2008

% Execution time: 0.04 ms (Matlab 6.5, Athlon X2 4400+)


global COSY_GENERAL


if ~isfield(COSY_GENERAL,'LIBRARIES')
	setcosylib; % Load defaults.
end


switch nargin
	case 1 % RETURN MODULE LIB. NAME & VERSION #
		module = varargin{1};
		if isfield(COSY_GENERAL.LIBRARIES.CURRENT,module)
			lib = COSY_GENERAL.LIBRARIES.CURRENT.(module);
            if isfield(COSY_GENERAL.LIBRARIES.VERSIONS,lib) % <fix v2-beta17: not all libs have a version #>
                v = COSY_GENERAL.LIBRARIES.VERSIONS.(lib);
            else
                v = [];
            end
			varargout{1} = lib;
			varargout{2} = v;
		else
			error('Invalid module name. Check case or type ''getcosylib'' without argument to get the list of valid modules.')
		end
		
	case 2 % RETURN LIBRARY VERSION #
		switch lower(varargin{2})
			case 'version'
				lib = varargin{1};
				v = COSY_GENERAL.LIBRARIES.VERSIONS.(lib);
				varargout{1} = v;
		end
		
	case 0, 
        switch nargout
			case 0 % DISPLAY INFOS
				disp(' ')
				disp('Libraries currently in use:')
				disp(' ')
				w0 = 4; % width margin
				w1 = 26; % width col.1
				w2 = 22; % width col.2
				titles = [blanks(w0), 'Module', blanks(w1-6), 'Current' blanks(w2-7) 'Available'];
				disp(titles)
				underline(titles ~= ' ') = '-';
				disp(underline)
				modules = fieldnames(COSY_GENERAL.LIBRARIES.CURRENT);
				for m = 1 : length(modules)
					mod = modules{m};
					if ~strcmp(mod,'VERSIONS')
						cur = COSY_GENERAL.LIBRARIES.CURRENT.(mod);
						c = COSY_GENERAL.LIBRARIES.AVAILABLE.(mod);
						avail = c{1};
						for i = 2 : length(c), avail = [avail ', ' c{i}]; end
						disp([blanks(w0), mod, blanks(w1-length(mod)), cur, blanks(w2-length(cur)), avail])
					end
				end
				disp(' ')
				disp('Library versions currently in use:')
				disp(' ')
				disp(titles)
				disp(underline)
				libs = fieldnames(COSY_GENERAL.LIBRARIES.VERSIONS);
				avail = {'1.24, 1.29, 1.30'; '1.25, 1.29, 1.30';'3.0.8';'6.5, 7.5'};
                avail = cell2char(avail);
				for l = 1 : length(libs)
					lib = libs{l};
					v = num2str(COSY_GENERAL.LIBRARIES.VERSIONS.(lib));
					disp([blanks(w0), lib, blanks(w1-length(lib)), v, blanks(w2-length(v)), avail(l,:)])
				end
				disp(' ')
				
			case 1 % RETURN STRUCTURE
				varargout{1} = COSY_GENERAL.LIBRARIES;
                
        end
        
end