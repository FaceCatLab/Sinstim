% Gama : Compute the gama of your screen
% GAMA() : Principal function which use sub function Gama2
%
% by Cecile Bordier
% last modification :  29/01/2003
%

function  Gama()
  cycle=input('Number of test : ' );
  %Create grataing image
  image_test1=256*ones(256,256);
  for i=1:256
    if(mod(i,2)==0)
      image_test1(i,:)=1;
    end
  end
  image_test=double(image_test1);
  
  %Create test image
  image1=double(175*ones(256,256));
  
  %Create and display window
  f=figure('Color',[0 0 0],'Position',[0 100 644 344]);
  set(f,'MenuBar', 'none');
  colormap(gray(256))
  
  a = axes('Units', 'pixels', ...
      'Position', [334 64 256 256], ...
      'Box','on');
  
  %Display grataing image 
  image(image_test);
  set(a,'XTick',[], 'YTick',[]);
  
  val1=175;
  titre=strcat('Gama estimation program');
  set(f,'Name',titre);
  
  mat=-1*ones(cycle,4);
  %launch the function gama2
  valf=Gama2(f,'0',val1,mat,1,1);
 
 
 











