%FastICA algorithm
%  [W,P] = fastica1(X,opts,g,gg)
%
%Input parameters
%  X    : Matrix with components in the columns. Components are assumed to be
%         uncorrelated and have zero mean (whitened and centered).
%  opts : Vector with three elements. The first two are used in stopping
%         criteria for each component:
%           Number of iterations>opts(1) or
%           1-abs(w'*wOld)<opts(2). (Dot product close to 1).
%         opts(3) decides how decorrelation is performed. If the difference
%         (one-norm) between two rows in W is less than or equal to opts(3),
%         one of them is replaced by a decorrelated version. Use opts(3)=inf
%         to decorrelate after all iterations. Decorrelation gives less
%         nongaussianity, but prevent two components from being equal.
%  g    : First derivative of nongaussian estimator.
%  gg   : Second derivative of nongaussian estimator.
%
%Output parameters
%  W    : Inverse transformation matrix.
%  P    : Convergence. Sum of abs(w'*wOld) for all components in all
%         iterations.
%
%2002-11-21 | Michael Vinther | mv@logicnet.dk
function [W,P] = FastICA1(X,opts,g,gg)
 
nComp = size(X,1);
W = eye(nComp); % Initial guess on W
P = [];
sumP = 0;
wDecor = [];

 
for c=1:nComp % For all components
  wOld = zeros(nComp,0);
  w = W(c,:)';
  i = 0;
  decorrelate = c>1; % Decortrelate all but first component
  stop = 0;
  while ~stop
    wOld = w;
    i = i+1;
    % Do Newton-Rhapson step
    y = w'*X;
    w = mean((X.*repmat(g(y),nComp,1))')'-mean(gg(y))*w;
    w = 1/norm(w)*w;
 
    if decorrelate % Decorrelate w
      wd = zeros(nComp,1);
      for d=1:c-1
        wd = wd+w'*W(d,:)'*W(d,:)';
      end
      w = w-wd;
      w = 1/norm(w)*w;
    end
    if nargout>1
      P(end+1) = sumP+abs(w'*wOld);
    end
 
    if 1-abs(w'*wOld)<opts(2) % No change in w
      if decorrelate & opts(3)<inf
        decorrelate = 0; % Stop decorrelation
        wDecor = w;
      else
        stop = 2;
      end
    elseif i>=opts(1) % Too many iterations
      stop = 1;
    end
  end
  if ~isempty(wDecor) % Check if w already found
    for d=1:c-1
      Diff(d) = min(norm(W(d,:)'-w,1),norm(W(d,:)'+w,1));
    end
    if min(Diff)<=opts(3)
      w = wDecor; % Close match found, use decorrelated w
    end
  end
  W(c,:) = w';
  if nargout>1
    sumP = P(end);
  end
end