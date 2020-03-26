function res2 = mtimes(A,x1)
dt=0.002;                             %���ݲ������                        
nt=1001;                              %��������  
dx=0.005;
x=0*dx:dx:59*dx;                          %ƫ�ƾ�
pmax=20;                            %���б�ʻ�����
p=0:pmax/100:pmax;                    %ɨ���б�ʻ�������
np=length(p);
nx=length(x);
if A.adjoint == 0                      %A*x
    x2=reshape(x1,nt,np);
    ress=invfwd_tx_sstackn_linear(x2,dt,p,x);  %ʱ������Radon�任
    res2=reshape(ress,nt*nx,1);
else                                   %At*x
    x2=reshape(x1,nt,nx);
    ress=fwd_tx_sstackn_linear(x2,dt,p,x);     %ʱ������Radon�任
    res2=reshape(ress,nt*np,1);
end