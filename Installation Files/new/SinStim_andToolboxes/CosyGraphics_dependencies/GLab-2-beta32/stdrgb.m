function RGB = stdrgb(RGB,nChannels)
% STDRGB   Convert to MATLAB most standard RGB format: doubles in the range 0-1.
%    RGB = STDRGB(RGB)  converts color/image matrix RGB. If RGB is an uint matrix,
%    convert it to double and divide it by 255 ; if it's already double, do nothing.
%
%    RGB = STDRGB(RGB,nChannels)  <todo>


switch class(RGB)
    case {'double','single','logical'}
        % do nothing.
    case 'uint8'
        RGB = double(RGB) * 255;
    otherwise
        error('Unsupported type for RGB data.')
end
    