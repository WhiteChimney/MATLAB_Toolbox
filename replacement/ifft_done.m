function [x, t] = ifft_done(X,df,Ti)
% Inverse Fast Fourier Transformation (IFFT) with real output signals in
% time space.

%% Parameters
N = length(X);            % length of vector
Tf = Ti + 1/df;           % final time
t = linspace(Ti,Tf,N);    % time vector

%% FFT
X_fft = ifftshift(X);     % shift the 0 frequency back to the first place
x_ifft = ifft(X_fft);     % inverse FT from frequency domain to time domain
x = x_ifft * df * N;      % as in ifft, x = 1/N(sum(X*W)), see fft help

end