%=========================================================================
% MATLAB script file to draw the flownets of a homogeneous isotropic earth   
% embankment dam using the conformal mapping technique
% For further details, go the link below:
% https://github.com/SubhadipN/Conformal_Mapping#seepage-analysis
%=========================================================================
% Prepared by SUBHADIP NASKAR, RESEARCH SCHOLAR, IIT GUWAHATI
%=========================================================================
clear all; clc; warning('off','all')
%=========================================================================
% INPUTS::
hd = 20;            % Height of the dam (m)
hw = 19;            % Height of the water level (m)
twd = 12;           % Top width of the dam (m)
fw = 6;             % Width of the filter (m)
ss = 1/0.5;         % Slope of two sides of the dam (vertical/horizontal)
k = 3.5*10^(-8);    % Coefficient of permeability (m/s)
fl = 15;            % Numbers of flow lines (odd number)
yf = 1.2;           % Depth factor
xf = 1.30;          % Width factor
%=========================================================================
% DERIVED PARAMETERS::
bwd = 2*hd/ss+twd;  % Bottom width of the dam (m)
C = [-bwd+fw+hw/ss hw]; 
xo = 0.5*(C(1)+sqrt(C(1)^2+C(2)^2));
q = 2*k*xo; 
const = -1/(2*k*q);
%=========================================================================
% PLOT OF THE GIVEN EMBANKMENT DAM::
p1 = [-bwd+fw 0]; 
p2 = [p1(1)+hd/ss hd]; 
p3 = [p2(1)+twd hd]; 
p4 = [fw 0];
for i = 1:6
    if i == 1
        x1 = p1(1); y1 = p1(2); x2 = p2(1); y2 = p2(2);
        yy = linspace(y1,y2,2000); 
        xx = 0.5*(q*yy.^2/(k*hw^2)-k*hw^2/q);
        p1(1) = min(xx); 
        p2(1) = max(xx);
    elseif i == 2
        x1 = p2(1); y1 = p2(2); x2 = p3(1); y2 = p3(2);
    elseif i == 3
        x1 = p3(1); y1 = p3(2); x2 = p4(1); y2 = p4(2);
    elseif i == 4
        x1 = 0; y1 = 0; x2 = p1(1); y2 = p1(2);
    elseif i == 5
        x1 = p4(1); y1 = p4(2); x2 = 0; y2 = 0;
    else
        x1 = p2(1)-hw/ss; 
        y1 = hw;  
        x2 = 0.5*(q*y2^2/(k*hw^2)-k*hw^2/q);
        y2 = hw;
    end
    if i ~= 1
        xx = linspace(x1,x2,2000); 
        m = (y2-y1)/(x2-x1); 
        yy = m.*xx-m*x1+y1;
    end
    figure (1);  
    xlim([-bwd/xf xf*fw]); 
    ylim([0 yf*hd]); 
    hold on; box on;
    if i <= 4
        if i == 1
            leg1 = plot(xx,yy,'k','linewidth',1.5);
        else
            plot(xx,yy,'k','linewidth',1.5)
        end
    elseif i == 5
        leg2 = plot(xx,yy,'m','linewidth',6);
    else
        leg3 = plot(xx,yy,'k--','linewidth',1.5);
    end
end
%=========================================================================
% FLOW LINES IN W-PLANE::
x = linspace(-k*hw,0,fl); 
y = linspace(0,q,fl);
for i = 1:fl
    % '||' to x-axis
    xx = linspace(0,-k*hw,100); 
    yx = y(i)*diag(eye(100)); 
    % '||' to y-axis
    xy = x(i)*diag(eye(100)); 
    yy = linspace(0,q,100);     
    wx(i,1:100) = complex(xx,yx'); 
    wy(i,1:100) = complex(xy',yy); 
end
%=========================================================================
% FLOW LINES IN Z-PLANE::
zx = const*wx.^2; 
zy = const*wy.^2;
for i = 1:fl
    leg4 = plot(real(zx(i,:)),imag(zx(i,:)),'b','linewidth',1.5);
    leg5 = plot(real(zy(i,:)),imag(zy(i,:)),'r','linewidth',1.5);
end
xlabel('Width (m)','fontsize',14); 
ylabel('Height (m)','fontsize',14);
title('Flownets of homogeneous isotropic earth-embankment dam section',...
    'fontsize',14);
legend([leg1 leg2 leg3 leg4 leg5],{'Dam outline','Filter','Water level',...
    'Flow lines','Equipotential lines'},'fontsize',14);
set(gca,'FontSize',14);
for i = 1:2:fl
    t1 = ['\phi= ',num2str(x(i))]; 
    t2 = ['\psi= ',num2str(y(i))];
    xc1 = max(real(zy(i,:))); 
    yc1 = max(imag(zy(i,:)));
    ht1 = text(xc1+0.25,yc1,t1,'HorizontalAlignment','left','Color',...
        'r','VerticalAlignment','bottom','fontsize',14); 
    set(ht1,'Rotation',0);
    xc2 = min(real(zx(i,:))); 
    yc2 = max(imag(zx(i,:)));
    ht2 = text(xc2,yc2,t2,'HorizontalAlignment','right','Color','b',...
        'fontsize',14); set(ht2,'Rotation',-45);
end
t = ['z = -0.25w^2/k^2x_0'];
text(-12.5,22.5,t,'HorizontalAlignment','left','Color','k',...
    'fontsize',18)
%=========================================================================
