function varargout = loadimage(name,varargin)
% LOADIMAGE   Read image file from graphics file and covert it to standard format.
%	 I = LOADIMAGE(filename)  reads image from file of given name and returns an
%	 M-by-N-by-3 matrix of values in the range 0 to 1 (Matlab standard data type).
%    If the file name is given without the extension, LOADIMAGE will try sequentially
%    all supported graphics file extensions. (See IMREAD to about supported files.)
%
%	 Images = LOADIMAGE(dirname)  reads all image files in given directory and returns 
%    it in a cell vector.
%
%    [Images,FileNames] = LOADIMAGE(dirname)  returns also the filenames, in a cell 
%    vector.
%
%    LOADIMAGE(...,ColorChannels)  defines color coding. ColorChannels can be 'black-and-white', 
%    (binary image), 'grayscale' (levels of gray), 'rgb' (default) or 'rgba' (red, green, blue + 
%    alpha).
%
%    LOADIMAGE(...,'int')  returns integer (uint8) matrix. This takes 8 times
%    less memory (!) than Matlab's standard double precision floating numbers, but the 
%    drawback is that Matlab 6 does not support operations on integers.
%
%    LOADIMAGE(...,wh)  resizes image(s) to resolution wh. 'wh' is a [width height] 
%    vector.
%
%    LOADIMAGE(...,'verbose')  or  LOADIMAGE(...,'-v')  prints file names when loading.
%
% See also: 
%    - Lowerlevel funct.:    IMREAD (Im. Processing Toolbox),
%    - Im. visualisation:    IMSHOW (Im. Processing Toolbox), SHOWIMAGE,
%    - Im. infos:            IMAGESIZE, 
%    - Im. processings:      BACKGROUNDMASK, CHANGEBACKGROUND, RESIZEIMAGE, SAMESIZE, SAMELUMINANCE, 
%                            RGB2GRAY (Im. Processing Tb), RGB2GGG, RGB2HSV, SCRAMBLEIMAGE,
%    - Store im. in VRAM buff.: STOREIMAGE.
%
% Ben 2007-2010. (Edit file for version infos)

% Ben, 	Sept 2007	v 1.0	First version: Basicaly did the same as:
%								I = double(imread(filename))/255;  
%								if ndims(I) == 2, I = repmat(I,[1 1 3]); end
%		Oct 		v 1.1	Complete file name for extension.
%		Mar 2008	v 2.0	Give directory name as arg. 
%                           'grayscale' option.
%					v 2.0.1 'grayscale' mode: use rgb2gray
%       Feb 2009    v 2.0.2 Doc 2.0.1
%                           Fix case indexed images (256 colors) BMP images. (Use indexed2truecolor)
%                   v 2.0.3 Fix 2.0.2.
%       Jun         v 2.0.4 Fix 'grayscale' mode in recursive call.
%       Jan 2010    v 2.1   'grayscale' -> ColorChannels ('black-and-white','grayscale','rgb','rgba')
%                           'int' option. 
%                           wh option.
%                           'verbose' option.
%                           Doc.: add "See also"

GraphicsExt = {'bmp','dib','tif','tiff','png','gif','jpg','jpeg','jpe','jfif',...
		'hdf','pcx','xwd','ico','cur','ras','pbm','pgm','ppm'};

    
    
%% CASE 1: INPUT IS A FILE NAME
if ~exist(name,'dir')
    % loadimage -v filename
    if numel(varargin) && strcmp(varargin{1},'-v')
        name = varargin{1};
        varargin{1} = '-v';
    end
    
    % File name
	filename = name;
    
    % Options
    Options.ColorChannels = 'rgb';
    Options.DataType      = 'double';
    Options.Resolution    = [];
    Options.isVerbose     = 0;
    for i = 1 : length(varargin)
        if ischar(varargin{i})
            str = lower(varargin{i});
            switch str
                case {'black-and-white','grayscale','rgb','rgba'}
                    Options.ColorChannels = str;
                case {'int','int8','uint8'}
                    Options.DataType = 'uint8';
                case {'int16','uint16'}
                    Options.DataType = 'uint16';
                case {'-v','verbose'}
                    Options.isVerbose = 1;
            end
        elseif isnumeric(varargin{i})
            Options.Resolution = varargin{i};
        end
    end
	
	% If there is no file extention : add it
	b = find(filename == filesep);
	if ~isempty(b), b = b(end);
    else            b = 0;
	end
	% if isempty(find(filename(b+1:end) == '.'))
	% 	filename = [filename '.*']; % for v1.1 syntax compatibility.
	% end
	if isempty(find(filename(b+1:end) == '.')) %|| strcmp(filename(end-1:end),'.*')
		found = 0;
		for e = 1 : length(GraphicsExt)
			if exist([filename '.' GraphicsExt{e}])
				filename = [filename '.' GraphicsExt{e}];
				found = 1;
				break
			end
		end
		if ~found
			error(['Cannot find a file ' filename '.'])
		end
    end
    
    % Verbose?
    if Options.isVerbose
        disp(['Loading image from file ' filename '...'])
    end
	
	% Read file.
	[I,M,ALPHA] = imread(filename); % Read file with IMREAD (Image Processing Toolbox)        
    
    % Convert to standard M-by-N-by-3 matrix of double (0.0 to 1.0)
    if isempty(M) % Grayscale or True Color Image
        % IMREAD returns values as unsigned 8 bits integers (uint8) in the range from 0 to 255.
        % We want "double precision floating numbers" (double) in the range from 0.0 to 1.1 (Matlab
        % -Image Processing Toolbox exepted- and G-Lab standard).
        switch Options.DataType
            case 'double'
                I = double(I) / 255;
            case 'uint8'
                I = uint8(I);
            case 'uint16'
                I = uint16(I);
        end
        
    else % Indexed image (256 color)
        % In this case, IMREAD returns colors in double (range 0.0 to 1.0) directly. So, we convert
        % here from indexed 256 colors image to true color matrix, but not from uint8 to double.
        I = indexed2truecolor(I,M);
        
    end
	
	% Case of graylevel images
    switch Options.ColorChannels
        case 'black-and-white'
            if ndims(I) == 3, I = rgb2gray(I); end
            I = logical(round(I));
        case 'grayscale'
            if ndims(I) == 3, I = rgb2gray(I); end
        case 'rgb'
            if ndims(I) == 2, I = repmat(I,[1 1 3]); end
        case 'rgba'
            if ndims(I) == 2, I = repmat(I,[1 1 3]); end
            if size(I,3) < 4, I(:,:,4) = 1; end
    end    
    
    % Alpha channel ?
    if ~isempty(ALPHA)
        if size(I,3) >= 3
            I(:,:,4) = ALPHA;
        else
            dispinfo(mfilename,'warning',['''' Options.ColorChannels ''' format does not support transparency: Deleting alpha channel.'])
        end
    end
    
    % Resize?
    if ~isempty(Options.Resolution)
        I = resizeimage(I,Options.Resolution);
    end
	
	% Output
	varargout{1} = I;
    
%% CASE 2: INPUT IS A DIRECTORY NAME    
else	
	dirname = name;
	Images = {};
	GraphicsFiles = {};
	
	od = pwd;
	cd(dirname) % --!
	AllFiles = dir;
	for s = 1 : length(AllFiles)
		filename = lower(AllFiles(s).name);
		dots = find(filename == '.');
		if length(filename) > 4 && ~isempty(dots)
			fileext = filename(dots(end)+1:end);
			for c = 1 : length(GraphicsExt);
				if strcmp(GraphicsExt{c},fileext)
                    I = loadimage(filename,varargin{:}); % <--- RECURSIVE CALL --- !!!
					Images{end+1} = I;
					GraphicsFiles{end+1} = filename;
				end
			end
		end
	end
	
	cd(od)      % --!
    
    if any(strcmp(varargin,'-v')) || any(strcmpi(varargin,'verbose')) 
        disp('Done.')
    end
	
	varargout{1} = Images';
	varargout{2} = GraphicsFiles';

end