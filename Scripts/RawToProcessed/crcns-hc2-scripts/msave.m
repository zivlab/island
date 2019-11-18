% msave - save an integer matrix in an ascii file
%
% msave(filename,matrix,writemode)
%

function msave(filename,matrix,writemode)
if (nargin<3) writemode = 'w'; end
[m,n] = size(matrix);
bufsize = 1000;
if m > bufsize
    nblocks = ceil(m/bufsize);
    
    for i=1:nblocks
        ind = [(i-1)*bufsize+1: min(m,i*bufsize)];
        if i==1 & strcmp(writemode,'w')
            msave(filename, matrix(ind,:), 'w');
        else
            msave(filename, matrix(ind,:), 'a');
        end
    end
else
    formatstring = '%d';
    for ii=2:n,
        formatstring = [formatstring,'\t%d'];
    end
    formatstring = [formatstring,'\n'];
    outputfile = fopen(filename,writemode);
    fprintf(outputfile,formatstring,matrix');
    fclose(outputfile);
end


