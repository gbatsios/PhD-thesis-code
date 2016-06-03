# PhD-thesis-code
Code described/used during PhD

AMARESPeakProcess: Code to process the AMARES graphs. Loads the data from the txt file, plot the evolution of the metabolites
and saves the data to a file with the same name as the txt file. It has the ability to process more than one files. It extracts
from txt file: Peak amplitude, peak frequency, residual of AMARES quantification

LDH_RFFit: It prepares the data to be fitted using the RF fit model described in "Acad Radiology, Vol 21, No 2, February 2014"
Input: data created from AMARESPeakProcess

OriginFitPrep: It prepares data for origin fitting. Use as input data created by AMARESPeakProcess. Also creates area under 
curve (AUC) for pyruvate and lactate to be applied as it is described in "Hill, D.K., et al. PLoS ONE, 2013. 8(9)"

ModelA_B: Modelling of 3 compartment for pyruvate and lactate. 3 compartment are: Blood, tissue 1, tissue 2. It gives the 
ability to add delay in one comparmtent compart to other.

ModelC_D: Modelling of 2 compartment for pyruvate and lactate. Ability externaly to change the values for k and [Lac] to be 
able to simulate different cases

TwoAnimalFIDProcess: Reads Bruker data from two animal experiment (animal interleaved) into matlab environment and writes them
one after the other in fid file to be read from TOPSIN (Bruker)
