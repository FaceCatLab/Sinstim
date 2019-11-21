%% Publish a Sudoku puzzle!

% This code creates a .png image file of a Sudoku puzzle or of a blank
% Sudoku grid.
%
% Idea: On the Internet, you can find and download a free program called
% PNGOUT to optimize your PNG file!
%
% (c) 2009 Bradley Knockel

g=35; %determines the size of the Sudoku grid (positive integer)
m=35; %determines the size of the margin (non-negative integer)

base='sudoku'; %name of PNG file (will overwrite if file exists)

% copy and paste a Sudoku here, or keep it zeros to make a blank grid
sudoku=[
    0,0,0,0,0,0,0,0,0
    0,0,0,0,0,0,0,0,0
    0,0,0,0,0,0,0,0,0
    0,0,0,0,0,0,0,0,0
    0,0,0,0,0,0,0,0,0
    0,0,0,0,0,0,0,0,0
    0,0,0,0,0,0,0,0,0
    0,0,0,0,0,0,0,0,0
    0,0,0,0,0,0,0,0,0];

%% the code

% make a blank grid without margins
s=2*g;
y=ones(s*9+4);
for i=[1:3*s:9*s+1,2:s:9*s+2,3:s:9*s+3,4:3*s:9*s+4]
    y(:,i)=0;
    y(i,:)=0;
end
y=uint8(255*y);

% add numbers
a=imread('numbers.png');
a=uint8(255/a(1,1)*a);
for i=find(sudoku)'
    j=sudoku(i);
    [r,c]=ind2sub([9,9],i);
    r=(r-1)*s+g-15;
    c=(c-1)*s+g-11;
    y(r:r+35,c:c+27)=a(:,(j-1)*28+1:j*28);
end

% add margins
x=ones(s*9+4+2*m);
x=uint8(255*x);
x(m+1:m+s*9+4,m+1:m+s*9+4)=y;

% display and save
close all
image(cat(3,x,x,x))
imwrite(x,[base,'.png'])
clear all
