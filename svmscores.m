function scores = svmscores(model,X)

shift = model.ScaleData.shift;
scale = model.ScaleData.scaleFactor;

X = bsxfun(@plus,X,shift);
X = bsxfun(@times,X,scale);

sv = model.SupportVectors;
alphaHat = model.Alpha;
bias = model.Bias;
kfun = model.KernelFunction;
kfunargs = model.KernelFunctionArgs;
scores = kfun(sv,X,kfunargs{:})'*alphaHat(:) + bias;

% flip the sign to get the score for the +1 class
scores = -scores;