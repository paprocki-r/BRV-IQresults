function output = applyICA(inputs, method)
    norm_input_signals = [];

    for i = 1:size(inputs,1)
        norm_input_signals = [norm_input_signals; (inputs(i,:) - mean(inputs(i,:)))/std(inputs(i,:))];
    end

    %plotArrayOfTS(norm_input_signals, 'Normalized');

    %rb = norm_input_signals(1,:) + norm_input_signals(2,:);
    %figure, plot(rb)

    [Xw WhiteT Xc V D] = decorrelate(norm_input_signals');

    projectSignals = V * norm_input_signals;
    projectSignals(1,:) = 0;
    F = D;
    F(1, 1) = 0.001;
    Reconstructed =  inv( V*diag(diag(F).^-0.5)*V') * Xw;
    %plotArrayOfTS(norm_input_signals, 'Original');
    % plotArrayOfTS(Xw, 'Decorrelated');
    %plotArrayOfTS(Reconstructed, 'Reconstructed');

    [icasig, W, A] = ica(norm_input_signals', method);
    output = icasig;
end
