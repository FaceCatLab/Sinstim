% Calcul : Secondary function for the computing of your gamma screen
%
%  Calcul(valf, cycle). All the parameter must be  character strings
%
%    valf :tables of the values (4 values by test for 0.125,0.25,0.5,0.75)
%    cycle : number of times that the test was realize
%
%
% by Cecile Bordier
% last modification :  10/01/2003


function Calcul(valf, cycle)
close all
% display figure
f=figure('Color',[1 1 1],'Position',[0 100 644 344]);
a = axes('Units', 'centimeters');

mat1=[];

%create and display the graph of mesures 
for i=1:cycle
  mat=[0,0;valf(i,4),0.125;valf(i,3),0.25;valf(i,1),0.5;valf(i,2),0.75;255,1];
  hold on;
  mat1=[mat1,mat];
  plot(mat(:,1),mat(:,2),'.','MarkerSize',20);
end
%initialization of p (=[k,gamma])
p=[1/256,2.2];


%launch the function of minimization according to the version of matlab
[vers]=(version);
vers1=str2num(vers(1));
vers2=str2num(vers(3));

if(vers1>5 | (vers1==5 & vers2>=3))
  fct=['opt=optimset(''TolFun'',1e-10,''TolX'',1e-10,''MaxFunEvals'',5e6,''MaxIter'',5e6);[p,e]=fminsearch(''gam_err'',p,opt,mat1);'];
  eval(fct)
else
  fct=['opt=foptions;opt(2)=1e-10;opt(3)=1e-10;opt(14)=5e6;[p,e]=fmins(''gam_err'' ,p,opt,[],mat1);'];
  eval(fct)
end
%recupération des données
g=p(2);
k=p(1);
e;

%Display graph of the result y=kx^g
hold on
x=0:1:256;
y=k.*(x.^g);
plot(x,y,'g','LineWidth',2);
text(20,0.8,['\gamma = ' num2str(g)],'FontSize',16);
text(20,0.9,['k = ' num2str(k)],'FontSize',16);













