% ex function deciall2 (use for 12bit sampling (RC format))
% resampling program --- requires signal processing toolbox
% Hajime Hirase ... no warranty ..(sorry) (1999)
% function downsample(inname,outname,numchannel,resampl,offset)
% this function passes anti aliasing low pass filter first
% to the data and then samples down, dividing the sampling rate by 1/resampleRatio. 
% Modification Lynn Hazan dec 2004: any offset can be used instead than an hard code offset of 2048 for 12 bit recordings
% if no offset is provided, offset = 0 is assumed % offset
%

function downsample(inname,outname,numchannel,resampl,offset)

if nargin <4,
error('function downsample(inname,outname,numchannel,resampl,offset)');
return
end

if isstr(numchannel)
    numchannel=str2num(numchannel);
end
if isstr(resampl)
    resampl=str2num(resampl);
end
if nargin<5 offset = 0; else offset = str2num(offset); end;

% open input file and output file
datafile = fopen(inname,'r');
outfile = fopen(outname,'w');

%
buffersize = 2^12 - mod(2^12,resampl);
overlaporder   = 8;
overlaporder2  = overlaporder/2;
overlaporder21 = overlaporder2+1;
obufsize = overlaporder * resampl;
obufsize11 = obufsize - 1;

% the first buffer

[obuf,count] = fread(datafile,[numchannel,obufsize],'int16');
obuf = fliplr(obuf) - offset;
frewind(datafile);
[datasegment,count] = fread(datafile,[numchannel,buffersize],'int16');  
datasegment = datasegment - offset;
datasegment2 = [obuf,datasegment]';
resampled = resample(datasegment2,1,resampl);
count2 = fwrite(outfile,resampled(overlaporder+1:size(resampled,1)-overlaporder2,:)'+offset,'int16');
obuf = datasegment2(size(datasegment2,1)-obufsize11:size(datasegment2,1),:);

% do the rest

while ~feof(datafile),
  [datasegment,count] = fread(datafile,[numchannel,buffersize],'int16');  
  datasegment = datasegment - offset;
  datasegment2 = [obuf;datasegment'];
  resampled = resample(datasegment2,1,resampl);
  count2 = fwrite(outfile,resampled(overlaporder21:size(resampled,1)-overlaporder2,:)'+offset,'int16');
  obuf = datasegment2(size(datasegment2,1)-obufsize11:size(datasegment2,1),:);
end  
 
% add the last unprocessed portion 
resampled = resample(obuf,1,resampl);
count2 = fwrite(outfile,resampled(overlaporder21:end,:)'+offset,'int16');

fclose(outfile);

