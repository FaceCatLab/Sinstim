% Gama2 : Secondary function for the computing of your gamma screen
% 
% val=Gama2(f,menu, val, valfin,num, cycle) : it is a sub function of
% Gama. All the parameter must be  character strings
%  
%    f : number of the figure
%    menu : corresponds to the choice of the user
%    val : corresponds to gray level which  display
%    valfin : tables of the correct values (4 values by test for 0.125,0.25,0.5,0.75)
%    num : number of the present test
%    cycle : number of test
% 

% by Cecile Bordier
% last modification :  29/01/2003


function valfin1=Gama2(f,menu, val, valfin,num, cycle)

  fin=1;

  %Management of the actions button
  switch menu
    %start
    case '0'
      val1=val;
      valfin1 = valfin;
      cycle1=cycle;
      num1=num;
      f1=f;
      a = axes('Units', 'pixels', ...
	  'Position', [54 64 256 256], ...
	  'Box','on','XTick',[], 'YTick',[]);
      %Create test image
      image1=double(val1*ones(256,256));
      image(image1)
      luminance='0.5';
      axis off
      %%%%%%%%%%%%%%%%
      %Label
      %%%%%%%%%%%%  
      c=strcat('Test n°',num2str(cycle1));
      Cycle_lb= ...
	  uicontrol('style','text','HorizontalAlignment','right','FontSize',12,...
	  'ForegroundColor', [1 1 1],'BackgroundColor',[0 0 0],'Position', [490 29 100 25],'String',c);
      
      c=strcat('Brightness= ',luminance);
      Lum_lb= ...
	  uicontrol('style','text','HorizontalAlignment','right','FontSize',12,...
	  'ForegroundColor', [1 1 1],'BackgroundColor',[0 0 0],'Position', [390 15 200 25],'String',c);
      
      c=strcat('Gray level= ',num2str(val1));
      NG_lb= ...
	  uicontrol('style','text','HorizontalAlignment','right','FontSize',12,...
	  'ForegroundColor', [1 1 1],'BackgroundColor',[0 0 0],'Position', [390 1 200 25],'String',c);
      
      %If the button "darker" is clicked
    case '1' 
      colormap(gray(256));
      valfin1=str2num(valfin);
      num1=str2double(num);
      f1=str2double(f);
      val1=str2double(val);
      cycle1=str2double(cycle);
      
      %positioning on the figure
      figure(f1);
      
      %recompute the test image (darker)
      val1=str2double(val)-1;     
      image1=val1*ones(256,256);
      % Display
      image(image1);
      axis off
      c=strcat('Gray level= ',num2str(val1));
      NG_lb= uicontrol('style','text','HorizontalAlignment','right','FontSize',12,'ForegroundColor', [1 1 1],'BackgroundColor',[0 0 0],'Position', [390 1 200 25],'String',c);
      %If the button "lighter" is clicked
    case '2'
      colormap(gray(256));
      %convert paramter to numeric value   
      valfin1=str2num(valfin);
      num1=str2double(num);
      f1=str2double(f);
      val1=str2double(val);
      cycle1=str2double(cycle);
      %positioning on the figure
      figure(f1);
      
      %recompute the test image (lighter)
      val1=str2double(val)+1;     
      image1=val1*ones(256,256);
      %display
      image(image1);
      axis off
      c=strcat('Gray level= ',num2str(val1));
      NG_lb= uicontrol('style','text','HorizontalAlignment','right','FontSize',12,'ForegroundColor', [1 1 1],'BackgroundColor',[0 0 0],'Position', [390 1 200 25],'String',c);
      % If the button "OK" is clicked 
    case '3'  
      colormap(gray(256));
      clf;
      %convert paramter to numeric value    
      valfin1=str2num(valfin);
      num1=str2double(num);
      f1=str2double(f);
      val1=str2double(val);
      cycle1=str2double(cycle);
      %stock the gray level
      valfin1(cycle1,num1)=val1;
      % change luminance
      num1=num1+1;
      val2=0;
      %if test is not finish
      if(num1<5)   
	%positioning on the figure
	figure(f1); 
	%initialization of the variables
	image_test=ones(256,256);
	image_test1=ones(256,256);
	
	% if luminance=0.5 is finish for this test
	if (num1==2)
	  luminance='0.75';
	  %Create grataing image (level2)
	  image_test1=256*ones(256,256);
	  for i=1:256
	    if(mod(i,2)==0)
	      image_test1(i,:)=val1(1);
	    end
	  end
	  % compute the start "test" value
	  val2=round((256+val1)/2);
	end
	%if luminance=0.75 is finish for this test
	if(num1==3)
	  luminance='0.25';
	  %Create grataing image (level3)
	  image_test1=ones(256,256);
	  for i=1:256
	    if(mod(i,2)==0)
	      image_test1(i,:)=valfin1(cycle1,1);
	    end
	  end
	  % compute the start "test" value
	  val2=round((valfin1(cycle1,1))/2);
	end
	%if luminance=0.25 is finish for this test
	if(num1==4)
	  luminance='0.125';
	  %Create grataing image (level4)
	  image_test1=zeros(256,256);
	  for i=1:256
	    if(mod(i,2)==0)
	      image_test1(i,:)=valfin1(cycle1,3);
	    end
	  end
	  % compute the start "test" value
	  val2=round((valfin1(cycle1,3))/2);
	end
	%Create test image
	image_test=double(image_test1);
	image1=double(val2*ones(256,256));
	colormap(gray(256));
	
	%display
	a = axes('Units', 'pixels', ...
	    'Position', [334 64 256 256], ...
	    'Box','on');
	image(image_test);
	axis off
	a = axes('Units', 'pixels', ...
	    'Position', [54 64 256 256], ...
	    'Box','on','XTick',[], 'YTick',[]);
	image(image1);
	axis off
	val1=val2
	c=strcat('Test n°',num2str(cycle1));
	Cycle_lb= ...
	    uicontrol('style','text','HorizontalAlignment','right','FontSize',12,...
	    'ForegroundColor', [1 1 1],'BackgroundColor',[0 0 0],'Position', [490 29 100 25],'String',c);
	
	c=strcat('Brightness= ',luminance);
	Lum_lb= ...
	    uicontrol('style','text','HorizontalAlignment','right','FontSize',12,...
	    'ForegroundColor', [1 1 1],'BackgroundColor',[0 0 0],'Position', [390 15 200 25],'String',c);
	
	c=strcat('Gray level= ',num2str(val1));
	NG_lb= ...
	    uicontrol('style','text','HorizontalAlignment','right','FontSize',12,...
	    'ForegroundColor', [1 1 1],'BackgroundColor',[0 0 0],'Position', [390 1 200 25],'String',c);
	% if test is finish
      else
	t=size(valfin1);
	% if all test is finish
	if(cycle1==t(1))
	  fin=0;
	  %launch the function "Calcul"
	  Calcul(valfin1,t(1));
	else
	  luminance='0.5';
	  cycle1=cycle1+1;
	  num1=1;
	  %Create new image
	  image_test1=256*ones(256,256);
	  for i=1:256
	    if(mod(i,2)==0)
	      image_test1(i,:)=1;
	    end
	  end
	  image_test=double(image_test1);
	  a = axes('Units', 'pixels', ...
	      'Position', [334 64 256 256], ...
	      'Box','on','XTick',[], 'YTick',[]);
	  %Create test image 
	  image1=double(175*ones(256,256));
	  %Display
	  image(image_test);
	  axis off
	  a = axes('Units', 'pixels', ...
	      'Position', [54 64 256 256], ...
	      'Box','on','XTick',[], 'YTick',[]);

	  image(image1);
	  axis off
	  val1=175;
	  c=strcat('Test n°',num2str(cycle1));
	  Cycle_lb=uicontrol('style','text','HorizontalAlignment','right','FontSize',12,... 
	      'ForegroundColor', [1 1 1],'BackgroundColor',[0 0 0],'Position', [490 29 100 25],'String',c);
	  
	  c=strcat('Brightness= ',luminance);
	  Lum_lb= ...
	      uicontrol('style','text','HorizontalAlignment','right','FontSize',12,...
	      'ForegroundColor', [1 1 1],'BackgroundColor',[0 0 0],'Position', [390 15 200 25],'String',c);
	  
	  c=strcat('Gray level= ',num2str(val1));
	  NG_lb= ...
	      uicontrol('style','text','HorizontalAlignment','right','FontSize',12,...
	      'ForegroundColor', [1 1 1],'BackgroundColor',[0 0 0],'Position', [390 1 200 25],'String',c);
	end
      end
   
      %other case => Error
    otherwise
      eerror(['Unknow cmd_string''' cmd '''.']);
  end


  if fin==1

    %%%%%%%%%%%%%%%%%%%%%%
    %Button "Darker"
    %%%%%%%%%%%%%%%%%%%%%
    
    %Create string for launch the function Callback
    c='val1=Gama2(''';
    c=strcat(c,num2str(f1));
    c=strcat(c,''',''1'',''');
    c=strcat(c,num2str(val1));
    c=strcat(c,''',''');
    c=strcat(c,mat2str(valfin1));
    c=strcat(c,''',''');
    c=strcat(c,num2str(num1));
    c=strcat(c,''',''');
    c=strcat(c,num2str(cycle1));
    c=strcat(c,''');');
    Prog_Plus=[c,' '];
    %Create the button
    Plus_bt= uicontrol('style','pushbutton','Position', [44 15 80 25],'String','Darker');
    set(Plus_bt,'callback',Prog_Plus);
    
    %%%%%%%%%%%%%%%%%%%%%%
    %Button "Lignter"
    %%%%%%%%%%%%%%%%%%%%%%
    
    %Create string for launch the function Callback
    c='val1=Gama2(''';
    c=strcat(c,num2str(f1));
    c=strcat(c,''',''2'',''');
    c=strcat(c,num2str(val1));
    c=strcat(c,''',''');
    c=strcat(c,mat2str(valfin1));
    c=strcat(c,''',''');
    c=strcat(c,num2str(num1));
    c=strcat(c,''',''');
    c=strcat(c,num2str(cycle1));
    c=strcat(c,''');');
    Prog_Moins=[c,' '];
    %Create the button
    Moins_bt= uicontrol('style','pushbutton','Position', [140 15 80 25],'String','Lighter');
    set(Moins_bt,'callback',Prog_Moins);
    
    %%%%%%%%%%%%%%%%%%%%%%
    %Button "Lignter"
    %%%%%%%%%%%%%%%%%%%%%%
    
    %Create string for launch the function Callback
    c='val1=Gama2(''';
    c=strcat(c,num2str(f1));
    c=strcat(c,''',''3'',''');
    c=strcat(c,num2str(val1));
    c=strcat(c,''',''');
    c=strcat(c,mat2str(valfin1));
    c=strcat(c,''',''');
    c=strcat(c,num2str(num1));
    c=strcat(c,''',''');
    c=strcat(c,num2str(cycle1));
    c=strcat(c,''');');
    Prog_End=[c,' '];
    %Create the button
    End_bt= uicontrol('style','pushbutton','Position', [240 15 80 ...
	  25],'String','OK');
    set(End_bt,'callback',Prog_End);
  end