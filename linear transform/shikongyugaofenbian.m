clc;clear all;close all;
%demo  Ƶ����߷ֱ�Radon�任
%%%%%%%%%%%%%ģ�����ݲ���
dt=0.002;
nt=2000;
dx=0.005;
nx=429;
R=zeros(nt,nx);
R1=zeros(nt,nx);
x=(1:nx)*dx;
t1=1.*(x-215*dx).^2+300*dt;t2=0.8.*(x-215*dx).^2+600*dt;t3=0.6.*(x-215*dx).^2+900*dt;
t7=20.*(x-90*dx).^2+700*dt;t8=20.*(x-90*dx).^2+1000*dt;t9=20.*(x-90*dx).^2+1300*dt;
k1=fix(t1./dt);k2=fix(t2./dt);k3=fix(t3./dt);
k7=fix(t7./dt);k8=fix(t8./dt);k9=fix(t9./dt);
for i=1:nx
 R(k1(i),i)=1;
 R(k2(i),i)=-1;
 R(k3(i),i)=1;
end
for i=1:nx
     if k7(i)<= nt
        R1(k7(i),i)=2;
     end
     if k8(i)<= nt
        R1(k8(i),i)=2;
     end
     if k9(i)<= nt
        R1(k9(i),i)=2;
     end
end
 %figure
% pcolor(R1),shading interp;set(gca,'XAxisLocation','top');axis ij;
t=(0:nt-1).*dt;
f=30;
s=(1-2*pi^2*f^2.*(t-nt*dt/2).^2).*exp(-pi^2*f^2.*(t-nt*dt/2).^2);  
f=30;
s1=(1-2*pi^2*f^2.*(t-nt*dt/2).^2).*exp(-pi^2*f^2.*(t-nt*dt/2).^2);
%s1=0.5*sin(2*pi*5*(t-nt*dt/2));
% figure
% plot(t,s)
for i=1:nx
    RR(:,i)=conv(s,R(:,i));
end
% for i=1:179
%     RR1(:,i)=conv(s1,R1(:,i));
% end
% for i=180:nx
%      RR1(:,i)=0;
% end
 for i=1:90
     RR1(:,i)=conv(i/90*s1,R1(:,i));
 end
 for i=91:179
     RR1(:,i)=conv((180-i)/90*s1,R1(:,i));
 end
 for i=180:nx
     RR1(:,i)=0;
 end
data=RR(1000:999+2000,:);
data1=RR1(1000:999+2000,:);
d1=data;
d2=data1;
d3=data+data1;
trace=(1:nx);
figure  
pcolor(trace,t,d3),shading interp;set(gca,'XAxisLocation','top');axis ij;
set(gcf, 'Renderer', 'ZBuffer');
xlabel('����');ylabel('ʱ��/s');
figure
plot(t,d3(:,30))
xlabel('ʱ��/s');ylabel('��ֵ');
x=-214*dx:dx:214*dx;
pmax=1.6;
p=0:pmax/100:pmax;
%%%%%%%%%%%%%%%ʱ����߷ֱ���Radon�任%%%%%%%%%%%%%%%%%%%
m=cgnr_radon(d3,dt,x,p); %ʱ����߷ֱ���Radon�任
figure
pcolor(p,t,m),shading interp;set(gca,'XAxisLocation','top');axis ij;
set(gcf, 'Renderer', 'ZBuffer');
xlabel('ɨ��б��');ylabel('ʱ��/s');
figure
wigb(m);
set(gcf, 'Renderer', 'ZBuffer');
xlabel('ɨ��б��/dp');ylabel('��������/s');
[mm,xv,yv]=qushuju(m);    %���ݵ��г�
b1=invfwd_tx_sstackn(mm,dt,p,x) ; %���г�����������任
figure
pcolor(trace,t,b1),shading interp;set(gca,'XAxisLocation','top');axis ij;
set(gcf, 'Renderer', 'ZBuffer');
xlabel('����');ylabel('ʱ��/s');
figure
wigb(m);
set(gcf, 'Renderer', 'ZBuffer');
xlabel('ɨ��б��/dp');ylabel('��������/s');
[mm,xv,yv]=qushuju(m);    %���ݵ��г�
b2=invfwd_tx_sstackn(mm,dt,p,x) ; %���г�����������任
figure
pcolor(trace,t,b2),shading interp;set(gca,'XAxisLocation','top');axis ij;
set(gcf, 'Renderer', 'ZBuffer');
xlabel('����');ylabel('ʱ��/s');
figure
wigb(m);
set(gcf, 'Renderer', 'ZBuffer');
xlabel('ɨ��б��/dp');ylabel('��������/s');
[mm,xv,yv]=qushuju(m);    %���ݵ��г�
b3=invfwd_tx_sstackn(mm,dt,p,x) ; %���г�����������任
figure
pcolor(trace,t,b3),shading interp;set(gca,'XAxisLocation','top');axis ij;
set(gcf, 'Renderer', 'ZBuffer');
xlabel('����');ylabel('ʱ��/s');
b=b1+b2+b3;
figure
pcolor(trace,t,b),shading interp;set(gca,'XAxisLocation','top');axis ij;
set(gcf, 'Renderer', 'ZBuffer');
xlabel('����');ylabel('ʱ��/s');
figure
pcolor(trace,t,d3-b),shading interp;set(gca,'XAxisLocation','top');axis ij;
set(gcf, 'Renderer', 'ZBuffer');
xlabel('����');ylabel('ʱ��/s');