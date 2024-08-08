clc
clear

import mlreportgen.report.*
import mlreportgen.dom.*

dados1 = importdata('dadosT-4.txt');
dados2 = importdata('dadosT25.txt');
dados3 = importdata('dadosT52.txt');

T = [-4, 25, 52];
T = T + 273.15;

y1 = log(dados1.data(:,2));
y2 = log(dados2.data(:,2));
y3 = log(dados3.data(:,2));

x1 = dados1.data(:,1);
x2 = dados2.data(:,1);
x3 = dados3.data(:,1);

erry1 = 0.01*ones(size(y1));
erry2 = 0.01*ones(size(y2));
erry3 = 0.01*ones(size(y3));

errx1 = 0.0001*ones(size(x1));
errx2 = 0.0001*ones(size(x2));
errx3 = 0.0001*ones(size(x3));

[p1,s1] = polyfit(x1,y1,1);
[p2,s2] = polyfit(x2,y2,1);
[p3,s3] = polyfit(x3,y3,1);

ek1 = p1(1)*(T(1));
ek2 = p2(1)*(T(2));
ek3 = p3(1)*(T(3));

uek1 = ek1*sqrt((1/T(1))^2 + (s1.normr/p1(1))^2);
uek2 = ek2*sqrt((1/T(2))^2 + (s2.normr/p2(1))^2);
uek3 = ek3*sqrt((1/T(3))^2 + (s3.normr/p3(1))^2);

mediaek = (ek1+ek2+ek3)/3;
mediauek = sqrt(uek1^2+uek2^2+uek3^3);

k1 = (1.6e-19)/ek1;
k2 = (1.6e-19)/ek2;
k3 = (1.6e-19)/ek3;

uk1 = k1*sqrt((1/T(1))^2 + (s1.normr/p1(1))^2);
uk2 = k2*sqrt((1/T(1))^2 + (s1.normr/p1(1))^2);
uk3 = k3*sqrt((1/T(1))^2 + (s1.normr/p1(1))^2);

mediak = (k1+k2+k3)/3;
mediauk = sqrt(uk1^2+uk2^2+uk3^3);

figure(1);
[Y1,delta1] = polyval(p1,x1,s1);
errorbar(x1,y1,errx1,errx1,erry1,erry1,'.','MarkerSize',8);
hold on;
plot(x1,Y1);
title('Determinação de e/k em -4ºC');
xlabel('V_{eb} (V)');
ylabel('ln(I_c) (\mu A)');
legend('Pontos','Ajuste; $\alpha=$41,92$\pm$0,25','Interpreter','latex','Location','northwest');
grid on;
hold off;
saveas(figure(1),'graficoT-4.png');

figure(2);
[Y2,delta2] = polyval(p2,x2,s2);
errorbar(x2,y2,errx2,errx2,erry2,erry2,'.','MarkerSize',8);
hold on;
plot(x2,Y2);
title('Determinação de e/k em 25ºC');
xlabel('V_{eb} (V)');
ylabel('ln(I_c) (\mu A)');
legend('Pontos','Ajuste; $\alpha=$38,41$\pm$0,33','Interpreter','latex','Location','northwest');
grid on;
hold off;
saveas(figure(2),'graficoT25.png');

figure(3);
[Y3,delta3] = polyval(p3,x3,s3);
errorbar(x3,y3,errx3,errx3,erry3,erry3,'.','MarkerSize',8);
hold on;
plot(x3,Y3);
title('Determinação de e/k em 52ºC');
xlabel('V_{eb} (V)');
ylabel('ln(I_c) (\mu A)');
legend('Pontos','Ajuste; $\alpha=$30,37$\pm$0,25','Interpreter','latex','Location','northwest');
grid on;
hold off;
saveas(figure(3),'graficoT52.png');

rpt = Report('Relatório dos graficos de ek','pdf');

tp = TitlePage();
tp.Title = 'Relatório doa Gráficos de ek';
tp.Author = 'Lucas Almeida de Ungaro';
tp.PubDate = date();

add(rpt,tp);

append(rpt,TableOfContents);

ch = Chapter('Ajustes com Distribuição de Pontos em Reta');

imagePath = which('graficoT-4.png');
img1 = Image(imagePath);
img1.Style = [img1.Style {ScaleToFit}];
append(ch,Section('Title','Gráfico para T-4','Content',img1));
append(ch,"e/k(1) = ");
append(ch,Section('Content',ek1));
append(ch,"u(e/k(1)) = ");
append(ch,Section('Content',uek1));
append(ch,"k(1) = ");
append(ch,Section('Content',k1));
append(ch,"uk(1) = ");
append(ch,Section('Content',uk1));

imagePath = which('graficoT25.png');
img2 = Image(imagePath);
img2.Style = [img2.Style {ScaleToFit}];
append(ch,Section('Title','Gráfico para T25','Content',img2));
append(ch,"e/k(2) = ");
append(ch,Section('Content',ek2));
append(ch,"u(e/k(2)) = ");
append(ch,Section('Content',uek2));
append(ch,"k(2) = ");
append(ch,Section('Content',k2));
append(ch,"uk(2) = ");
append(ch,Section('Content',uk2));

imagePath = which('graficoT52.png');
img3 = Image(imagePath);
img3.Style = [img3.Style {ScaleToFit}];
append(ch,Section('Title','Gráfico para T52','Content',img3));
append(ch,"e/k(3) = ");
append(ch,Section('Content',ek3));
append(ch,"u(e/k(3)) = ");
append(ch,Section('Content',uek3));
append(ch,"k(3) = ");
append(ch,Section('Content',k3));
append(ch,"uk(3) = ");
append(ch,Section('Content',uk3));

append(rpt,ch);

ch2 = Chapter('Médias');

append(ch2,"e/k = ");
append(ch2,Section('Content',mediaek));
append(ch2,"u(e/k) = ");
append(ch2,Section('Content',mediauek));
append(ch2,"k = ");
append(ch2,Section('Content',mediak));
append(ch2,"u(k) = ");
append(ch2,Section('Content',mediauk));

append(rpt,ch2);

close(rpt);
rptview(rpt);
