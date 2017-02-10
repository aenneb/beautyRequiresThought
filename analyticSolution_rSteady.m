% calculate optimal rSteady value based on the values obtained from
% free-parameter fitting of average curves

% V1: Denis Pelli & Aenne Brielmann
% August 8, 2016
% v2, dgp, sum over same elements in numerator and denominator.
% v3 replaced missing "1-" in alphaOn and alphaEnd
% v4 corrected sign of last term in alphaEnd

function [rSteady] = analyticSolution_rSteady(data, tOn, tOff, t)

nDataFiles = size(data,1);
rSteady=zeros(nDataFiles, 1);

rInitial = 1.129;
rFinal = 1.082;
tauOn = 3.048;
tauOff = 104.296;
weight = 0.215;

ramp=@(x) max(0,x);
for ii=1:nDataFiles
   alphaOn = 1-exp(-ramp(t-tOn(ii))/tauOn);
   alphaOff = 1-weight*exp(-ramp(t-tOff(ii))/tauOn)- ...
      (1-weight)*exp(-ramp(t-tOff(ii))/tauOff);
   f = (1-alphaOn)*rInitial+alphaOn.*alphaOff*rFinal;
   g = alphaOn.*(1-alphaOff);
   top = (data(ii,:)-f).*g;
   bottom = g.^2;
   ok = isfinite(top);
   rSteady(ii) = nansum(top(ok))/nansum(bottom(ok));
end
end

