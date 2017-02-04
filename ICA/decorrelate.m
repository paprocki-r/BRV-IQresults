function [Xw WhiteT Xc V D] = decorrelate(X)
    % Centering
    m = mean(X)';
    Xc = X'-repmat(m,1,size(X,1)); % Center and transpose

    % Whitening
    R = cov(Xc');
    [V,D] = eig(R);
    WhiteT = V*diag(diag(D).^-0.5)*V'; % Whitening transform
    Xw = WhiteT*Xc; % 
end