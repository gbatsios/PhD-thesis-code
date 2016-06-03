function dA = LacEffect3c(t,A,flag,b)
 
%% modeling of 2 compartment for pyruvate and lactate
% initial compartment used to simulate injection and prevent need of Input
% Function - we take the MR relaxation in all 3 compartments but Pulse
% Angle relaxation only in Tissue 1
% we assume that after a [Lac] there is change in the k12 of tissue uptake,
% either to zero or small value
% ability externaly to change the values for k and [Lac] to be able to
% simulate different cases; b = [k12 k21 LacLim k12_new kPL kPLnew klac]
% 2 compartment: Blood, tissue 1
% we can assume that the total magnitization M is equal to m (magnetization
% of each pyruvate molecule) times N (number of pyruvate molecules)
%% ex1: [t,As] = ode45('LacEffect3c_in',[0:3:300],[1e5 zeros(1,7)],[],[0.1 0.05 10e3 0.01 0.045 0.045 0]);
% plotyy(t/60,As(:,[3:4]),t/60,[As(:,[5:6]) sum(As(:,[5:6]),2)])
%% v2.20150804
% v3.20150808
% GBa

%% kinetic rate constants
if (t > 12)
    kin = 5;
    k12 = b(1);
    k21 = b(2);
else
    kin = 0;
    k12 = 0;
    k21 = 0;
end
kPL = b(5);
klac = b(7);
if (A(7) > b(3))
    k12 = b(4);		% Model D
    kPL = b(6);		% Model C
end

%% MR parameters (T1, flip angle & TR)
T1l = 15; T1p = 35;
theta = 12*pi/180;
TR = 3;
RL = 1/T1l + log(cos(theta))/TR;
RP = 1/T1p + log(cos(theta))/TR;

 
%% Modelling
dA = zeros(8,1);
 
% dA(1)/dt = - kin*A(1);                               : injection
% dA(2)/dt = kin*A(1) - k12*A(2) + k21*A(3) - 1/T1p*A(2); : blood - magn
% dA(5)/dt = kin*A(1) - k12*A(5) + k21*A(6);         : blood - conc
% dA(3)/dt = - k21*A(3) + k12*A(2) - RP*A(3) - kPL*A(3);  : Pyr - magn
% dA(6)/dt = - k21*A(6) + k12*A(5) - kPL*A(6);         : Pyr - conc
% dA(4)/dt = kPL*A(3) - RL*A(4) - klac*A(4);           : Lac - magn
% dA(7)/dt = kPL*A(6) - klac*A(7);                     : Lac - conc
% dA(8)/dt = klac*A(7);                        : Lac - extracellular
 
 
dA(1) = - kin*A(1);                             % syringe

dA(2) = kin*A(1) - k12*A(2) + k21*A(3) - 1/T1p*A(2);
dA(5) = kin*A(1) - k12*A(5) + k21*A(6);         % blood - conc

dA(3) = - k21*A(3) + k12*A(2) - RP*A(3) - kPL*A(3);
dA(6) = - k21*A(6) + k12*A(5) - kPL*A(6);       % Pyr - conc

dA(4) = kPL*A(3) - RL*A(4) - klac*A(4);
dA(7) = kPL*A(6) - klac*A(7);                   % Lac - conc

dA(8) = klac*A(7);    
  
end