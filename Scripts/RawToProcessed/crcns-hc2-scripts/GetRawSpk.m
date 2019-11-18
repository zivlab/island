%function [rSpk, Res, Clu] = GetRawSpk(DatFileName,Res,Clu,nSpkSamples,Channels,Par)
%loads from .dat file the waveshapes of spikes corresponding to Res/Clu from given Channels 
   % nSpkSamples is either number, then the waveshape will contain equal number of samples left/right or a 2 element vector [left right] # of samples
function [rSpk, Res, Clu] = GetRawSpk(DatFileName,Res,Clu,nSpkSamples,Channels,Par)

MaxDatSamples = FileLength(DatFileName)/2/Par.nChannels;
mmap = memmapfile(DatFileName, 'format',{'int16' [Par.nChannels MaxDatSamples] 'x'},'offset',0,'repeat',1);
if length(nSpkSamples)==1
    % use that many samples left/right from the spike trough
    rSmpls = floor(nSpkSamples/2);
    lSmpls = nSpkSamples - floor(nSpkSamples/2)-1;
else
    [lSmpls, rSmpls] = deal(nSpkSamples(1),nSpkSamples(2));
    nSpkSamples = sum(nSpkSamples)+1;
end
%myCh = Par.ElecGp{Map(c,2)}+1;
if Res(end)>MaxDatSamples
    Clu =Clu(Res< MaxDatSamples);
    Res =Res(Res< MaxDatSamples);

end
nRes = length(Res);
mySmpls = repmat(Res,1,nSpkSamples)+repmat([-lSmpls:rSmpls],nRes,1);
mySmpls = reshape(mySmpls',[],1);
spkwave = mmap.Data.x(Channels,mySmpls);
spkwave = double(reshape(spkwave,[length(Channels), nSpkSamples, nRes]));
rSpk = spkwave - repmat(mean(spkwave,2),[1 nSpkSamples 1]);
