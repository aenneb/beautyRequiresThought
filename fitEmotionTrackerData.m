% Fitting the overall model
% V1: Denis Pelli & Lauren Vale
% April 14, 2016
% Generated model equations.

% V2: Lauren Vale
% April 23, 2016
% Added comments, code for RMSE, and code to make figures.

% V3: Aenne Brielmann
% May 22, 2016
% outsource RModel to be able to run code partially
% generalize the input structure and read most durations from the data
% skip plotting within this shortened and generalized version of the
% function
% re-name most of the variables to make code easier to read
% save model fits as .mat at the end

% V4: Aenne Brielmann
% June 2, 2016
% outsource tOn and tOff further: now also input to this function
% both tOn and tOff now need to be vectors of the same length as the number
% of curves to be fit

% V5: Aenne Brielmann
% August 1, 2016
% introduce wShort as another parameter that like ROn and tauOn are fit
% once across all stimulus types

function [parameters, cost] = fitEmotionTrackerData(data, dataSetName, tOn, tOff)
%% Parameter meanings with N = number of rows in the data set
% parameters(1:N) is R_steady for each of the data files
% p(N+1) is ROn
% p(N+2) is rOff
% p(N+3) is tauOn
% p(N+4) is tauOff
% p(N+5) is wShort

%% Some values must be pre-defined here
% edit if not applicable to the data structure

nDataFiles = size(data, 1);

% Set the start values for all Rsteady to the middle: 5
parameterStartValues(1:nDataFiles) = 5;
% Set the rest of the start values here
parameterStartValues(nDataFiles+1:nDataFiles+5) = [1 1 1 60 0.5];

%% --------- no editting of values should be required below this line

t = 1:size(data,2);

% Name the parameters
for n = 1:nDataFiles
    parameterNames{n} = ['rSteady' num2str(n)];
end

parameterNames(nDataFiles+1:nDataFiles+5) = {'ROn','rOff','tauOn','tauOff', 'wShort'};

% add penality for values that are out of range
trespassCost_rOn = @(rOn) max([0,rOn-10,1-rOn])^2;
trespassCost_rOff = @(rOff) max([0,rOff-10,1-rOff])^2;

% Cost function (data - model)
cost=@(parameters) nanmean(nanmean((data - RModel_averages(parameters, tOn, tOff, t)).^2)) +...
    1000*trespassCost_rOn(parameters(nDataFiles+1)) +...
    1000*trespassCost_rOff(parameters(nDataFiles+2));

% Set the number of iterations high to minimize the cost fn
options=optimset('maxIter',10e12);

% Call the minimization fn
parameters = fminsearch(cost, parameterStartValues, options);

% Print the output
for ii=1:length(parameters)
    fprintf('%5.1f %5.1f %s\n', parameterStartValues(ii), parameters(ii),...
        parameterNames{ii});
end

% Print the cost
fprintf('%5.1f %5.1f cost\n', cost(parameterStartValues), cost(parameters));

% The model fit
modelPredictions = RModel_averages(parameters, tOn, tOff, t);

% calculate the RMSE
Errors = data - modelPredictions; % Data-Model
squaredErrors = Errors.^2; % Squared Error
MeanSqErr = mean(squaredErrors); % Mean Squared Error across conditions
MeanSqErr2 = mean(MeanSqErr); % mean squared error across time anc conditions
RMSE = sqrt(MeanSqErr2); % Root Mean Squared Error, estimate of overall model fit

% save the RMSE, model predictions, and parameter values (errors and costs
% need not be saved, they can easily be re-computed given the data and the
% model predictions
save([dataSetName, '_modelFit'], 'RMSE', 'modelPredictions',...
    'parameters')

end
