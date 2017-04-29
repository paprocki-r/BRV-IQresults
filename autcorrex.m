x=[1:100]
[C, LAGS] = xcorr(sin(x),sin(x),'coeff');
plot(LAGS, C)
