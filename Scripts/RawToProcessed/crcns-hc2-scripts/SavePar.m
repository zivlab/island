function SavePar(Par)
% SavePar(Par)
% save the structure with these elements into the par file :
%
% .FileName=      % -> name of file loaded from
% .nChannels=    % -> number of total channels
% .nBits=             % -> number of bits of the file
% .SampleTime=   % -> time, in microseconds, of 1 sample (ie 1e6 / sample rate)
% .HiPassFreq=    %-> High pass filter frequency
% .nElecGps=        %- > number of electrodes (i.e. electrode groups)
% .ElecGp=            %-> a cell array giving the channels in the electrodes
%                    e.g. if .ElectrodeGroup{3} = [2 3 4 5], electrode 3
%                    is a tetrode for channels 2 3 4 and 5.
  % now with the xml structure at hand you can use xmltools function to create an xml file directly
% otherwise run par2xml to generate the xml file from par file. 

% open file
FileName =  Par.FileName ;
if isempty(strfind(FileName ,'.xml'))
    FileName = [FileName '.xml'];
end
fp = fopen(FileName, 'w');

% write nChannels and nBits
A(1) = Par.nChannels;
A(2) = Par.nBits;
fprintf(fp, '%d %d\n',A);
A=[];
% write SampleTime and HiPassFreq
A(1) = Par.SampleTime;
A(2) = Par.HiPassFreq;
fprintf(fp, '%d %3.0f\n',A);
A=[];
% write nElectrodes
A(1) = Par.nElecGps;
fprintf(fp, '%d\n', A);
A=[];
% write ElectrodeGroup
for i=1:Par.nElecGps
    A = Par.ElecGp{i};	
    A =[length(A) A(:)'];
    for j=1:length(A)
        fprintf(fp, '%d ',A(j));
    end
    fprintf(fp,'\n');
end;

fclose(fp);
