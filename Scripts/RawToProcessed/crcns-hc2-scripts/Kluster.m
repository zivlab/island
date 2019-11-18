%function Kluster(FileBase,Data, SampleRate, NormFet)
% create files needed for Klusters to run - can use any kind of time, features, waveshape data given you follow the format below. 
%Data = {Fet,Spk,Res,Clu}
% Spk has to be [nChannels, SpkSampls, nSpikes]);
% Fet has to be [nSpikes, nFet, nChannels]
% and start the manual clustering program klusters
% { 'klusters','xgobi'}
function Kluster(FileBase,Data,varargin)

[ SampleRate,NormFet] = DefaultArgs(varargin,{ 20000,1});
tmpfn = 0;
if isempty(FileBase)
    FileBase = ['klust' num2str(round(rand(1,1)*1e6))];
    tmpfn =1;
end
nSpkSampls = 32;
if ~iscell(Data)
    Fet = Data;
    if ndims(Fet)>24
        [nSpikes nFet nChannels] = size(Fet);
    else
        [nSpikes nFet] = size(Fet);
        nChannels =1;
    end
    Spk = rand(nChannels,nSpkSampls,nSpikes);
    Res = [1:nSpikes];
    Clu = ones(nSpikes,1);
else
    Fet = Data{1};
    if ndims(Fet)>2
        [nSpikes nFet nChannels] = size(Fet);
    else
        [nSpikes nFet] = size(Fet);
        nChannels =1;
    end
    dSpk = rand(nChannels,nSpkSampls,nSpikes);
    dRes = [1:nSpikes]';
    dClu = ones(nSpikes,1);
    [Spk,Res,Clu] = DefaultArgs(Data(2:end), {dSpk, dRes, dClu});
    if ndims(Spk)>2
        nSpkSampls = size(Spk,2);
        nChannels = size(Spk,1);
    else
        nSpkSampls = size(Spk,1);
        Spk = shiftdim(Spk,-1);
    end
end
if ndims(Fet)>2
    nFet = nFet*nChannels;
    Fet = reshape(Fet,nSpikes,[]);
end
nFetOrig = nFet;
if nFet <5
    Fet = cat(2,Fet, rand(nSpikes, 5-nFet));
    nFet = 5;
end
 MaxInt = 32768;
if NormFet
    %normalize the featires and round them
    MaxAbs = max(abs(Fet));
    Fet = round(Fet * MaxInt./ repmat(MaxAbs(:)',nSpikes,1));
end
%normalize Spk
MaxAbsSpk = max(abs(Spk(:)));
Spk = MaxInt*Spk/MaxAbsSpk;
Spk = round(Spk - repmat(mean(Spk,2),[1,size(Spk,2),1]));

%Res = round(Res(:)*SampleRate)+1;
%Fet = [Fet rand(nSpikes,4) Res];
Fet = [Fet Res];
nClu = max(Clu);
if FileExists([FileBase '.fet.1'])
    cdir = pwd; fnbeg = strfind(cdir,'/'); cdir = cdir(fnbeg(end)+1:end);
    if FileExists([FileBase '.eeg']) | strcmp(FileBase, cdir)
        error('your FileBase %s corresponds to existing eeg file or the directory name - danger ..check if you want to use the name\n',FileBase);
    else
        system(['rm ' FileBase '.*']);
    end
end
if size(Spk,1)==1
    bsave([FileBase '.spk.1'],sq(Spk),'short');
else
    bsave([FileBase '.spk.1'],Spk,'short');
end

msave([FileBase '.clu.1'],[nClu; Clu(:)],'w');
SaveFet([FileBase '.fet.1'],Fet);
allm =sq(mean(mean(Spk,2),3));
allv = sq(std(reshape(Spk,nChannels,[]),0,2))'.^2;
msave([FileBase '.m1m2.1'],[ allm(:) allv(:)],'w');
allfm=sq(mean(Fet,1));
allfv=sq(std(Fet,0,1));
msave([FileBase '.mm.1'],[ allfm' allfv']);
msave([FileBase '.res.1'],Res);

SampleTime = 1e6/SampleRate;

Par.FileName= [FileBase '.par'];     % -> name of file loaded from
Par.nChannels= nChannels;   % -> number of total channels
Par.nBits=      16;       % -> number of bits of the file
Par.SampleTime= SampleTime;  % -> time, in microseconds, of 1 sample (ie 1e6 / sample rate)
Par.HiPassFreq=   800; %-> High pass filter frequency
Par.nElecGps=     1;   %- > number of electrodes (i.e. electrode groups)
Par.ElecGp=        {[0:nChannels-1]};    %-> a cell array giving the channels in the electrodes

SavePar(Par);

Par1.FileName             =  [FileBase '.par.1']; % name of file
Par1.nChannels            = nChannels; % number of total channels in the whole file
Par1.nSelectedChannels    = nChannels; % number of channels for this electrode group
Par1.SampleTime           = SampleTime; % time, in microseconds, of 1 sample (ie 1e6 / sample rate)
Par1.SelectedChannels     =[0:nChannels-1];  % selected channel ids i.e. [2 3 4 5]
Par1.DetectionRefract     =  nSpkSampls;% refractory period after spike detection
Par1.IntegrationLength    = nSpkSampls/2; % RMS integration window length
Par1.ApproxFiringFreq     = 5; % approximate firing frequency in Hz (or is it threshold?)
Par1.WaveSamples          =  nSpkSampls;% number of samples extracted to the .spk file
Par1.PeakPos              =  round(nSpkSampls/2);% peak position in the .spk file (should be half of .WaveSamples)
Par1.AlignmentSamples     = nSpkSampls; % number of samples used in alignment program
Par1.AlignmentPeak        = round(nSpkSampls/2); % peak position used in alignment program
Par1.ReconSamplesPre      = round(nSpkSampls/4); % number of samples before peak to use in reconstruction
Par1.ReconSamplesPost     =round(nSpkSampls/4);  % number of samples after peak to use in reconstruction
Par1.nPCs                 = nFet-4; % number of principal components
Par1.PCSamples            = nSpkSampls; % number of samples used in the PCA
Par1.HiPassFreq      = 800; % High pass filter frequency

SavePar1(Par1);
        Command = ['klusters ' FileBase '.spk.1&'];
       fprintf('%s\n',Command);
    system(Command);



if tmpfn
    answ= input('Do you want to delete the temp files? (1/0)\n');
    if answ
        system(['rm ' FileBase '.*']);
    end
end
