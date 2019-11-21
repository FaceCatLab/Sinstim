function varargout = getlibrary(varargin)
% GETLIBRARY   Get name and version of lower-level C libraries in use.
%    GETLIBRARY  displays all current libraries info.
%
%    LIB = GETLIBRARY(MODULE)  returns the name library in use for the given
%    module. Type 'getlibrary' to get module names.
%
%    [LIB,V] = GETLIBRARY(MODULE)  returns library name and version number, in 
%    the form of a [x y] or [x y z] vector.
%
%    V = GETLIBRARY(LIB,'version')  returns version number of library LIB.
%
%    S = GETLIBRARY  returns all library infos in a structure. Usefull to save
%    it.
%
% See also SETLIBRARY, ISCOG, ISPTB.
%    
% Ben, Sept-Oct 2008

% Execution time: 0.04 ms (Matlab 6.5, Athlon X2 4400+)


global GLAB_LIBRARIES


if isempty(GLAB_LIBRARIES)
	setlibrary % Load defaults
end


switch nargin
	case 1 % RETURN MODULE LIB. NAME & VERSION #
		module = varargin{1};
		if isfield(GLAB_LIBRARIES.CURRENT,module)
			lib = GLAB_LIBRARIES.CURRENT.(module);
            if isfield(GLAB_LIBRARIES.VERSIONS,lib) % <fix v2-beta17: not all libs have a version #>
                v = GLAB_LIBRARIES.VERSIONS.(lib);
            else
                v = [];
            end
			varargout{1} = lib;
			varargout{2} = v;
		else
			error('Invalid module name. Check case or type ''getlibrary'' without argument to get the list of valid modules.')
		end
		
	case 2 % RETURN LIBRARY VERSION #
		switch lower(varargin{2})
			case 'version'
				lib = varargin{1};
				v = GLAB_LIBRARIES.VERSIONS.(lib);
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
				modules = fieldnames(GLAB_LIBRARIES.CURRENT);
				for m = 1 : length(modules)
					mod = modules{m};
					if ~strcmp(mod,'VERSIONS')
						cur = GLAB_LIBRARIES.CURRENT.(mod);
						c = GLAB_LIBRARIES.AVAILABLE.(mod);
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
				libs = fieldnames(GLAB_LIBRARIES.VERSIONS);
				avail = {'1.24, 1.28, 1.29'; '1.25, 1.28, 1.29';'3.0.8';'6.5, 7.5'};
                avail = cell2char(avail);
				for l = 1 : length(libs)
					lib = libs{l};
					v = num2str(GLAB_LIBRARIES.VERSIONS.(lib));
					disp([blanks(w0), lib, blanks(w1-length(lib)), v, blanks(w2-length(v)), avail(l,:)])
				end
				disp(' ')
				
			case 1 % RETURN STRUCTURE
				varargout{1} = GLAB_LIBRARIES;
                
        end
        
end