function result = composite(M, R, I, E, c)
%COMPOSITE Summary of this function goes here
%   Detailed explanation goes here

result = M.*R + (1-M).*I + (1-M).*(R-E).*c;

end

