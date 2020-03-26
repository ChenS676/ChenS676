%%%%%ȥг���������ݴ������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear all; 
clc;
% Add some utility directories to the path
tic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dt  = 0.002; %����ʱ�������������ļ�����
N   = 1001;  %ÿ�����ݵĳ��ȣ��������ļ�����
nt=N;
nx=1;  %ʵ�ʽ�ȡ����
dx=0.005;
M=120;       %�ļ����ܵ������������ļ�����
t=(0:N-1).*dt;
t=t'; 
n=nt*nx;
nsg=zeros(nt,nx);
qumianbo=zeros(nt,nx);
mianbo=zeros(nt,nx);
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
CQ1 =0.85;%Q1ֵ��С���任��ֵȨ��
CQ2 =1.5;%Q2ֵ��С���任��ֵȨ��
Cweight     = struct('CQ1', CQ1, 'CQ2', CQ2);
 thdtype     = 'hard';%��ֵ����
itermax 	= 30;
expdecrease	= 1;      %��ֵ�������Լ�С
lambdastop=5e-1;
sigma      = 5e-3;
display		= 0;

fid = fopen('E:\Radon�任�ֵ�MCAӦ�ó���\MCAsuppressgroundroll\HarmNoisRemv_ȥг��_���ճ���\HarmNoisRemv\ʵ��ԭ����\newgroundmodel.dat','r');%�����ļ�
[ddp,count]=fread(fid,[1001,120],'float');
% fidout1 = fopen('E:\MCAʵ�����ݷ�����\����ģ������newgroundmodel�ķ�����\ȥ�沨��1.sgy','w');%����ļ�
% fidout2 = fopen('E:\MCAʵ�����ݷ�����\����ģ������newgroundmodel�ķ�����\ȥ���沨1.sgy','w');%����ļ�
% fidout3 = fopen('E:\MCAʵ�����ݷ�����\����ģ������newgroundmodel�ķ�����\ԭ�ź�1.sgy','w');%����ļ�
%  noprocessing=zeros(1,M);
     
nsg=ddp(:,65);
   parts = MCA_Bcr(nsg,dictWave1,dictWave2,Cweight,thdtype,itermax,expdecrease,lambdastop,sigma,display,dt);
   nsg1=reshape(nsg,n,1);
   parts(:,1)=nsg1-parts(:,2);
   mianbo=reshape(parts(:,2),nt,nx);
   qumianbo=reshape(parts(:,1),nt,nx);
   yuanshishuju=nsg;
%    fwrite(fidout1,parts(:,1),'float');
%    fwrite(fidout2,parts(:,2),'float');
%    fwrite(fidout3,nsg(:,i),'float');
fclose(fid);
% fclose(fidout1);
% fclose(fidout2);
% fclose(fidout3);
% noprocessing
%  ����ȡ���Ӵ�����
yy=(1:1001)*dt;
toc
figure;plot(yy,yuanshishuju);
figure;plot(yy,mianbo);
figure;plot(yy,qumianbo);
