I = imread('im01.jpg');

I=rgb2gray(I);
Ie=edge(I,'canny');

[H,W]=size(Ie);
N=90;
thetaArray=-N:N-1;
rho_max=floor(sqrt(H^2 + W^2)) - 1;
rhoArray=-rho_max:rho_max;
hgh=zeros(length(rhoArray),length(thetaArray)+1);

for y=1:H    
    for x=1:W       
        if(Ie(y,x)==1)
            for t=thetaArray
                rho=round(x*cosd(t)+y*sind(t));
                r_index=rho+rho_max+1;
                t_index=t+N+1;                
                hgh(r_index,t_index)=hgh(r_index,t_index)+1;                            
            end
        end
    end
end

imshow(hgh,[],'XData',thetaArray,'YData',rhoArray,'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;

thold=ceil(0.3*max(hgh(:)));
numberOfPeaks=5;
peakIndexList=zeros(numberOfPeaks,2);
peakNumberList=zeros(numberOfPeaks,1);

for i=1:numberOfPeaks    
    maximum = max(max(hgh));
    [x_max,y_max]=find(hgh==maximum);
    if(hgh(x_max,y_max)>thold)
        peakIndexList(i,1)=x_max;
        peakIndexList(i,2)=y_max;
        peakNumberList(i)=hgh(x_max,y_max);
        hgh(x_max,y_max)=0;
    end
end
for k=1:numberOfPeaks   
    xx=peakIndexList(k,1);
    yy=peakIndexList(k,2);
    hgh(xx,yy)=peakNumberList(k);
end

rhoL=zeros(5,1);
thetaL=zeros(5,1);

mL=zeros(5,1);
cL=zeros(5,1);
    
figure, imshow(I), hold on
for z=1:5    
    
    rhoIndex=peakIndexList(z,1);
    thetaIndex=peakIndexList(z,2);    
    rhoL(z)=rhoArray(rhoIndex-1);
    thetaL(z)=thetaArray(thetaIndex);
    
    mL(z)=-cotd(thetaL(z));
    cL(z)=rhoL(z)*(1/(sind(thetaL(z))));    
    x=1:1000;
    
    plot(x, mL(z)*x+cL(z),'LineWidth',1,'Color','red');
end