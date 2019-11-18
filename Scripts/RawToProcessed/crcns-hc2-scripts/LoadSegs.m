% function [Segs, Complete] = LoadSegs(FileName, StartPoints, SegLen, nChannels, Channels, 
%                                       SampleRate, ResampleCoef, Buffer, IfNotComplete)
%   loads segments from FileName (full name) for selection of Channels
%   StartPoints give the starting times of the segments (in samples).
%   SegLen gives the length of the segments in samples.  All segments must be
%   the same length, and a rectangular array is returned
%   (dim 1:time within segment,  dim 2:channel, dim 3: segment number);
%   IfNotComplete specifies what to do if the start or endpoints are outside
%   of the range of x.  If a value is specified, any out-of-range points
%   are given that number.  If [] is specified, incomplete segments are not
%   returned.  A list of complete segments extracted is returned in Complete.
%   Default value for IfNotComplete: NaN.
%

function [Segs, Complete] = LoadSegs(FileName, StartPoints, SegLen, varargin)
FileBase = FileName(1:end-4);

[nChannels, Channels, SampleRate, ResampleCoef,Buffer,IfNotComplete ] = ...
    DefaultArgs(varargin,{ [], [], 1250, 1,0,[]});
if isempty(Channels) | isempty(nChannels)
    Par = LoadPar([FileBase]);
    if isempty(Channels)
        Channels = [1:Par.nChannels];
    end
    if isempty(nChannels)
        nChannels = Par.nChannels;
    end
end
StartPoints = StartPoints(:);
FileLen = FileLength(FileName);
nSamples = FileLen / 2 / nChannels;
Complete = find(StartPoints>0 & StartPoints+SegLen<nSamples);
StartPoints = StartPoints(Complete);
nSegs = length(StartPoints);
nUsedChannels = length(Channels);

% if memory allows to map the whole file - this is THE WAY TO DO IT!!! 
if Buffer ==2
    IndMat = repmat(StartPoints(:)',[SegLen,1]) ...
        + repmat((0:SegLen-1)', [1, nSegs]);

    mmap = memmapfile(FileName, 'format',{'int16' [nChannels nSamples] 'x'},'offset',0,'repeat',1);

    Segs = mmap.Data.x(Channels,IndMat(:));
    Segs = double(Segs);
    Segs = reshape(Segs,[length(Channels), SegLen, nSegs]);
    return
end

% if file size is small and many triggers and many channels are used
if (FileLen < 0.5*FreeMemory)  & (nUsedChannels*nSegs*SegLen*2 > 0.1*FileLen)
    Dat = bload([FileBase '.eeg'], [nChannels, inf], 0);
    if ResampleCoef>1
        Dat = resample(double(Dat'),1,ResampleCoef)';
        StartPoints = round(StartPoints/ResampleCoef);
        SegLen = round(SegLen/ResampleCoef);
    end
    [Segs, Complete] = GetSegs(Dat(Channels, :)',  StartPoints, SegLen, IfNotComplete);
    Segs = permute(Segs, [1, 3, 2]);
else
    Segs =[];
    cnt=1;
    if Buffer==0

        for i=1:nSegs

            PositionBegBytes = StartPoints(i)*nChannels*2;
            if length(Channels)==1 
                loadseg = bload(FileName, [1, SegLen], PositionBegBytes+(Channels-1)*2,'short=>double',2*(nChannels-1));
            else
                loadseg = bload(FileName, [nChannels, SegLen], PositionBegBytes,'short=>double');
                loadseg = loadseg(Channels,:);
            end
            if ResampleCoef>1
                Segs(:,:,i) = resample(double(loadseg'),1,ResampleCoef)';
            else
                Segs(:,:,i) = loadseg;
            end

        end
        Segs = permute(Segs, [2, 1, 3]);
%        Segs = Segs(:,Channels,:);

    else
        BufLen = 100000;
        nT= StartPoints(end)+SegLen+2-StartPoints(1);
        Overlap = SegLen+1;
%        nBuf = floor(nT/BufLen)+1;
        nBuf = ceil((nT-BufLen)/(BufLen-2*Overlap)+1);

        curs =0;
        Segs =[];
        for ii=1:nBuf
            if ii==nBuf+1
                keyboard
            end
            SegBeg =(ii-1)*(BufLen-2*Overlap)+StartPoints(1);
            SegEnd =min(SegBeg+BufLen-1,nT)+StartPoints(1);
            curseg = [SegBeg SegEnd];
           % curseg =  [BufLen*(ii-1) BufLen*(ii)] + StartPoints(1);
%            if s>1 & s<ns
%                UseSeg = [Overlap+1 BufferSize-Overlap];
%            elseif s==1
%                UseSeg = [1 BufferSize-Overlap];
%            elseif s==ns
%                UseSeg = [Overlap+1 length(SegInd)];
%            end

            mySegi = find(StartPoints>= curseg(1) & StartPoints< curseg(2));
            myStartPoints = StartPoints(mySegi) - BufLen*(ii-1) - StartPoints(1);
            nmySeg = length(myStartPoints);
            if nmySeg>0
                PositionBegBytes = (BufLen*(ii-1 )+StartPoints(1))*nChannels*2;
                BufSeg = bload(FileName, [nChannels, BufLen], PositionBegBytes);

                %Segs(:,curs+[1:nmySeg],:) = GetSegs(BufSeg(Channels,:)', myStartPoints, SegLen,[]);
                curSegs = GetSegs(BufSeg(Channels,:)', myStartPoints, SegLen,[]);
                Segs = cat(3,Segs,permute(curSegs,[1 3 2]));
                curs=curs+nmySeg;
            end
        end
%        Segs = permute(Segs,[1 3 2]);
    end
%     if isempty(IfNotComplete)
%         Segs(:,setdiff([1:nSamples],Complete),:)= [];
%     end
end

return
