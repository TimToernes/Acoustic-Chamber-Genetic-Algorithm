
[Xim,map] = imread("square.png"); 
Xim = rgb2gray(Xim);
Xim = Xim(:)';

test = [Xim;Xim;Xim;Xim;Xim];

options = optimoptions(@ga,'CreationFcn',@gacreateWave);

X = ga(@wave_fitness,201^2,[],[],[],[],[],[],[],options);
