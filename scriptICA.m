load('./Data/fp1_fp3_iq.mat');;
load('./Data/fp1_fp3_memory.mat');
load('./Data/fp1_fp3_rest1.mat')
load('./Data/fp1_fp3_rest2.mat');

load('./Data/fp2_fp4_iq.mat');
load('./Data/fp2_fp4_memory.mat');
load('./Data/fp2_fp4_rest1.mat');
load('./Data/fp2_fp4_rest2.mat');
labels = [1, 2, 3, 4, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 18, 19, 32]; %subjects IDs
good_ind = [2 5 12 13 14 16 17 18];
i = 8
test = [fp2_fp4_rest1(good_ind(i),:); fp1_fp3_rest1(good_ind(i),:)];
input_signals = [];

for i = 1:size(test,1)
    input_signals = [input_signals; (test(i,:) - mean(test(i,:)))/std(test(i,:))];
end

%plotArrayOfTS(input_signals, 'Normalized');

% rb = input_signals(1,:) + input_signals(2,:);
% figure, plot(rb)

[Xw WhiteT Xc V D] = decorrelate(input_signals');

projectSignals = V * input_signals;
projectSignals(1,:) = 0;
F = D;
F(1, 1) = 0.001;
Reconstructed =  inv( V*diag(diag(F).^-0.5)*V') * Xw;
%plotArrayOfTS(Xw, 'Decorrelated');
%plotArrayOfTS(Reconstructed, 'Reconstructed');

for j = 3:18

test = [session_raw_fp1_fp3{5}(j,:); session_raw_fp2_fp4{5}(j,:)];
input_signals = [];
signal_length = length(test);
samplingrate = 250;
filtering_constant = 15;
for i = 1:size(test,1)
    test(i, :) = (test(i,:) - mean(test(i,:)))/std(test(i,:));
    %% ( 1, a ) Remove high frequencies
    fresult=fft(test(i, :));
    fresult(round(signal_length/samplingrate) +  filtering_constant * samplingrate:...
        end - round(signal_length/(filtering_constant * samplingrate)) - filtering_constant * samplingrate) = 0;
    %% ( 1, b ) Remove low frequencies
    fresult(1: samplingrate) = 0;
    fresult(end - samplingrate + 1: end) = 0;
    filtered_signal = real(ifft(fresult));
    %plot(plot_range, filtered_signal(plot_range));
    input_signals = [input_signals; filtered_signal];
end

%plotArrayOfTS(input_signals, 'fp1-fp3, fp2-fp4 electrode pairs');
[icasig, W, A] = ica(input_signals', 'skew');
plotArrayOfTS(icasig', 'ICA');
end
