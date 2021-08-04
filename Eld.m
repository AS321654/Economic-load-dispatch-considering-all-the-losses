clc
clear all
close all
data=[85    10    200     7.0   0.008;
      80    10    180     6.3   0.009;
      70    10    140     6.8   0.007];
B=[0.0218 0.0093 0.0028;
   0.0093 0.0228 0.0017;
   0.0028 0.0017 0.0179];
B0=[0.0003 0.0031 0.0015];
B = B/100;
B00 = 0.00030523*100;
a=data(:,3);
b=data(:,4);
c=data(:,5);
Pmin=data(:,2);
Pmax=data(:,1);
lambda=input('Enter the assumed value of lambda : \n');
p=zeros(3,1);
loss=0;
demand=input('Enter the demand : \n');
dp=1;
iter=0;
fprintf('Itr    lambda      P1      P2             P3            T_Cost\n')
%Generations based on Incremental cost
y = B;
for i=1:3
    y(i,i) = y(i,i)+(c(i)/lambda);
end
I = ones(3,1);
x = 0.5*(I-B0'-(b./lambda));
p = y\x;
P= zeros(3,1);
while abs(dp)>.0001
    loss = 0;
    iter=iter+1;
    j = 1;
  while j~=3
        P(1)=(lambda*(1-B0(1))-b(1)-2*lambda*(B(1,2)*p(2)+B(1,3)*p(3)))/(2*(c(1)+lambda*B(1,1)));
        P(2)=(lambda*(1-B0(2))-b(2)-2*lambda*(B(2,3)*p(3)+B(2,1)*p(1)))/(2*(c(2)+lambda*B(2,2)));
        P(3)=(lambda*(1-B0(3))-b(3)-2*lambda*(B(3,1)*p(1)+B(3,2)*p(2)))/(2*(c(3)+lambda*B(3,3)));
          for i=1:3  
              if(P(i)<Pmin(i))
                  P(i) = Pmin(i);
              end
              if(P(i)>Pmax(i))
                  P(i) = Pmax(i);
              end
          end
      dp1=P(1)-p(1);
      dp2=P(2)-p(2);
      dp3=P(3)-p(3);
      p(3)=P(3);
      p(1)=P(1);
      p(2)=P(2);
      if(abs(dp1)<0.001&&abs(dp2)<0.001&&abs(dp3)<0.001)
          j=3;
      end
  end
      s = 0;
      q = 0;
       for i=1:3
         for j=1:3
          s=s+B(i,j)*p(i)*p(j);
         end 
          q=q+B0(i)*p(i);
       end
      loss=s+q+B00;
    dp=demand+loss-sum(p);
    s=0;
    k=0;
    for i=1:3
        for j=1:3
            if(i~=j)
            s = s+B(i,j)*p(j);
            end
        end
    end
    for i=1:3
      k=k+(c(i)*(1-B0(i))+B(i,i)*b(i)-2*c(i)*s)/(2*(c(i)+lambda*B(i,i))^2);
    end
    dl=dp/k;
    lambda=lambda+dl;
    F1 = 0.008*p(1)^2+7.0*p(1)+200;
    F2 = 0.009*p(2)^2+6.3*p(2)+180;
    F3 = 0.007*p(3)^2+6.8*p(3)+140;
    T_Cost(iter)=F1+F2+F3;
    fprintf('%d\t %f\t %f\t %f\t %f\t %f\t\n',iter,lambda,P(1),P(2),P(3),T_Cost(iter))
end
disp('Value of P1, P2 &P3 for economic scheduling is ');
disp(p);
disp('Total no. of iteration required')
disp(iter);
disp('Final value of incremental cost(lambda) is ');
disp(lambda);
disp('Total losses')
disp(loss)
disp('Cost of generation')
fprintf('%f\n',T_Cost(iter))
x = 0:iter-1;
plot(x,T_Cost)
xlabel('No. of iterations');
ylabel('Total Fuel Cost');
grid on
