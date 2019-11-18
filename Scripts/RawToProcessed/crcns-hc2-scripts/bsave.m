function bsave(fname, matrix, arg2)
% saves a binary file
% bsave(fname, matrix, arg2)
% uses command fwrite(fp, matrix, arg2);
%
% arg2 specifies a precision - default 'short'

if nargin<3
    arg2 = 'short';
end

fp = fopen(fname, 'w');

fwrite(fp, matrix, arg2);

fclose(fp);