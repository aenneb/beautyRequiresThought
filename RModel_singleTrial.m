% Fitting a general model to the emotiontracker data that captures the
% stereotypic time course of pleasure in the Pelli lab beauty experiments

% V1: Denis Pelli & Lauren Vale
% April 14, 2016
% Previously included in larger function that also reads in data and plots

% V2: Aenne Brielmann
% May 22, 2016
% Generalize the function to handle data of variable length and data
% matrices containing different numbers of subjects
% include t, tOn, and tOff as input to this function rather than specifying
% here

% V4: Aenne Brielmann
% June 3, 2016
% generalize to tOn and tOff that can vary

% V5: Aenne Brielmann
% June 3, 2016
% add a fast exponential to the decay exponential that has the same time
% constant as the slow exponential for initial increase


function [R]=RModel_singleTrial(p, tOn, tOff, t)

nDataFiles = size(p,2);
R=zeros(nDataFiles, length(t));

ROn = 1.129;
REnd = 1.082;
tauShort = 3.048;
tauLong = 104.296;
weight = 0.215;

for ii = 1:nDataFiles
    
    alphaOn = exp(-max(0,t-tOn(ii)) / tauShort);
    alphaOff = weight * min(1,exp(-(t-tOff(ii)) / tauShort)) +...
       (1-weight) * min(1,exp(-(t-tOff(ii)) / tauLong));
    
    R(ii,:) = alphaOn*ROn + (1-alphaOn).*alphaEnd*p(ii) +...
        (1-alphaEnd)*REnd;
    
end

end