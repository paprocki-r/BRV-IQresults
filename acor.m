function ac = acor(x, T)
    N = length(x);
    if(N/2 < T)
        ac = 0;
        disp(['Window T should be less than', num2str(floor(length(x)/2))]);
    end
    ac = zeros(T, 1);
    for tau = 1:T
            window1 = x(1:T) - mean(x(1:T));
            window2 = x(tau:tau + T - 1) - mean(x(tau:tau + T - 1));
            ac(tau) = sum(window1 .* window2) / (std(window1) * std(window2) * (T - 1));
    end
end