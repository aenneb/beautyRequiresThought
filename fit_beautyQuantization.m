% Undo the quantization of felt beauty that is presumed in our model with
% actual rating distribution as targeted output

function [parameters, cost] = fit_beautyQuantization(probBeauty, stimulusCategories)
%% Parameter meanings:
% N = number of parameters
% parameters(1:N/2-1) = means for trials without task
% parameters(N/2:N-1) = means for trials with task
% parameters(N) = sigma

N = length(unique(stimulusCategories))*2+1;

%% Pre-define parameter start values

parameterStartValues = ones(N,1); % do not use zeros, ultr-rapid convergence without any change in parameters

%% --------- no editting of values should be required below this line
for ii = 1:N-1
    parameterNames(ii) = {['mu' num2str(ii)]};
end
parameterNames(N) = {'sigma'};

% Cost function (data - model)
cost=@(parameters) sqrt(nanmean(nanmean(nanmean(((probBeauty - model_beautyQuantization(parameters, stimulusCategories)).^2)))));
 
% Set the number of iterations and other options to optimally use
% fminunc/fmincon
options = optimoptions('fmincon', 'maxIter',10e12, 'TolX', 1e-20); % for disgnostics also include: ,'Display','iter', 
% options = optimset('maxIter',10e10, 'TolX', 10e-20);

% constraint such as not to let sigma get negative
lowerBounds(1:N) = 0;
lowerBounds(N) = .1;

% and maybe also put a ceiling to gain - this is troublesome
upperBounds(1:N) = 10;

% Call the minimization fn
% parameters = fmincon(cost, parameterStartValues,[],[],[],[],lowerBounds,upperBounds,[],options);
problem = createOptimProblem('fmincon','objective',...
 cost,'x0',parameterStartValues,'lb',lowerBounds,'ub',upperBounds,'options',options);

% ms = MultiStart('Display', 'iter','MaxTime',180);
% [parameters,lik] = run(ms,problem,20);
gs = GlobalSearch('MaxTime',180); %'Display', 'iter',
[parameters] = run(gs,problem);

% Print the output
for ii=1:length(parameters)
    fprintf('%5.1f %5.1f %s\n', parameterStartValues(ii), parameters(ii),...
        parameterNames{ii});
end

% Print the cost
fprintf('%5.1f %5.1f cost\n', cost(parameterStartValues), cost(parameters));

% The model fit
modelPredictions = model_beautyQuantization(parameters, stimulusCategories);

% calculate the RMSE 
rmse = sqrt(nanmean(nanmean(nanmean(((probBeauty - model_beautyQuantization(parameters, stimulusCategories)).^2)))));
fprintf('RMSE %5.4f\n', rmse);

end
