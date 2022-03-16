% PING PONG ECHO FEEDBACK
clear; clc;

[x, Fs] = audioread("Jazz_Sax.wav");

ms = Fs / 1000;

numSamples = length(x);


% Create 2 delay buffers for left and right
delayBufferLength = 30000;

delayBufferLeft = zeros(delayBufferLength, 1);

delayBufferRight = zeros(delayBufferLength, 1);

% Set Initial Delay Times
delayTimeLeft = 10 * ms;
delayTimeRight = 20 * ms;

% Set Intial Read and Write Positions
readPositionLeft = delayBufferLength - delayTimeLeft;
readPositionRight = delayBufferLength - delayTimeRight;

writePositionLeft = 1;
writePositionRight = 1;

% Mix and Feedback are simple
mix = 0.50;
feedback = 0.8;

for i = 1:numSamples
    % Get the Left and Right Samples
    
    inLeft = x(i, 1);
    inRight = x(i, 2);
    
    % Complete the LFO Calculations
    
    amount = 400;
    
    rate = 0.2;
    
    lfo = (amount * sin(2 * pi * (rate / Fs) * i)) + 1; 
    
    % Find Fractional Indexes for the read position to sit at
    fractionalIndexLeft = readPositionLeft + lfo - amount;
    fractionalIndexRight = readPositionRight + lfo - amount;
    
    % Calculate the Left Buffer and the Right Buffer at the Read Positions
    wetRight = interpolateCircularSamples(fractionalIndexRight, delayBufferRight);
    wetLeft = interpolateCircularSamples(fractionalIndexLeft, delayBufferLeft);
    
    % Write the buffer on either side with the wet signal of it's opposite
    delayBufferRight(writePositionRight) = inRight + (wetLeft * feedback);
    delayBufferLeft(writePositionLeft) = inLeft + (wetRight * feedback);
    
    % Mix in the Right and Left Signals
    outRight = mix * wetRight + (1 - mix) * inRight;
    outLeft = mix * wetLeft + (1 - mix) * inLeft;
    
    % Increment each ReadPosition
    readPositionLeft = mod(delayBufferLength - delayTimeLeft + writePositionLeft, delayBufferLength);
    readPositionRight = mod(delayBufferLength - delayTimeRight + writePositionRight, delayBufferLength);
    
    %Increment each writePosition
    writePositionLeft = mod(writePositionLeft, delayBufferLength - 1) +  1;
    writePositionRight = mod(writePositionLeft, delayBufferLength - 1) + 1;
    
    % Write the samples out
    x(i, 1) = outLeft;
    x(i, 2) = outRight;
    
    % Testing Moving of Delay Times
     %delayTimeLeft = delayTimeLeft + 0.1;
     %delayTimeRight = delayTimeRight - 0.01;
    
    
end


sound(x, Fs);

audiowrite("test.wav", x, Fs);



