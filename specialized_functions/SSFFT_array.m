function [waveform, f_spectrum] = SSFFT_array(step_num, sum_distance, recard_step, GVD_array, N, input_waveform, tau, omega)% split-step fast Fourier transform
    input_waveform = input_waveform.';
    % tau = tau.';
    omega = omega.';
    nt = length(input_waveform);
    waveform = zeros(nt, recard_step + 1);
    f_spectrum = zeros(nt, recard_step + 1);
    uu_array = zeros(nt, recard_step + 1);
    inverl = step_num / recard_step;
    deltaz = sum_distance / step_num; % step size in z

    % ---set the initialization parameters
    beta2 = GVD_array(1); %The second order dispersion
    beta3 = GVD_array(2); %The third order dispersion

    uu = input_waveform ./ abs(max(input_waveform)); % normalized amplitude

    dispersion = exp(deltaz * (...
        (1i * beta2 / 2 * omega.^2) + ...
        (1i * beta3 / 6 * omega.^3))); %phase factor

    hhz = 1i * N^2 * deltaz; % nonlinear phase factor

    % **********[Beginning of MAIN Loop]**********
    % scheme:1/2N->D->1/2N; first half step nonliner
    x = 1;
    uu_array(:, x) = uu;

    for n = 1:step_num

        temp = fft(ifft(uu) .* dispersion);
        uu = temp .* exp(hhz .* abs(temp).^2);

        if mod(n, inverl) == 0
            x = x + 1;
            uu_array(:, x) = uu;
        end

    end

    waveform = abs(uu_array).^2;
    f_spectrum = fft(uu_array, [], 1);
    f_max = max(abs(f_spectrum(:, 1)));
    f_spectrum = abs(fftshift(f_spectrum, 1) / f_max).^2;

    waveform = waveform.';
    f_spectrum = f_spectrum.';
    % **********[End of MAIN Loop]**********
end