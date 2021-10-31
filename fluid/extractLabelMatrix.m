function [L] = extractLabelMatrix(BW)

CC = bwconncomp(BW);
L = labelmatrix(CC);

end

