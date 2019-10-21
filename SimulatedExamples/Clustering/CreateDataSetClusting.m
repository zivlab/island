rand('seed',0)
randn('seed',0)

N_1=500;
N_2=500;
N_3=0;
GeneralNoise_N=50;

N_SubClusters1=10;
N_SubClusters2=10;

x_c1=1-0.2;
y_c1=1;

x_c2=1+0.2;
y_c2=2;

x_c3=x_c1+0.8;
y_c3=y_c2+1;

R1=1;
R2=1;
R_noise=0.05;
SD_x_3=0.1;
SD_y_3=0.1;
Y_factor=1; %straching(/squeezing) y vs x 

GeneralNoise_xRange=[0 2];
GeneralNoise_yRange=[0 4];

SubCluser1=randi(N_SubClusters1,1,N_1);
SubCluser2=randi(N_SubClusters2,1,N_2);
% ThetaVec1=pi*rand(1,N_1);
% ThetaVec2=pi+pi*rand(1,N_2);
ThetaVec1=pi*(SubCluser1-1)/(N_SubClusters1-1);
ThetaVec2=pi+pi*(SubCluser2-1)/(N_SubClusters2-1);
RadVec1=R1*ones(1,N_1);
RadVec2=R2*ones(1,N_2);

NoiseSize_tangent_1=0.075;
NoiseSize_radial_1=0.05;
NoiseSize_tangent_2=0.075;
NoiseSize_radial_2=0.05;
Noise_tangent_1=NoiseSize_tangent_1*randn(1,N_1);
Noise_radial_1=NoiseSize_radial_1*randn(1,N_1);
Noise_tangent_2=NoiseSize_tangent_2*randn(1,N_2);
Noise_radial_2=NoiseSize_radial_2*randn(1,N_2);
Noise_X_1=Noise_radial_1.*sin(ThetaVec1)+NoiseSize_tangent_1*cos(ThetaVec1).*randn(1,N_1);
Noise_Y_1=Noise_radial_1.*cos(ThetaVec1)+NoiseSize_tangent_1*sin(ThetaVec1).*randn(1,N_1);
Noise_X_2=Noise_radial_2.*sin(ThetaVec2)+NoiseSize_tangent_2*cos(ThetaVec2).*randn(1,N_2);
Noise_Y_2=Noise_radial_2.*cos(ThetaVec2)+NoiseSize_tangent_2*sin(ThetaVec2).*randn(1,N_2);

X_Vec1=x_c1+RadVec1.*sin(ThetaVec1)+Noise_X_1;
Y_Vec1=(y_c1+RadVec1.*cos(ThetaVec1)+Noise_Y_1)*Y_factor;
X_Vec2=x_c2+RadVec2.*sin(ThetaVec2)+Noise_X_2;
Y_Vec2=(y_c2+RadVec2.*cos(ThetaVec2)+Noise_Y_2)*Y_factor;
X_Vec3=x_c3+SD_x_3*randn(1,N_3);
Y_Vec3=(y_c3+SD_y_3*randn(1,N_3))*Y_factor;

GeneralNoise_X=GeneralNoise_xRange(1)+rand(1,GeneralNoise_N)*(GeneralNoise_xRange(2)-GeneralNoise_xRange(1));
GeneralNoise_Y=(GeneralNoise_yRange(1)+rand(1,GeneralNoise_N)*(GeneralNoise_yRange(2)-GeneralNoise_yRange(1)))*Y_factor;

figure
hold on
plot(X_Vec1,Y_Vec1,'r*')
plot(X_Vec2,Y_Vec2,'b*')
plot(X_Vec3,Y_Vec3,'g*')
plot(GeneralNoise_X,GeneralNoise_Y,'k*')
%axis equal

DataSet_X=[X_Vec1 X_Vec2 X_Vec3 GeneralNoise_X];
DataSet_Y=[Y_Vec1 Y_Vec2 Y_Vec3 GeneralNoise_Y];
DataSet=[DataSet_X' DataSet_Y'];

%%
figure
hold on
plot(X_Vec1,Y_Vec1,'k*')
plot(X_Vec2,Y_Vec2,'k*')
plot(X_Vec3,Y_Vec3,'k*')
plot(GeneralNoise_X,GeneralNoise_Y,'k*')