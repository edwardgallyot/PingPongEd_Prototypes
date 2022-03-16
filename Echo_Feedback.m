% ECHO FEEDBACK

clear; clc;

[x, Fs] = audioread("Kick.wav");

x = x(:, 1);

ms = Fs / 1000;

numSamples = length(x);

delayBuffer = zeros(10000, 1);

delayBufferLength = length(delayBuffer);

delayTime = 235 * ms;

readPosition = 1;

writePosition = delayTimeToSamples(delayTime, Fs);

mix = 0.7;

feedback = 0.70;

channels = size(x);

channels = channels(2);



for i = 1:numSamples
    in = x(i);
    
    amount = 10;
    
    rate = 10;
    
    lfo = (amount * sin(2 * pi * (rate / Fs) * i)) + 1; 
    
    fractionalIndex = readPosition + lfo - amount;
    
    out = interpolateCircularSamples(fractionalIndex, delayBuffer);
    
    delayBuffer(writePosition) = in + (out * feedback);
    
    out = mix * out + (1 - mix) * in;
    
    readPosition = mod(readPosition, delayBufferLength - 1) + 1;        
    writePosition = mod(writePosition, delayBufferLength - 1) + 1;
    
    x(i) = out;
end


sound(x, Fs);



