function [] = Origin_RFFit()
%% prepare the data to be fitted using the RF fit model described in
% Acad Radiology, Vol 21, No 2, February 2014
% R = lac / pyr , r = k+/k- , s = k+ + k- , R0 = R(t=0)
% R = (r*[1+R0]+[R0-r]*exp(-s*t))/(1+R0+[r-R0]*exp(-s*t))
% R = (r1/r2*[1+R0]+[R0-r1/r2]*exp(-(r1+r2)*x))/(1+R0+[r1/r2-R0]*exp(-(r1+r2)*x))
% Input: data created from AMARESPeakProcess

x = find(PeakAmpl(:,4) == max(PeakAmpl(:,4)));
Pyr = PeakAmpl(x:end,4)/max(PeakAmpl(:,4));
Lac = PeakAmpl(x:end,1)/max(PeakAmpl(:,4));
t = [0:3:(3*(size(Pyr,1)-1))];
R = Lac./Pyr;
 
a = [t' R];
a_x = a(1:20,1);
a_y = a(1:20,2);
 
%% fit curve with RF model
% 'REstimates' contains k+ (forward rate constant) and k- (reverse rate
% constant)
starting = [0.1,0.01];
R0 = a_y(2);
fun=@(r,t) (r(1)/r(2)*[1+R0]+[R0-r(1)/r(2)]*exp(-(r(1)+r(2))*t))./(1+R0+[r(1)/r(2)-R0]*exp(-(r(1)+r(2))*t));
[REstimates,resid,J,Sigma]=nlinfit(a_x,a_y,fun,starting);
REstimates

end
