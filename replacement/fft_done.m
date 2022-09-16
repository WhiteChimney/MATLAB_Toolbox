function [X, f] = fft_done(x,dt,Ti)
% Fast Fourier Transformation (FFT) with real amplitude and frequency axis
% adjusted. Frequency range: [fm, fm-df, ..., df, 0, df, ..., fm-df(, fm)]. 

%% Parameters
N = length(x);           % length of fft 
Tf = Ti + (N-1)*dt;      % final time
df = 1/(Tf-Ti);          % frequency interval

if mod(N,2) == 1         % if N is odd
    M = (N-1)/2;
    f = (-M:M).' * df;   % frequency array
else                     % if N is even
    M = N/2;
    f = (-M:M-1).' * df;
end

%% FFT
X_fft = fft(x);   % Fourier Transform from time domain to frequency domain
X_fft = X_fft * dt;        % correct the amplitude in frequency domain
X_shift = fftshift(X_fft); % Shift zero-frequency component to the middle
X = X_shift;          % take the modulus

end