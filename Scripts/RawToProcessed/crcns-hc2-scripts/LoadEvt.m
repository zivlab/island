%function [EvtRes, EvtClu, EvtLabels, Labels] = LoadEvt(FileName,SampleRate, Labels)
   % loads event file (.evt) produced by neuroscope (see manual of neuroscope) into vectors of time (EvtRes) and type (EvtClu) of events, EvtLabels are stored in cell array EvtLabels. Labels contains unique set of all existing labels. Input Labels allows to confine load to only events with labels listed in Labels input argument (cell array).
 
function [EvtRes, EvtClu, EvtLabels, Labels] = LoadEvt(FileName,varargin)

[SampleRate, Labels] = DefaultArgs(varargin,{1250, []});

[EvtRes EvtLabels] = textread(FileName,'%f %s');

uLabels = unique(EvtLabels);
if isempty(Labels)
	Labels = uLabels;
elseif ~isempty(setdiff(Labels,uLabels))
	Lablels = intersect(Labels, uLabels);
end

myInd = find(ismember(EvtLabels,Labels));
EvtLabels = EvtLabels(myInd);
EvtRes	= round(EvtRes(myInd)*SampleRate/1000)+1;	
if ~iscell(Labels)
tmp =Labels;Labels ={};
Labels{1}=tmp;
end	
for i=1:length(Labels)
	cluInd = find(strcmp(EvtLabels,Labels{i}));
	EvtClu(cluInd) = i;	
end	




