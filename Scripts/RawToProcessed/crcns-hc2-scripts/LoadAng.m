function [Ang] = LoadAng(FileName);

Fp = fopen(FileName, 'r');

if Fp==-1
    error(['Could not open file ' FileName]);
end

Ang = fscanf(Fp, '%f');
fclose(Fp);