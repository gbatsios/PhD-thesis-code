function [a,b] = OriginFitPrep(PeakAmpl)
%% prepare data for origin fitting
% Use as input data created by AMARESPeakProcess
% matrix 'a' can be copied-pasted in Origin
% matrix 'b' exprorts maximum values of Pyruvate and Lactate as their area
% under curve (AUC): Hill, D.K., et al. PLoS ONE, 2013. 8(9)

x = find(PeakAmpl(:,4) == max(PeakAmpl(:,4)));
Pyr = PeakAmpl(x:end,4)/max(PeakAmpl(:,4));
Lac = PeakAmpl(x:end,1)/max(PeakAmpl(:,4));
t = [0:3:(3*(size(Pyr,1)-1))];
t3 = t';
a = [t3 Pyr Lac];
 
%% calculate ratio of maxL to maxP and ratio areaL to areaP
% use the first 100 points for the area
maxP = max(PeakAmpl(:,4));
maxL = max(PeakAmpl(:,1));
ratio = maxL/maxP;
areaP = sum(PeakAmpl(1:100,4));
areaL = sum(PeakAmpl(1:100,1));
ratioA = areaL/areaP;
b = [maxP maxL areaP areaL];
 
end
