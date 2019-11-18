function SavePar1(Par)
% SavePar1 saves a structure with these elements to the specified .par.n file :
%
% .FileName           -> name of file
% .nChannels          -> number of total channels in the whole file
% .nSelectedChannels  -> number of channels for this electrode group
% .SampleTime         -> time, in microseconds, of 1 sample (ie 1e6 / sample rate)
% .SelectedChannels   -> selected channel ids i.e. [2 3 4 5]
% .DetectionRefract   -> refractory period after spike detection
% .IntegrationLength  -> RMS integration window length
% .ApproxFiringFreq   -> approximate firing frequency in Hz (or is it threshold?)
% .WaveSamples        -> number of samples extracted to the .spk file
% .PeakPos            -> peak position in the .spk file (should be half of .WaveSamples)
% .AlignmentSamples   -> number of samples used in alignment program
% .AlignmentPeak      -> peak position used in alignment program
% .ReconSamplesPre    -> number of samples before peak to use in reconstruction
% .ReconSamplesPost   -> number of samples after peak to use in reconstruction
% .nPCs               -> number of principal components
% .PCSamples          -> number of samples used in the PCA
% .HiPassFreq    -> High pass filter frequency
%
% The difference between this and SavePar is that this function
% saves a .par.n file - not a .par file

% open file
FileName = Par.FileName;
fp = fopen(FileName, 'w');

% write nChannels, nSelectedChannels, and SampleTime
A(1) = Par.nChannels ;
A(2) = Par.nSelectedChannels;
A(3) = Par.SampleTime;
fprintf(fp, '%d %d %d\n',A);

% write SelectedChannels
A = Par.SelectedChannels;
for i=1:length(A)
    fprintf(fp, '%d ',A(i));
end
fprintf(fp,'\n');
A=[];
% write DetectionRefract and IntegrationLength
A(1) = Par.DetectionRefract ;
A(2) = Par.IntegrationLength ;
fprintf(fp, '%d %d\n',A);
A=[];
% write ApproxFiringFreq
A = Par.ApproxFiringFreq ;
fprintf(fp, '%2.1f\n',A);
A=[];
% write WaveSamples and PeakPos
A(1) = Par.WaveSamples ;
A(2) = Par.PeakPos;
fprintf(fp, '%d %d\n',A);
A=[];
% write AlignmentSamples and AlignmentPeak
A(1) = Par.AlignmentSamples;
A(2) = Par.AlignmentPeak;
fprintf(fp, '%d %d\n',A);
A=[];
% write ReconSamplesPre and ReconSamplesPost
A(1) = Par.ReconSamplesPre;
A(2) = Par.ReconSamplesPost ;
fprintf(fp, '%d %d\n',A);
A=[];
% write nPCs and PCSamples
A(1) = Par.nPCs;
A(2) = Par.PCSamples ;
fprintf(fp, '%d %d\n',A);

% write HiPassFreq
A = Par.HiPassFreq;
fprintf(fp, '%d\n',A);


fclose(fp);