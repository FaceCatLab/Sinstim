function I3 = indexed2truecolor(I,M)
% INDEXED2TRUECOLOR  Convert indexed 256 colors image matrix to truecolor matrix.
%    I3 = indexed2truecolor(I,M)  converts M-by-N matrix of indices I and D-by-3 (usually D = 256)
%    palette matrix M to M-by-N-by-3 image matrix (G-Lab standard). Both input and output colors 
%    are in the range 0.0 to 1.0.
%
% Ben, Feb 2009

if ~isempty(M) % Indexed 256 Colors
    I = double(I) + 1;
    M = permute(M,[1 3 2]);
    I3 = zeros([size(I) 3]);
    
    % --- beg optim FOR loop [
    for j = 1 : size(I,2)
        for i = 1 : size(I,1)
            ind = I(i,j);
            M(ind,1,:);
            I3(i,j,:) = M(ind,1,:);
        end
    end
    % ] end optim FOR loop ---
    
elseif size(I,3) == 3 % True Color
    I3 = I;           % ..do nothing
    
elseif size(I,3) == 1  % Grayscale
    I3 = cat(3,I,I,I); % -> True Color
    
else
    error('Invalid arguments.')
    
end