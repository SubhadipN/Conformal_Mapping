%=========================================================================
% MATLAB script file to draw the flownets of a concrete dam without any   
% sheetpile using the conformal mapping technique
%=========================================================================
% Prepared by SUBHADIP NASKAR, RESEARCH SCHOLAR, IIT GUWAHATI
%=========================================================================
clear all; clc; warning('off','all')
%=========================================================================
% INPUTS::
a1 = 20; 
a2 = 18; 
a3 = 4.5; 
b1 = 9; 
b2 = 1.5; 
h1 = 15; 
h2 = 2;
k = 3.5*10^(-8);    % Coefficient of permeability (m/s)
fl = 15;            % Numbers of flow lines (odd number)
yf = 2.00;          % Depth factor
xf = 5.35;          % Width factor
%=========================================================================
% DERIVED PARAMETERS::
A = -2*b1; 
B = -b1; 
C = b1; 
D = 2*b1; 
h = h1-h2;
%=========================================================================
% PLOT OF THE GIVEN EMBANKMENT DAM::
for i = 1:8
    if i == 1
        x1 = A; y1 = 0; x2 = D; y2 = 0;
    elseif i == 2
        x1 = B; y1 = 0; x2 = B; y2 = a1;
    elseif i == 3
        x1 = B; y1 = a1; x2 = B+b2; y2 = a1;
    elseif i == 4
        x1 = B+b2; y1 = a1; x2 = B+b2; y2 = a2;
    elseif i == 5
        x1 = B+b2; y1 = a2; x2 = C; y2 = a3;
    elseif i == 6
        x1 = C; y1 = a3; x2 = C; y2 = 0;
    elseif i == 7
        x1 = B; y1 = h1; x2 = A; y2 = h1;
    else
        x1 = C; y1 = h2; x2 = D; y2 = h2;
    end
    if x1 ~= x2
        xx = linspace(x1,x2,200); 
        m = (y2-y1)/(x2-x1); 
        yy = m.*xx-m*x1+y1;
    else
        yy = linspace(y1,y2,200); 
        xx = x1*diag(eye(length(yy)))';
    end
    figure (1); 
    frame_h = get(handle(gcf),'JavaFrame');
    set(frame_h,'Maximized',1); 
    xlim([-xf*b1 xf*b1]); 
    ylim([-yf*a1 1.1*a1]); 
    set(gca,'FontSize',16); hold on; box on;
    if i <= 6
        if i == 1
            leg1 = plot(xx,yy,'k','linewidth',1.5);
        else
            plot(xx,yy,'k','linewidth',1.5)
        end
    else
        if i == 7
            leg2 = plot(xx,yy,'k--','linewidth',1.5);
        else
            plot(xx,yy,'k--','linewidth',1.5)
        end
    end
end
%=========================================================================
% FLOW LINES IN W-PLANE::
f = 0.65; 
x = linspace(-k*h,0,fl); 
y = linspace(0,-f*k*h,fl);
for i = 1:fl
    % '||' to x-axis
    xx = linspace(0,-k*h,100); 
    yx = y(i)*diag(eye(100)); 
    % '||' to y-axis
    xy = x(i)*diag(eye(100)); 
    yy = linspace(0,-f*k*h,100); 
    wx(i,1:100) = complex(xx,yx'); 
    wy(i,1:100) = complex(xy',yy); 
end
%=========================================================================
% FLOW LINES IN Z-PLANE::
zx = b1*cos(pi.*wx/(k*h)); 
zy = b1*cos(pi.*wy/(k*h));
sz = size(zx);
for jj = 1:sz(1)
    for kk = 1:sz(2)
        if imag(zx(jj,kk)) >= 0
            zx(jj,kk) = complex(real(zx(jj,kk)),0);
        end
    end
end
for i = 1:fl
    leg3 = plot(real(zx(i,:)),imag(zx(i,:)),'b','linewidth',1.5);
    leg4 = plot(real(zy(i,:)),imag(zy(i,:)),'r','linewidth',1.5);
end
xlabel('Width (m)','fontsize',16); 
ylabel('Height (m)','fontsize',16)
title('Flownets underneath a flat-buttomed hydraulic structure (z-plane)',...
    'fontsize',16)
legend([leg1 leg2 leg3 leg4],{'Dam outline','Water level','Flow lines',...
    'Equipotential lines'},'fontsize',16)
for i = 1:2:fl
    t1 = ['\phi_{',num2str(i),'} = ',num2str(x(i))]; 
    t2 = ['\psi_{',num2str(i),'} = ',num2str(y(i))];
    if i <= (fl+1)/2
        xc1 = min(real(zy(i,:))); yc1 = min(imag(zy(i,:)));
        text(xc1,yc1,t1,'HorizontalAlignment','right',...
            'VerticalAlignment','top','Color','r','fontsize',16)
    else
        xc1 = max(real(zy(i,:))); yc1 = min(imag(zy(i,:)));
        text(xc1,yc1,t1,'HorizontalAlignment','left',...
            'VerticalAlignment','top','Color','r','fontsize',16)
    end
    if i == 1
        text(0,0,t2,'HorizontalAlignment','left','VerticalAlignment',...
            'bottom','Color','b','fontsize',16)
    elseif i ~= 3
        xc2 = min(real(zx(i,:)));
        ht = text(xc2,0.5,t2,'HorizontalAlignment','left','Color','b',...
            'fontsize',16); set(ht,'Rotation',90);
    end
end
t = ['z = b_1cos(\piw/kh)'];
text(0.75*xc1,min(min(imag(zy))),t,'HorizontalAlignment','left',...
    'Color','k','fontsize',18)
%=========================================================================