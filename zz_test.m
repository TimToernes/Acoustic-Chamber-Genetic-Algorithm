c=5; % speed of wave;
dx=1; % space step;
dt=0.05; % time step;
szx=200;
szy=200; % sizes
tm=1000; % time
k=0.01; % decay factor

x=0:dx:szx;
y=0:dx:szy; % space
t=0:dt:tm; % time

mic = [125,125];
src = [30,5];

Lx=length(x);
Ly=length(y);

u=zeros(Ly,Lx); % initial value
u(src(1),src(2))=100; 
%impmag = 100; 
%g = fspecial('gaussian', 51,7); %seems to spread energy mostly over a 10x10-ish diameter 
%iflt = conv2(g,impmag); 
%u=zeros(Ly,Lx); % initial value 
%u = SubMatrixAdd(u,iflt,128,128); % see the definition of this function below 

uo=u; % previose = curent => velocties =0

[Xim,map] = imread("square.png"); 
Xim = rgb2gray(Xim);
bw = Xim<=0; % boundary 
msk = imdilate(bw, int8(ones(3,3))) & ~bw; 
bck = 1; %reflective attenuation factor of boundary 

close all;
hf=figure;
ha=axes;
hi=imagesc(x,y,u);
colorbar;
set(ha,'clim',[-1 1]);
axis equal;

% cyan colormap:
bl1=linspace(0,1,64)';
bl2=linspace(0.0,1,64)';
bl3=linspace(0.0,0,64)';
bl=[bl3 bl2 bl1];
colormap(bl);

D=[0 1 0; 1 -4 1; 0 1 0]; % 2d laplace operator

kdt=k*dt;
c1=dt^2*c^2/dx^2;
lc=1;
dlc=25;
for tt=t
    
    %if tt<50
    %    u(10,10)=sin(tt)*100;
    %end
    
    u(src(1),src(2)) = u(src(1),src(2)) + rand*2-1;
    
    un=(2-kdt)*u+(kdt-1)*uo+c1*conv2(u,D,'same'); % new
    
    
    
    uo=u; % curent become old
    u=un; % new become current
    
    um = uo(msk)*-bck; %MB: reflect at the BC, that is to say, invert pixels at the BC 
    u(msk)=um; %add reflected pixels from prev time step 
    u(bw)=0; %remove mask pixels not on the one pixel edge of the boundary 
    
    u_plot = u;
    u_plot(bw) = -1;
    u_plot(mic(1),mic(2)) = 1;
    
    if mod(lc-1,dlc)==0
        set(hi,'CData',u_plot);
        drawnow;
    end
    
    output(lc) = u (11,11);
    source(lc) = u(10,10);
    
    lc=lc+1;
end


figure(2)
Y1 = fft(output);

L = length(output);
Fs = 1/dt;
P21 = abs(Y1/L);
P11 = P21(1:L/2+1);
P11(2:end-1) = 2*P11(2:end-1);

f = Fs*(0:(L/2))/L;
plot(f,P11) 
title('Output')
xlabel('f (Hz)')
ylabel('|P1(f)|')

figure(3)
Y2 = fft(source);
P22 = abs(Y2/L);
P12 = P22(1:L/2+1);
P12(2:end-1) = 2*P12(2:end-1);

plot(f,P12) 
title('Source')
xlabel('f (Hz)')
ylabel('|P1(f)|')


hp_out_power = sum(P11(L*0.1+1:end));
hp_in_power = sum(P12(L*0.1+1:end));

fitness = hp_in_power - hp_out_power;


%Helper function, SubMatrixAdd.m 
% function A = SubMatrixAdd(A,B,x,y) 
% %FUNCTION: adds B, smaller than A, into A offset specified by x and y 
% [p,q] = size(B); 
% [m,n] = size(A); 
% if x+p >= m || y+q >= n 
% error('SubMatrixAdd: ''B'' offset out of bounds in A') 
% end 
% A(x:x+p-1, y:y+q-1) = A(x:x+p-1, y:y+q-1)+B; 
% end
