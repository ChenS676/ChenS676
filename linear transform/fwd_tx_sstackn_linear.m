function m=fwd_tx_sstackn_linear(d,dt,p,x)
%��ԭʼ����d��ʱ������Radon�任
%���������
%d:��ά����  dt:�������  x:ƫ�ƾ�  p:ɨ��б�ʻ�������
%���������
%m:Radon����
nt=size(d,1);
np=length(p);
nx=length(x);
tz=0:dt:(nt-1)*dt;                         %ʱ���
data=zeros(nt,np);
for i=1:np
    for j=1:nt
        for k=1:nx
            t=tz(j)+p(i)*x(k);               %����·��Ϊֱ��
            % t=sqrt(tz(j)^2+p(i)^2*x(k)^2);   %����·��Ϊ˫����
           %t=tz(j)+p(i).^2*x(k).^2;         %����·��Ϊ������
            tc=t/dt;
            itc=floor(tc);
            it=itc+1;
            fra=tc-itc;
            if it>0&&it<nt
                 data(j,i)=data(j,i)+(1.-fra)*d(it,k)+fra*d(it+1,k);      %���Բ�ֵ
            end
        end
    end
end
m=data;                 