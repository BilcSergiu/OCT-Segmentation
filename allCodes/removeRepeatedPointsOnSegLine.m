function [ISOS_X, ISOS_Y]=removeRepeatedPointsOnSegLine(ISOS_X, ISOS_Y)

[ISOS_Y, ia, ~] = unique(ISOS_Y,'stable');
ISOS_X = ISOS_X(ia);
