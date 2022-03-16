function [out] = interpolateCircularSamples(fractionalIndex, circularBuffer)
%INTERPOLATE_CIRCULAR_SAMPLES Interpolates samples in a circular buffer
%   Taking in a buffer named circularBuffer and a length N
%   as well as a fractional index frac

N = length(circularBuffer);

intIndex = floor(fractionalIndex);
frac = fractionalIndex - intIndex;

index_2 = mod((intIndex + 2), N) + 1;
index_1 = mod(intIndex + 1, N) + 1;
index_0 = mod(intIndex, N) + 1;
index_sub_1 = mod(intIndex - 1, N) + 1;

if intIndex == 0
    index_sub_1 = N;
end


a0 = circularBuffer(index_2) - circularBuffer(index_1) - ...
    circularBuffer(index_sub_1) + circularBuffer(index_0);

a1 = circularBuffer(index_sub_1) - circularBuffer(index_0) - a0;

a2 = circularBuffer(index_sub_1) - circularBuffer(index_0);

a3 = circularBuffer(index_0);

out = a0 * (frac^3) + a1 * (frac^2) + a2 * frac + a3;

end

