% demo_matlab_optim_vectoriz


n=1000; 


%% Non optim
t0=time; 
M=zeros(n); 
for i=1:n, 
    for j=1:n, 
        if sqrt( (i-n/2).^2 + (j-n/2).^2 ) < n/2, 
            M(i,j)=1; 
        end, 
    end, 
end, 
dt=time-t0


t0=time; n=1000; M=zeros(n); for i=1:n, for j=1:n, if sqrt( (i-n/2)^2 + (j-n/2)^2 ) < n/2, M(i,j)=1; end, end, end, dt=time-t0



%% Optim
t0=time; 
[X,Y]=meshgrid(1:n,1:n); 
M = sqrt((X-n/2).^2 + (Y-n/2).^2) <= n/2; 
dt=time-t0


t0=time; n=1000; [X,Y]=meshgrid(1:n,1:n); M = sqrt((X-n/2).^2 + (Y-n/2).^2) <= n/2; dt=time-t0
