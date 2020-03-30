close all; clear all; 
clc; clear classes
addpath  C:\Users\strohwitwer\Documents\Mein Folder\Ground-roll-removal-through-MCA\radon_transform

%% Initialization of parameter, length of shot M, length of time series N, dt sampling rate, shot distance dx, length of shot used to process
dt  = 0.002; N = 1001; nt=N;  nx=60;  dx=0.005;        
t=(0:nt-1).*dt; t=t'; 


% bw=zeros(nt,nx);
% filt_bw=zeros(nt,nx); % decomposed body wave
% gr=zeros(nt,nx);
% filt_gr=zeros(nt,nx);  % decomposed ground roll
% 


np = 100;
% The value of Q is small
pmax1=5;
p1=0:pmax1/np:pmax1;
x1=0*dx:dx:(nx-1)*dx;
np1 = length(p1);
dictWave1 = struct('p1', p1,'x1',x1);

% The value of Q is large
pmax2=20;
p2=0:pmax2/np:pmax2;
x2=0*dx:dx:(nx-1)*dx;
np2 = length(p2);
dictWave2 = struct('p2', p2,'x2',x2);

% Bodywave/groundroll separation
CQ1 =0.3;
CQ2 =3; 
Cweight     = struct('CQ1', CQ1, 'CQ2', CQ2);
thdtype     = 'Soft'; % iterativ hard threshold 
itermax 	= 30;
expdecrease	= 1;      %threshold decreases linearly
lambdastop=5e-1;
sigma      = 5e-5;
display		= 1;

fid = fopen('data\newgroundmodel.dat','r');
[ddp,~]=fread(fid,[1001,120],'float');
    
%% Call the BCR to sovle the optimization problem   
Para_1 = struct('dt',dt,'nt',nt,'t',t,'dx',dx,'nx',nx,'x',x1,'p',p1,'np',np1,'pmax',pmax1);
Para_2 = struct('dt',dt,'nt',nt,'t',t,'dx',dx,'nx',nx,'x',x2,'p',p2,'np',np2,'pmax',pmax2);
rawdata=ddp(:,61:120);
parts = MCA_Bcr_Radon(rawdata,dictWave1,dictWave2,Cweight,thdtype,itermax,expdecrease,lambdastop,sigma,display,Para_1,Para_2);
  

parts(:,1)= reshape(rawdata,nt*nx,1)-parts(:,2);
gr=reshape(parts(:,2),nt,nx);
bw=reshape(parts(:,1),nt,nx);

for i=1:nx
   fre1=200/(1/dt/2);
   [B,A]=butter(8,fre1,'low');
   filt_gr(1:N,i)=filtfilt(B,A,gr(1:N,i));
end

for i=1:nx
   fre1=30/(1/dt/2);
   [B,A]=butter(8,fre1,'low');
   filt_bw(1:N,i)=filtfilt(B,A,bw(1:N,i)); % dec_dw
end

fclose(fid);
%% plot
xx=1:60;
yy=(1:1001)*dt;
figure;pcolor(xx,yy,gr);colormap('gray');shading interp; set(gca,'XAxisLocation','top');axis ij;xlabel('Trace No.');ylabel('Time(s)');title('(a)');
figure;pcolor(xx,yy,bw);colormap('gray');shading interp; set(gca,'XAxisLocation','top');axis ij;xlabel('Trace No.');ylabel('Time(s)');title('(b)');
figure;pcolor(rawdata);colormap('gray');shading interp; set(gca,'XAxisLocation','top');axis ij;xlabel('Trace No.');ylabel('Time(s)');
figure;pcolor(xx,yy,filt_gr);colormap('gray');shading interp; set(gca,'XAxisLocation','top');axis ij;xlabel('Trace No.');ylabel('Time(s)');title('(a)');
figure;pcolor(xx,yy,filt_bw);colormap('gray');shading interp; set(gca,'XAxisLocation','top');axis ij;xlabel('Trace No.');ylabel('Time(s)');title('(b)');
figure;plot(yy,rawdata(:,5));
figure;plot(yy,filt_gr(:,5));
figure;plot(yy,filt_bw(:,5));