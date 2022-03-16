% CUBIC INTERPOLATION DELAY
% A Fractional Non-Integer Delay
% Using Cubic Interpolation

clear; clc;

in = [1, zeros(1, 9)];

fracDelay = 2.7;
intDelay = floor(fracDelay);
frac = fracDelay - intDelay;

buffer = zeros(1, 5);

N = length(in);

out = zeros(1, N);

for n = 1:N
    
    a0 = buffer(1, intDelay + 2) - buffer(1, intDelay + 1) - ...
        buffer(1, intDelay - 1) + buffer(1, intDelay);
    
    a1 = buffer(1, intDelay + 1) - buffer(1, intDelay - 1);
    
    a2 = buffer(1, intDelay + 1) - buffer(1, intDelay - 1);
    
    a3 = buffer(1, intDelay);
    
    out(1, n) = a0 * (frac^3) + a1 * (frac^2) + a2 * frac + a3;
    
    buffer = [in(1, n) buffer(1,1:end-1)];
        
end

disp(['The original input signal was: ', num2str(in)]);
disp(['The original input signal was: ', num2str(out)]);

plot(out);
hold on;

plot(in);



