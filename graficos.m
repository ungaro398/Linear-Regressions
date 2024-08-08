clc
clear

B = 0.001*[75:25:500];
V = 0.001*[0.008:0.002:0.02,0.021,0.023:0.002:0.033,0.034,0.037,0.039,0.04;...
    0.017:0.004:0.029,0.032:0.004:0.052,0.055,0.059,0.062,0.067,0.07,0.074,0.078,0.081;...
    0.026,0.032,0.038,0.043,0.049,0.055,0.06,0.066,0.072,0.077,0.083,0.088,0.094,0.1,0.105,0.111,0.117,0.122;...
    0.036,0.043,0.051,0.058,0.066,0.074,0.081,0.088,0.096,0.103,0.111,0.118,0.126,0.133,0.141,0.148,0.156,0.163;...
    -0.02,-0.027,-0.034,-0.042,-0.049,-0.056,-0.064,-0.072,-0.079,-0.086,-0.093,-0.1,-0.108,-0.115,-0.123,-0.13,-0.138,-0.145];
I = 0.001*[10,20,30,40];
e = 1.6*10^(-19);
w = 500*10^(-6);

Vf = [0.0112,0.123];
If = [10.03,10.8];

[p1,s1] = polyfit(B,V(1,:),1);
[p2,s2] = polyfit(B,V(2,:),1);
[p3,s3] = polyfit(B,V(3,:),1);
[p4,s4] = polyfit(B,V(4,:),1);
[p5,s5] = polyfit(B,V(5,:),1);

[Y1,delta1] = polyval(p1,B,s1);
[Y2,delta2] = polyval(p2,B,s2);
[Y3,delta3] = polyval(p3,B,s3);
[Y4,delta4] = polyval(p4,B,s4);
[Y5,delta5] = polyval(p5,B,s5);

n = [I(1)./(p1(1)*e*w),I(2)./(p2(1)*e*w),I(3)./(p3(1)*e*w),I(4)./(p4(1)*e*w),I(4)./(p5(1)*e*w)];
nf = mean(n(1:4));

un = [];
un(1) = n(1)*sqrt((1/w)^2 + (1/e)^2 + (1/p1(1))^2 + (s1.normr)^2 + (1/I(1))^2);
un(2) = n(2)*sqrt((1/w)^2 + (1/e)^2 + (1/p2(1))^2 + (s2.normr)^2 + (1/I(2))^2);
un(3) = n(3)*sqrt((1/w)^2 + (1/e)^2 + (1/p3(1))^2 + (s3.normr)^2 + (1/I(3))^2);
un(4) = n(4)*sqrt((1/w)^2 + (1/e)^2 + (1/p4(1))^2 + (s4.normr)^2 + (1/I(4))^2);
un(5) = n(5)*sqrt((1/w)^2 + (1/e)^2 + (1/p5(1))^2 + (s5.normr)^2 + (1/I(4))^2);

RH = 1./(e*n(1:4));
uRH = RH.*sqrt((1/e)^2 + (1./n(1:4)).^2 + un(1:4).^2);

errB = 0.001*ones(size(B));
errV = 0.000001*ones(size(V(1,:)));

figure(1);
errorbar(B,V(1,:),errV,errV,errB,errB,'.r','MarkerSize',8);
hold on;
errorbar(B,V(2,:),errV,errV,errB,errB,'.g','MarkerSize',8);
errorbar(B,V(3,:),errV,errV,errB,errB,'.b','MarkerSize',8);
errorbar(B,V(4,:),errV,errV,errB,errB,'.c','MarkerSize',8);
plot(B,Y1,'red',B,Y2,'green',B,Y3,'blue',B,Y4,'cyan');
xlabel('Campo Magnético [mT]');
ylabel('Tensão Hall [V]');
legend('10 mA','20 mA','30 mA','40 mA');
grid on;
hold off;
saveas(figure(1),'graficoHall.png');

figure(2);
errorbar(B,V(5,:),errV,errV,errB,errB,'.r','MarkerSize',8);
hold on;
plot(B,Y5,'red');
xlabel('Campo Magnético [mT]');
ylabel('Tensão Hall [V]');
legend('40 mA');
grid on;
hold off;
saveas(figure(2),'graficoHall_180.png');

R1 = Vf(1)/If(1);
R2 = Vf(2)/If(2);

ro = (pi*w*(R1+R2))/(log(2)*2);
mu = 1/(ro*e*nf);