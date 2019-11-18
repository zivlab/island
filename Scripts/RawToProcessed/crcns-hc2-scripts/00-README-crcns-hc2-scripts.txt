*******
* File 00-README-crcns-hc2-scripts.txt
*******

This file contains a brief description of the scripts
in the crcns-hc2-scripts.zip download.


Helper functions, help is self-explanatory:
DefaultArgs.m
FileExists.m
FileLength.m
bsave.m
msave.m


Functions to work with parameter files:
LoadXml.m  - loads the content of the .xml file into matlab structure.
xmltools.m - used to parse xml by LoadXml.m
SavePar.m , SavePar1.m - saves into old type parameter file (FileBase.par). 
     .par files are recognized by neuroscope and klusters, if no xml file is present.
     .par files can be converted to .xml files using the par2xml tool.
LoadPar.m - loads text .par file into a structure


Function to load various types of raw or processed data into matlab:
bload.m
GetRawSpk.m
LoadBinary.m
LoadClu.m
LoadCluRes.m
LoadEvt.m
LoadFet.m
LoadSegs.m
LoadSpk.m


SaveFet.m - creates Fet file from the matrix of features.
KKsubmit  - sample unix shell script for calling KlustaKwik
     (to startup automatic spike sorting).
 
Functions used in processing suite:
downsample.m - used for  downsampling the .dat to the .eeg 
firfilter.m   - used to high-pass filter .dat to .fil for spike detection

Kluster.m - generates from data structures in matlab necessary files in
     format needed to run Klusters.

-------------------------

Changes:
2013-03-11 - By Jeff Teeters
  Added function datatypesize, which is used by function LoadBinary.
  Located by Google search and downloaded from:
  http://read.pudn.com/downloads139/sourcecode/graph/texture_mapping/596319/datatypesize.m__.htm
  Edited to replace break with return as suggested by MatLab error message.


