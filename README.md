# Revealing neural correlates of behavior without behavioral measurements
This repository includes several scripts and data sets which allow performing analysis presented in Rubin et al., 2019. 


## Usage and documentation
Scripts are provided in the *Scripts* directory.  This folder should be added in the MATLAB *Set Path*.
An example hippocampal data set is provided in the *SampleData* directory.
To perform the analysis on the example hippocampal data set, use the *InternalStructureHippocamopus.m* script.
To perform the analysis on the example head-direction data set, use the *InternalStructureHeadDirection.m* script.
The scripts and functions to produce processed data from raw data as given in CRCNS by Peyrache & Buzsáki (2015)
are provided in the *RawToProcessed* directory.

Simulated examples illustrating the principles of our work are provided in the *SimulatedExamples* directory.
For clustering of simulated data -first use *CreateDataSetClusting.m* to create a data set, and then use *TopoClusteringScriptExample.m* to analyse (cluster) it.

## References
* Alon Rubin, Liron Sheintuch, Noa Brande-Eilat, Or Pinchasof, Yoav Rechavi, Nitzan Geva & Yaniv Ziv. (2019). Revealing neural correlates of behavior without behavioral measurements. *Nature Communications* volume 10, Article number: 4745 https://doi.org/10.1038/s41467-019-12724-2
* Adrien Peyrache, Marie M Lacroix, Peter C Petersen & György Buzsáki. (2015). Internally organized mechanisms of the head direction sense. *Nature Neuroscience* volume 18, 569–575.
* Adrien Peyrache & György Buzsáki. (2015). Extracellular recordings from multi-site silicon probes in the anterior thalamus and subicular formation of freely moving mice. CRCNS https://crcns.org/data-sets/thalamus.