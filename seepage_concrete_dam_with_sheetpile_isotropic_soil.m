%=========================================================================
% MATLAB script file to draw the flownets of a concrete dam with vertical   
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
b1 = 18; 
b2 = 1.5; 
h1 = 15; 
h2 = 2; 
s = 12;
k = 3.5*10^(-8);    % Coefficient of permeability (m/s)
fl = 17;            % Numbers of flow lines (odd number)
yf = 2.00;          % Depth factor
xf = 2.75;          % Width factor
%=========================================================================
% DERIVED PARAMETERS::
A = [-2*b1 0];
B = [-b1 0];
C = [0 0];
D = [0 -s];
F = [b1 0];
h = h1-h2;
%=========================================================================
% PLOT OF THE GIVEN EMBANKMENT DAM::
for i = 1:9
    if i == 1
        x1 = A(1); y1 = A(2); x2 = F(1); y2 = F(2);
    elseif i == 2
        x1 = B(1); y1 = B(2); x2 = B(1); y2 = a1;
    elseif i == 3
        x1 = B(1); y1 = a1; x2 = B(1)+b2; y2 = a1;
    elseif i == 4
        x1 = B(1)+b2; y1 = a1; x2 = B(1)+b2; y2 = a2;
    elseif i == 5
        x1 = B(1)+b2; y1 = a2; x2 = C(1); y2 = a3;
    elseif i == 6
        x1 = C(1); y1 = a3; x2 = C(1); y2 = C(2);
    elseif i == 7
        x1 = C(1); y1 = C(2); x2 = D(1); y2 = D(2);
    elseif i == 8
        x1 = B(1); y1 = h1; x2 = 1.3*B(1); y2 = h1;
    else
        x1 = C(1); y1 = h2; x2 = -0.3*B(1); y2 = h2;
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
    xlim([-xf*b1 0.8*xf*b1]); 
    ylim([-yf*a1 1.1*a1]); 
    set(gca,'FontSize',16); hold on; box on;
    if i <= 6
        if i == 1
            leg1 = plot(xx,yy,'m','linewidth',1.5);
        else
            plot(xx,yy,'m','linewidth',1.5)
        end
    elseif i == 7
        leg2 = plot(xx,yy,'k','linewidth',4);
    else
        if i == 8
            leg3 = plot(xx,yy,'k--','linewidth',1.5);
        else
            plot(xx,yy,'k--','linewidth',1.5)
        end
    end
end
%=========================================================================
% FLOW LINES IN W-PLANE::
f = 0.4; 
ls = 100; 
x = linspace(-k*h,0,fl); 
y = linspace(0,-f*k*h,fl);
for ii = 1:fl
    % '||' to x-axis
    xx = linspace(0,-k*h,ls); 
    yx = y(ii)*diag(eye(ls)); 
    wx(ii,1:ls) = complex(xx,yx');
    % '||' to y-axis
    xy = x(ii)*diag(eye(ls)); 
    yy = linspace(0,f*k*h,ls); 
    wy(ii,1:ls) = complex(xy',yy); 
end
%=========================================================================
% FLOW LINES IN Z-PLANE::
tb = -sqrt(b1^2+s^2)/s;
tx = 0.5*(1-tb)*cos(pi.*wx/(k*h))+0.5*(1+tb);
ty = 0.5*(1-tb)*cos(pi.*wy/(k*h))+0.5*(1+tb);
zx = -s*sqrt(tx.^2-1); zy = s*sqrt(ty.^2-1);
zx(1,:) = complex(linspace(0,B(1),ls),0); 
zy(1,:) = complex(linspace(B(1),A(1),ls),0);
sz = size(zx);
for jj = 2:sz(1)
    for kk = 1:sz(2)
        if imag(zx(jj,kk)) >= 0
            zx(jj,kk) = -complex(real(zx(jj,kk)),imag(zx(jj,kk)));
        end
        if imag(zy(jj,kk)) >= 0
            zy(jj,kk) = -complex(real(zy(jj,kk)),imag(zy(jj,kk)));
        end
    end
end
for jj = 2:sz(1)
    for kk = 1:sz(2)
        rzy = real(zy(jj,kk)); 
        izy = imag(zy(jj,kk));
        zy(jj,kk) = complex(-rzy,izy);
    end
end
for ii = 1:fl
    leg4 = plot(real(zy(ii,:)),imag(zy(ii,:)),'r','linewidth',1.5);
end
for ii = 1:fl
    leg5 = plot(real(zx(ii,:)),imag(zx(ii,:)),'b--','linewidth',1.5);
end
xlabel('Width (m)','fontsize',16); 
ylabel('Height (m)','fontsize',16)
title('Flownets underneath a concrete dam with a sheetpile (z-plane)',...
    'fontsize',14)
legend([leg1 leg2 leg3 leg4 leg5],{'Dam outline','Sheet pile',...
    'Water level','Equipotential lines','Flow lines'},'Location',...
    'northeast','fontsize',14);
for ii = 1:2:fl
    t1 = ['\phi_{',num2str(ii),'} = ',num2str(x(ii))]; 
    t2 = ['\psi_{',num2str(ii),'} = ',num2str(y(ii))];
    if ii <= (fl+1)/2
        xc1 = min(real(zy(ii,:))); yc1 = min(imag(zy(ii,:)));
        text(xc1,yc1,t1,'HorizontalAlignment','right',...
            'VerticalAlignment','top','Color','r','fontsize',16)
    else
        xc1 = max(real(zy(ii,:))); yc1 = min(imag(zy(ii,:)));
        text(xc1,yc1,t1,'HorizontalAlignment','left',...
            'VerticalAlignment','top','Color','r','fontsize',16)
    end
    if ii == 1
        text(0.5*B(1),0,t2,'HorizontalAlignment','left',...
            'VerticalAlignment','bottom','Color','b','fontsize',16)
    elseif mod((ii+1)/2,2) == 0
        xc2 = max(real(zx(ii,:)));
        h = text(xc2,0.5,t2,'HorizontalAlignment','left','Color','b',...
            'fontsize',16); 
        set(h,'Rotation',90);
    elseif mod((ii+1)/2,2) == 1
        xc2 = min(real(zx(ii,:)));
        h = text(xc2,0.5,t2,'HorizontalAlignment','left','Color','b',...
            'fontsize',16); 
        set(h,'Rotation',90);
    end
end
t3 = ['z = s\surd {(t^2-1)}; ']; 
t4 = ['t = 0.5(1-t_B)cos(\piw/kh)+0.5(1+t_B); ']; 
t5 = ['t_B = \surd ((b/s)^2+1)']; 
text(A(1),1.2*min(min(imag(zy))),[t3 t4 t5],'HorizontalAlignment',...
    'left','Color','k','fontsize',18)
%=========================================================================