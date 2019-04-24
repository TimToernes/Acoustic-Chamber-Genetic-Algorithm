function Population = gacreateWave(GenomeLength,FitnessFcn,options)

[Xim1,~] = imread("1.png"); 
Xim1 = rgb2gray(Xim1);
Xim1 = Xim1(:)';

[Xim2,~] = imread("2.png"); 
Xim2= rgb2gray(Xim2);
Xim2 = Xim2(:)';

[Xim3,~] = imread("3.png"); 
Xim3 = rgb2gray(Xim3);
Xim3 = Xim3(:)';

[Xim4,~] = imread("4.png"); 
Xim4 = rgb2gray(Xim4);
Xim4 = Xim4(:)';

[Xim5,~] = imread("5.png"); 
Xim5 = rgb2gray(Xim5);
Xim5 = Xim5(:)';

[Xim6,~] = imread("6.png"); 
Xim6 = rgb2gray(Xim6);
Xim6 = Xim6(:)';


Population = [Xim1;Xim2;Xim3;Xim4;Xim5;Xim6];