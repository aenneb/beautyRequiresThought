function roc=ROC(rating,isNbackTrial,objectType,objectTypes)
% Compute ROC curve for detecting the absence of a secondary task from a
% rating response. The rating may be pleasure (1-9) or beauty (0-3).
% You pass our entire data set, currently 660 trials. All but the last
% array is of size 660x1. The last array is a list of desired object kinds,
% integers ranging from 1 to 6. 
% 1 = self-selected
% 2 = high-valence IAPS
% 3 = mid-valence IAPS
% 4 = candy
% 5 = IKEA furniture
% 6 = teddy bear

% INPUTS:
% rating(i) is the observer's rating on trial i.
% isNBackTrial(i) is boolean, true when task is added.
% objectType(i) is the object type on trial i.
% objectTypes is a short list of integers.
% OUTPUT:
% roc struct, with fields:
% roc.pHit
% roc.pFalseAlarm
% roc.lambda
% roc.area
% 
% denis.pelli@nyu.edu July 2016.
%
assert(length(rating)==length(isNbackTrial));
assert(length(rating)==length(objectType));
assert(length(objectTypes)>0 && length(objectTypes)<10);
ratingWO=[];
ratingW=[];
% This is a very slow way of putting our selected data into new arrays, but
% it's inconsequential since the array is only 660 long.
for i=1:length(rating)
   if ismember(objectType(i),objectTypes)
      if isNbackTrial(i)
         ratingWO=[ratingWO rating(i)];
      else
         ratingW=[ratingW rating(i)];
      end
   end
end
lambdaList=unique([ratingWO ratingW]);
lambdaLength=length(lambdaList);
pHit=zeros(1,lambdaLength);
pFalseAlarm=zeros(1,lambdaLength);
for i=1:lambdaLength
   lambda=lambdaList(i);
   pHit(i)=sum(ratingWO<=lambda)/length(ratingWO);
   pFalseAlarm(i)=sum(ratingW<=lambda)/length(ratingW);
end
roc.pHit=[0 pHit 1];
roc.pFalseAlarm=[0 pFalseAlarm 1];
roc.lambda=[-Inf lambdaList Inf];
area=0;
for i=1:lambdaLength-1
   area=area+mean([pHit(i) pHit(i+1)])*(pFalseAlarm(i+1)-pFalseAlarm(i));
end
roc.area=area;