%%%%%����ģ���沨������ݴ������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear all; 
clc;
% Add some utility directories to the path
tic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fidin = fopen('E:\MCAtiaoshichengxu\HarmNoisRemv_ȥг��_���ճ���\HarmNoisRemv\ʵ����\shot5660_pc_31871_33189.sgy','r');
% 
% volume_head = fread(fidin,[3600,1],'*uchar');%%%%%��3600�ֽھ�ͷ

dt  = 0.002; %����ʱ�������������ļ�����
N   = 1001;  %ÿ�����ݵĳ��ȣ��������ļ�����
nt=N;
nx=60;  %ʵ�ʽ�ȡ����
dx=0.005;
M=120;       %�ļ����ܵ������������ļ�����
t=(0:N-1).*dt;
t=t'; 
n=nt*nx;
nsg=zeros(nt,nx);
qumianbo=zeros(nt,nx);
qumianbonew=zeros(nt,nx);
mianbo=zeros(nt,nx);
mianbonew=zeros(nt,nx);
yuanshishuju=zeros(nt,nx);
% for i=1:M
%     trace_head = fread(fidin, [240,1], '*uchar');%%%%%��240�ֽڵ�ͷ
% %    
%      nsg(:,i)=fread(fidin,[N,1],'float');
%  end
% fclose(fidin);
% 
% fnq  = 1/dt/2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The value of Q is small
pmax1=5;
p1=0:pmax1/100:pmax1;
x1=0*dx:dx:59*dx;
dictWave1 = struct('p1', p1,'x1',x1);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% The value of Q is large
pmax2=20;
p2=0:pmax2/100:pmax2;
x2=0*dx:dx:59*dx;
dictWave2 = struct('p2', p2,'x2',x2);
% Bodywave/groundroll separation
% Call the BCR to sovle the optimization problem   
CQ1 =0.3;%Q1ֵ��С���任��ֵȨ��
CQ2 =3;  %Q2ֵ��С���任��ֵȨ��
Cweight     = struct('CQ1', CQ1, 'CQ2', CQ2);
 thdtype     = 'hard';%��ֵ����
itermax 	= 30;
expdecrease	= 1;      %��ֵ�������Լ�С
lambdastop=5e-1;
sigma      = 5e-5;
display		= 0;

fid = fopen('E:\ʱ����Radon�任�ֵ�MCAӦ�ó���\MCAsuppressgroundroll\HarmNoisRemv_ȥг��_���ճ���\HarmNoisRemv\ʵ��ԭ����\newgroundmodel.dat','r');%�����ļ�
[ddp,count]=fread(fid,[1001,120],'float');
% fidout1 = fopen('E:\MCAʵ�����ݷ�����\����ģ������newgroundmodel�ķ�����\ȥ�沨��1.sgy','w');%����ļ�
% fidout2 = fopen('E:\MCAʵ�����ݷ�����\����ģ������newgroundmodel�ķ�����\ȥ���沨1.sgy','w');%����ļ�
% fidout3 = fopen('E:\MCAʵ�����ݷ�����\����ģ������newgroundmodel�ķ�����\ԭ�ź�1.sgy','w');%����ļ�
%  noprocessing=zeros(1,M);
     
nsg=ddp(:,61:120);
   parts = MCA_Bcr_Radon(nsg,dictWave1,dictWave2,Cweight,thdtype,itermax,expdecrease,lambdastop,sigma,display,dt);
   nsg1=reshape(nsg,n,1);
   parts(:,1)=nsg1-parts(:,2);
   mianbo=reshape(parts(:,2),nt,nx);
   for i=1:nx
       fre1=200/(1/dt/2);
       [B,A]=butter(8,fre1,'low');
       mianbonew(1:N,i)=filtfilt(B,A,mianbo(1:N,i));
   end
   qumianbo=reshape(parts(:,1),nt,nx);
   for i=1:nx
       fre1=30/(1/dt/2);
       [B,A]=butter(8,fre1,'low');
       qumianbonew(1:N,i)=filtfilt(B,A,qumianbo(1:N,i));
   end
   yuanshishuju=nsg;

fclose(fid);
xx=1:60;
yy=(1:1001)*dt;
figure;pcolor(xx,yy,mianbo);colormap('gray');shading interp; set(gca,'XAxisLocation','top');axis ij;xlabel('Trace No.');ylabel('Time(s)');title('(a)');
figure;pcolor(xx,yy,qumianbo);colormap('gray');shading interp; set(gca,'XAxisLocation','top');axis ij;xlabel('Trace No.');ylabel('Time(s)');title('(b)');
figure;pcolor(yuanshishuju);colormap('gray');shading interp; set(gca,'XAxisLocation','top');axis ij;xlabel('Trace No.');ylabel('Time(s)');
figure;pcolor(xx,yy,mianbonew);colormap('gray');shading interp; set(gca,'XAxisLocation','top');axis ij;xlabel('Trace No.');ylabel('Time(s)');title('(a)');
figure;pcolor(xx,yy,qumianbonew);colormap('gray');shading interp; set(gca,'XAxisLocation','top');axis ij;xlabel('Trace No.');ylabel('Time(s)');title('(b)');
toc
figure;plot(yy,yuanshishuju(:,5));
figure;plot(yy,mianbonew(:,5));
figure;plot(yy,qumianbonew(:,5));