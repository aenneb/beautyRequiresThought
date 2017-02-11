% Undo the quantization of felt beauty that is presumed in our model with
% actual rating distribution as targeted output

%%
function [predProbBeauty] = model_beautyQuantization(parameters, conditionInput)
%% input
% N = number of parameters
% parameters(1:N/2-1) = means for trials without task
% parameters(N/2:N-1) = means for trials with task
% parameters(N) = sigma

% stimuli can belong to several conditions c, e.g. stimulus type
c = conditionInput;
%specify number of conditions
conditions = length(unique(c));
N = conditions*2+1;

mus = parameters(1:N-1);
sigma = parameters(N);

%% predicted beauty ratings go through a quantizaiton function which we can
% skip here and directly from the pdf generate the predicted probabilities

for condCounter = 1:conditions
    for beautyCount = 1:4 
        
        if beautyCount==1
            predProbBeauty(1, condCounter, beautyCount) = ...
                normcdf(.5, mus(condCounter), sigma);
            predProbBeauty(2, condCounter, beautyCount) = ...
                normcdf(.5, mus(condCounter+conditions), sigma);
        
        elseif beautyCount==2
            predProbBeauty(1, condCounter, beautyCount) = ...
                normcdf(1.5, mus(condCounter), sigma)...
                - normcdf(.5, mus(condCounter), sigma);
            predProbBeauty(2, condCounter, beautyCount) = ...
                normcdf(1.5, mus(condCounter+conditions), sigma)...
                - normcdf(.5, mus(condCounter+conditions), sigma);
       
        elseif beautyCount==3
            predProbBeauty(1, condCounter, beautyCount) = ...
                normcdf(2.5, mus(condCounter), sigma)...
                - normcdf(1.5, mus(condCounter), sigma);
            predProbBeauty(2, condCounter, beautyCount) = ...
                normcdf(2.5, mus(condCounter+conditions), sigma)...
                - normcdf(1.5, mus(condCounter+conditions), sigma);
       
        elseif beautyCount==4
            predProbBeauty(1, condCounter, beautyCount) = ...
                1-normcdf(2.5, mus(condCounter), sigma);
            predProbBeauty(2, condCounter, beautyCount) = ...
                1-normcdf(2.5, mus(condCounter+conditions), sigma);
       
        end
        
    end
end