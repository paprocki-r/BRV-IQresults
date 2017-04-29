clear all
xrnd = rand(1,100);
x = cumsum(xrnd - mean(xrnd));
T = 50;
ac = acor(x, T);
ac(1)
figure, plot(0: T-1, ac)
