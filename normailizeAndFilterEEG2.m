function filtered_signal = normailizeAndFilterEEG(signal, lpcf, hpcf, samplingrate)
% normalize
%     %% ( 1, a ) Remove high frequencies
%     fresult=fft(signal);
%     fresult(round(signal_length/samplingrate) +  hpcf * samplingrate:...
%         end - round(signal_length/(hpcf * samplingrate)) - hpcf * samplingrate) = 0;
%     %% ( 1, b ) Remove low frequencies
%     fresult(1: lpcf*samplingrate) = 0;
%     fresult(end - lpcf*samplingrate + 1: end) = 0;
%     filtered_signal = real(ifft(fresult));
   b = fir1(24,[0.05 0.1]);
   filtered_signal = filtfilt(b,1,signal);
   %figure, hold on; plot(signal), plot(filtered_signal)
    filtered_signal = (filtered_signal - mean(filtered_signal))/std(filtered_signal);
end 