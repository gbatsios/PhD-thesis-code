function dA = ThreCompPL_basic(t,A,flag,Model)
 
%% modeling of 3 compartment for pyruvate and lactate
% initial compartment used to simulate injection and prevent need of Input
% Function - we take the MR relaxation in all 3 compartments but Pulse
% Angle relaxation only in Tissue 1 & 2
% 3 compartment: Blood, tissue 1, tissue 2
% gives the ability to add delay in one comparmtent compart to other
%% v3.2016031
% GBa
 
%% Kinetic parameter initialization
if (t > 12)
    kin = 100;
    k12 = 0.02;
    k21 = 0.01;
else
    kin = 0;
    k12 = 0; k21 = 0;
end
if (t > 40)          % produce delay
    k13 = 0.15;
    k31 = 0.01;
    k23 = 0.1;
    k32 = 0.01;
else
    k13 = 0; k31 = 0;
    k23 = 0; k32 = 0;
end
kPL = 0.02;
kPL2 = 0.05;

%% MR parameters (T1, flip angle & TR)
T1l = 15; T1p = 35;
theta = 12*pi/180;
TR = 3;
RL = 1/T1l + log(cos(theta))/TR;
RP = 1/T1p + log(cos(theta))/TR;
 
%% Modelling
dA = zeros(6,1);
 
%% 1 - 2 – 3 (Model B)
% dA1/dt = -kinA1                                      : injection
% dA2/dt = kinA1 - k12A2 + k21A3 - R1A2                : Blood
% dA3/dt = k12A2 - k21A3 - k23A3 + k32A4 - RpA3-kPLA3  : Comp 1 - P
% dA5/dt = kPLA3 - RlA5                                : Comp 1 - L
% dA4/dt = k23A3 - k32A4 - RpA4 - kPLA4                : Comp 2 - P
% dA6/dt = kPLA4 - RlA6                                : Comp 2 - L
 
if Model == 1
    dA(1) = -kin*A(1);
    dA(2) = kin*A(1) - k12*A(2) + k21*A(3) - 1/T1p*A(2);
    dA(3) = - k21*A(3) + k12*A(2) - k23*A(3) + k32*A(4) - RP*A(3) - kPL*A(3);
    dA(5) = kPL*A(3) - RL*A(5);
    dA(4) = - k32*A(4) + k23*A(3) - RP*A(4) - kPL2*A(4);
    dA(6) = kPL2*A(4) - RL*A(6); 
end
 
%% 1 - 2 ; 1 – 3 (Model A)
% dA1/dt = -kinA1                                       : injection
% dA2/dt = kinA1 - k12A2 + k21A3 - k13A2 + k31A4 - R1A2     : Blood
% dA3/dt = k12A2 - k21A3 - RpA3 - kPLA3                : Comp 1 - P
% dA5/dt = kPLA3 - RlA5                                : Comp 1 - L
% dA4/dt = k13A2 - k31A4 - RpA4 - kPLA4                : Comp 2 - P
% dA6/dt = kPLA4 - RlA6                                : Comp 2 - L
 
if Model == 2
    dA(1) = -kin*A(1);
    dA(2) = kin*A(1) - k12*A(2) + k21*A(3) - k13*A(2) + k31*A(4) - 1/T1p*A(2);
    dA(3) = - k21*A(3) + k12*A(2) - RP*A(3) - kPL*A(3);
    dA(5) = kPL*A(3) - RL*A(5);
    dA(4) = - k31*A(4) + k13*A(2) - RP*A(4) - kPL2*A(4);
    dA(6) = kPL2*A(4) - RL*A(6); 
end
 
end


