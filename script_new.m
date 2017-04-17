%% set data for IQ experiment - order according to https://docs.google.com/spreadsheets/d/1-UhgPMf8TXTCcFVw9tVQPwIuIoxCZbntOK6lWKPFan4/edit?usp=sharing
%{'AbduIQ2.TXT';'AmirIQ.TXT';'ArnoldIQ.TXT';'AsifIQ.TXT';'BinIQ.TXT';'D0000021wayneIQ.TXT';'DozieIQ.TXT';'EricIQ.TXT';'HughIQ.TXT';'IDAIQ.TXT';'JeanIQ.TXT';'JoshuaIQ.TXT';'KhalisIQ.TXT';'MelissaIQ.TXT';'Naveed2IQ.TXT';'NaveedIQ.TXT';'ReaganIQ.TXT';'SepiIQ.TXT';'SimonIQ.TXT';'SouravIQ.TXT';'UsmanIQ.TXT';'VaidasIQ.TXT';'ZaizhenIQ.TXT';'cannisIQ.TXT';'chrisIQ.TXT';'dongjunIQ.TXT';'keunhaIQ.TXT'}

addpath('./SampEn/');

close all; clc; clear all;
load('/media/rav/1A4EEED55AE1928C/research-matlabworkspace/BRV-IQresults/DATA/FP1_IQ.mat')
load('/media/rav/1A4EEED55AE1928C/research-matlabworkspace/BRV-IQresults/DATA/FP1_R1.mat')
load('/media/rav/1A4EEED55AE1928C/research-matlabworkspace/BRV-IQresults/DATA/FP1_R2.mat')

%session_raw{session_nr}(subject_nr,:) = dataFP1(3,:);
subjects = size(FP1_R1,1);
for i=1:subjects
    session_raw{1}(i,:) = FP1_IQ(i,:);
    session_raw{2}(i,:) = FP1_R1(i,:);
    session_raw{3}(i,:) = FP1_R2(i,:);

end

good_ind = [1:subjects];


sessions = size(session_raw,2)
%% we assume, resting stages are same, therefore blinks reflecting them, should have similar statistics

% 1. Removed because resting stages number of blinks is too different
% a) correctly detected
%   good_ind = good_ind(good_ind~=5) 
%   good_ind = good_ind(good_ind~=20)
%remove REVERSED order subjects
% good_ind = good_ind(good_ind~=6);
% good_ind = good_ind(good_ind~=9);
% good_ind = good_ind(good_ind~=14);
% good_ind = good_ind(good_ind~=23);

%BR-R1 and R2 should be similar, so otherwise remove:
%a) BR
% good_ind = good_ind(good_ind~=1);
% good_ind = good_ind(good_ind~=4);
% good_ind = good_ind(good_ind~=6);
% good_ind = good_ind(good_ind~=16);
% %b) std
% good_ind = good_ind(good_ind~=4);
% good_ind = good_ind(good_ind~=11);
% good_ind = good_ind(good_ind~=18);
% good_ind = good_ind(good_ind~=26);
% good_ind = good_ind(good_ind~=27);
% %b) mean
% good_ind = good_ind(good_ind~=4);
% good_ind = good_ind(good_ind~=11);
% good_ind = good_ind(good_ind~=18);
% good_ind = good_ind(good_ind~=26);
% good_ind = good_ind(good_ind~=27);

colors = get(gca,'colororder');close;
colors = [colors; colors; colors; colors];
sampling_rate = 250;
% k = 1;
% for i = 1:length(good_ind)
%     figure, 
%     subplot(2,1,1), hist(session_raw_fp1{k}(good_ind(i),:));
%     subplot(2,1,2), plot(session_raw_fp1{k}(good_ind(i),:));
% end
% bad_ind_s1 = [19 18 7 6 4 1];
% bad_ind_s2 = [19 12 9 8 4];
%% Preprocess EEG by removing low and high frequencies and apply ICA
for k = 1:sessions
    for i = 1:subjects %=size(session_raw{1}, 1)
        i
        session{k}(i, :) = amplify_blinks(session_raw{k}(i,:), session_raw{k}(i,:), sampling_rate);
    end
end

% k = 1;
% for i = 1:length(good_ind)
%     figure, 
%     subplot(2,1,1), hist(session{k}(good_ind(i),:));
%     subplot(2,1,2), plot(session{k}(good_ind(i),:));
% end

%% Detect blinks and form inter-blink intervals

%good_ind = setdiff(1:size(session_raw_fp1{1}, 1), union(bad_ind_s1, bad_ind_s2)); 
clear session_ibi session_beat_pos
plot_detected_beats = 0;
for k =1:sessions
    k
    for i = 1:subjects
        i
        [ibli, maxtab] = extract_ibli(session{k}(i,:), sampling_rate);
        if(isempty(ibli))
            session_ibi{k}{i} = [];
            session_beat_pos{k}{i} = [];
            continue;
        end
         session_ibi{k}{i} = ibli;
         session_beat_pos{k}{i} = [maxtab(:,1) maxtab(:,2)];
         if plot_detected_beats
             figure('Position', [100, 100, 800, 600]), hold on;
             plot(((1:length(session{k}(i,:))))/sampling_rate, session{k}(i,:)); 
             title(['Session = ' num2str(k) ' Subject = ' num2str(i)]);
             plot(maxtab(:,1)/sampling_rate, maxtab(:,2), 'ro', 'MarkerSize', 5);grid on;
             for j = 1:length(maxtab)
                text(maxtab(j,1)/sampling_rate, maxtab(j,2) + 0.1, num2str(j));
             end
         end
    end
end
%% [TO CHECK!!!] blinks detected by hand
%incorrectly detected
false_blinks{1}{9}(1,:)= [38297];
false_blinks{1}{11}(1,:)= [52450];

%undetected
miss_blinks{1}{4}(1,:) = round(250.*[139.3 147.6 183.9 229.5 270 345.1 397.8 404.7 438.2 503.9 521.3 531.1 555 561.1 575.2 585.7 594.2 599.4]);
miss_blinks{1}{5}(1,:) = round(250.*[23.78 114.4 127.2 133.5 164.4 171.6 180.5 221.8 569.5 ]);
miss_blinks{1}{6}(1,:) = round(250.*[49.96 165.4 166.9 170.6 176.4 177.1 179 180.5 181.5 183.3 277.5 382.1 509.4 523.8 538.3 543.1  ])
miss_blinks{1}{9}(1,:) = round(250.*[153.9 244.6 307.6 ]);
miss_blinks{1}{10}(1,:) = round(250.*[471.1 514.2  ]);
miss_blinks{1}{11}(1,:) = round(250.*[149.8 150 196.1 203.8 208.7  219.9 334.8 368.9  384.5 406.8 413.5 415.9 418.9 436.7 473.9 538.1 547 572.8 573.4 584.4 588.3 595  ]);
miss_blinks{1}{12}(1,:) = round(250.*[176 535.9 537.6 541.7 542.8]);
miss_blinks{1}{13}(1,:) = round(250.*[79.29 87.24 91.86 166.2 270.8 301.9 373.3 430.5 436.9 450.6 453.2 513.2 ]);
miss_blinks{1}{14}(1,:) = round(250.*[ 8.828 10.47 11.63 24.16 33.63 33.96 43.3 49.36 65.66 97.72 108.4 109.6 110.3 115.8 128.1 128.4 131 142.4 162.3 165.8 168.9 171.1 171.6 179.1 179.5 189.6 199.1 202.4 208.5 218.5 223.9 248.5 257.4 276.9 286 287.2 294 294.9 295.7 297 300.1 301.9 305 309 314.4 319.3 321.2 323.8 331.2 337.8 339.4 353.8 357.8 358.5 359.5 361.7 364.1 370.1 377.6 390.4 399.8 406.8 438.4 439.2 441.4 442.4 443.7 457.8 461.9 464.6 493 497.6 500.3 520 523.9 536.4 537.4 559.3 563.5 575 590.7]);
miss_blinks{1}{15}(1,:) = round(250.*[441 442.7 446.8 448.6 450.4 453.8 458.7 537.5 541.6 545.3 578.8 ]);
miss_blinks{1}{16}(1,:) = round(250.*[3.144 3.4 8.868 23.48 70.09 82.11 117.6 152 152.6 152.8 194.7 202.1 204.4 221.1 221.3 236.4 252.6 258.5 260.2 285.5 293.2 321.9 326.4 341.4 348.4 356.1 361.5 379.2 380.8 384 387.2 395.7 398.6 405.5 415.5 417 421.1 427.9 453.3 465 480 485.8 488.6 490.7 493.4 501.7 506 508.3 510.9 513.3 516.8 541 544.6 547.2 548.2 548.9 551.8 563.2 565.7 571.3 574.5 576.3 577.7 580.1 581 582 586.7 587.5  594.4 595.7 596.8 598.8]);
miss_blinks{1}{17}(1,:) = round(250.*[18.47 98.36 224.3 231.7 320.2 322.9 386.4 434.7 436.2 442.7 462.6 508.8 577.7 580.5 592.5 598.8]);
miss_blinks{1}{18}(1,:) = round(250.*[106.2 108.2 156.8 162.8 519.8 538.4 540.6 554.4 579.6 589.8 ]);
miss_blinks{1}{19}(1,:) = round(250.*[ 43.83 134.7 150.5 578.1 ]);
miss_blinks{1}{20}(1,:) = round(250.*[ 146.2 414.5 525.1 ]);
miss_blinks{1}{21}(1,:) = round(250.*[282.8 286.7 328.9 332 385.3 401.1 403.9 404.7 512 535.6 536.9 596.7 ]);
miss_blinks{1}{22}(1,:) = round(250.*[161.9 269.4 363.8 589.3]);
miss_blinks{1}{23}(1,:) = round(250.*[481.2 576 577.5 579.1 ]);
miss_blinks{1}{24}(1,:) = round(250.*[2.388 3.276 86.46 173.7 187 435.5 438.7 440 443.8 452.6 453.5 504.8 518  ]);
miss_blinks{1}{25}(1,:) = round(250.*[47.18 48.26 57.02 110.4 135 137.7 139.7 140.2 200.3 293.3 300 324.6 405.8 410.9 455.4 460.5 462.4 471.2 506.4  ]);
miss_blinks{1}{26}(1,:) = round(250.*[58.04 106.4 157.4 176 178.4 180.9 251.2 253.9 256 291.5 293.9 331.8 337.3 359.5 384.5 391.9 426 427.9 428.2 433.1 449.9 453.7 456.9 482.9 507.4 550.9 552 564 566.3 574 ]);
miss_blinks{1}{27}(1,:) = round(250.*[2.212 5.252 21.93 30.68 32.49 44.56 46.83 57.87 62.61 66.88 67.98 70.08 80.67 85.06 87.04 89.93 95.28 98.23 104.4 107.5 111.3 112.8 116.7 128.2 131.6 133.4 135.1 145.6  147.5 149.5 150.6 152.6 156.8 158.9 166.9 168.2 171.3 176.4 183.7 185.4 187.4 195.7 197.2 199.1 202.1 212.1 236.4 239.8 242.4 244.9 246.8 256.7 263.8 275.3 293.3 296 335.6 358.8 359.5 366.9 375.9 380.3 395.2 403.4 408.8 415.3 417.3 431.4 457.3 461.3 468.1 470.3 476.3 485.7 491.5 494.1 497.4 500.3 504.8 506.7 507.6 509.2 515.2 553.2 554.4 555.1 561.5 563.2 566.2 567 579.4 582.5 589.9 597.5]);


miss_blinks{2}{1}(1,:) = round(250.*[3.252 9.924 14.15 15.03 18.72 21.25 23.39 27.12 28.06 28.62 31.74 35.24 37.55 47.57 48.73 50.21 51.22 53.99 65.52 71 86.88 107 116.1 118.7 122.4 134 139.1 140.5 153.3 156.8 158.7 161.6 190.1 193.8 210.2 221.8 224.9 235.4 245.6 249.1 251.3 ]);
miss_blinks{2}{2}(1,:) = round(250.*[4.304 210.1 210.8 215.6 261.4 284.3 297.4]);
miss_blinks{2}{4}(1,:) = round(250.*[139.1 147.6 183.8  270  ]);
miss_blinks{2}{5}(1,:) = round(250.*[6.964 283.2 287.8 ]);
miss_blinks{2}{6}(1,:) = round(250.*[229.7  ]);
miss_blinks{2}{7}(1,:) = round(250.*[2.532 8.464 8.924 144.9 166.9 176.6 182.8 188.2 251.4 299.2 ]);
miss_blinks{2}{8}(1,:) = round(250.*[16.41 198 ]);
miss_blinks{2}{9}(1,:) = round(250.*[198.7 202.7  ]);
miss_blinks{2}{11}(1,:) = round(250.*[5.264 28.1 30.28 36.16  ]);
miss_blinks{2}{13}(1,:) = round(250.*[96.52  ]);
miss_blinks{2}{14}(1,:) = round(250.*[0.404 4.708 5.76 6.432 7.92 9.628 11.39 15.56 17.37 32.92 40.55 58.02 79.42 91 102.2 121.9 127.7 163.1 166.8 168.6 175.2 176.3 177.9 188.2 190.3 193.5 200.3 201.1 210.5 225 259.9 269.1 275.3 298.1 ]);
miss_blinks{2}{16}(1,:) = round(250.*[0.892 14.86 25.13 29.74 30.42 42.91 48.25 50.25 51.11 51.82 52.56 54.24 68.1 69.01 80.07 119.6 125 127.8 134.4 139.8 143 147.8 155 155.8 159.5 160.3 161.4 165.3 167.8 172.1 174 176.2 177.7 179.3 182.8 187 189.3 190.3 200.8 207.4 209 210.1 211.7 215.5 216.2 217.9 218.8 223.7 225.5 227.8 238.8 242.8 252.1 253 253.9 256.8 258.6 259.1 259.8 260.8 264.6 265.6 266.5 267.4 268.3 269 269.7 270.6 280.6 281.5 282.2 282.9 285 285.7 286.2 290.1 291.4 292 293.8 295.5   ]);
miss_blinks{2}{17}(1,:) = round(250.*[13.05 17.45 19.61 23.54 25.31 27.57 43.44 47.6 55.57 58.89 59.44 62.7 63.81 67.01 77.18 79.67 86.64 102.7 118.4 127.9 130.6 131.2 144.1 145.4 148.4 181.9 187.1 187.9 192 192.9 197.5 208.4 213.1 213.8 216.4 219.4 222.9 223.8 225 226.2 226.8 227.5 234.2 236.9 243.9 245.1 248.5 251.3 265.9 268.2 277.1 280.1 280.7 281.7   ]);
miss_blinks{2}{18}(1,:) = round(250.*[24.54 47.71 87.35 121.4 152.4 166 168.3 185.3 212.5  ]);
miss_blinks{2}{19}(1,:) = round(250.*[101.8 148.6  272.5 288.5 290.4 296.1 296.5 299.4 ]);
miss_blinks{2}{20}(1,:) = round(250.*[82.42 94.58 116.4 161.5 174.3 206.7 278.5 ]);
miss_blinks{2}{21}(1,:) = round(250.*[12.69 197.1 207.3 234.1 ]);
miss_blinks{2}{22}(1,:) = round(250.*[ 6.296 11.73 12.16 44.09 64.86 67.96 75.34 94.84 101.8 123.2 167.1 202 256 297.6 ]);
miss_blinks{2}{23}(1,:) = round(250.*[10.76 13.08 24.24 107.7 180.1]);
miss_blinks{2}{24}(1,:) = round(250.*[139.5 220.5]);
miss_blinks{2}{25}(1,:) = round(250.*[0.584 57.18 59.21 74.91 203.7 206.2 ]);
miss_blinks{2}{26}(1,:) = round(250.*[128.9 211.1 214.7 233.6 241.8 288 297.3 ]);
miss_blinks{2}{27}(1,:) = round(250.*[69.56 ]);



miss_blinks{3}{1}(1,:) = round(250.*[0.292 8.936 53.98 98.7 101.2 121.1 140.2 145.9 147.9 156.7 165.1 172.8 227.8 242.6 261.2 ]);%@TODO: false, check from the beginning
miss_blinks{3}{2}(1,:) = round(250.*[93.54 ]);
miss_blinks{3}{4}(1,:) = round(250.*[35.42  ]);
miss_blinks{3}{5}(1,:) = round(250.*[51.99 219.7 244.6 ]);
miss_blinks{3}{8}(1,:) = round(250.*[5.896 183.2 291.3 ]);
miss_blinks{3}{9}(1,:) = round(250.*[220 ]);
miss_blinks{3}{10}(1,:) = round(250.*[20.97 23.47 35.61 112.7 115 146.1 150.6 151.9 158.9 176 178.9 201.4 217.7 271.3 272.4 ]);
miss_blinks{3}{11}(1,:) = round(250.*[25.9 107.9  ]);
miss_blinks{3}{14}(1,:) = round(250.*[5.352 8.724 17.19 79.06 300]);
miss_blinks{3}{17}(1,:) = round(250.*[74.14 ]);
miss_blinks{3}{18}(1,:) = round(250.*[141.2 143.5 181.5 ]);
miss_blinks{3}{19}(1,:) = round(250.*[202.8 208.2 ]);
miss_blinks{3}{20}(1,:) = round(250.*[12.26 75.86  ]);
miss_blinks{3}{22}(1,:) = round(250.*[298.6 ]);%@TODO: false, check from the beginning
miss_blinks{3}{23}(1,:) = round(250.*[68 70.68 106.6 116 126.7 139.1 226.5 ]);%@TODO: false, check from the beginning
miss_blinks{3}{25}(1,:) = round(250.*[45.08 59.57 68.05 69.45 156.1 ]);%@TODO: false, check from the beginning

%% Merge manual detection with automatic detection
plot_detected_beats=0;
for k = 1:sessions
    for i = 1:subjects
        if (i <= length(miss_blinks{k}) & ~isempty(miss_blinks{k}{i}))
            session_beat_pos_corrected{k}{i} = sort(union(miss_blinks{k}{i}, session_beat_pos{k}{i}(:,1)));
            session_beat_pos_corrected{k}{i}(:,2) = session{k}(i,session_beat_pos_corrected{k}{i});
            session_ibi{k}{i} = diff(session_beat_pos_corrected{k}{i}(:,1))  / sampling_rate;
        else
            if(~isempty(session_beat_pos{k}{i}))
                session_beat_pos_corrected{k}{i} = session_beat_pos{k}{i}(:,1);
                session_beat_pos_corrected{k}{i}(:,2) = session{k}(i,session_beat_pos_corrected{k}{i});
                session_ibi{k}{i} = diff(session_beat_pos_corrected{k}{i}(:,1)) / sampling_rate;
            end
        end
        
         if plot_detected_beats
             figure('Position', [100, 100, 800, 600]), hold on;
             plot(((1:length(session{k}(i,:))))/sampling_rate, session{k}(i,:)); 
             title(['Session = ' num2str(k) ' Subject = ' num2str(i)]);
             plot(session_beat_pos{k}{i}(:,1)/sampling_rate, session_beat_pos{k}{i}(:,2), 'ro', 'MarkerSize', 5);grid on;
             plot(session_beat_pos_corrected{k}{i}(:,1)/sampling_rate, session_beat_pos_corrected{k}{i}(:,2), 'bo', 'MarkerSize', 10);grid on;
               
             for j = 1:length(session_beat_pos_corrected{k}{i})
                text(session_beat_pos_corrected{k}{i}(j,1)/sampling_rate, session_beat_pos_corrected{k}{i}(j,2) + 0.1, num2str(j));
             end
         end
         
    end
end
      %% 
% check if merging detected blinks and manually added blinks is correct
% for k=1:sessions
%     for i=1:size(miss_blinks{k},2)
%         if(~isempty(miss_blinks{k}{i}))
%         
%         detected = length(session_beat_pos{k}{i}(:,1));
%         manually = length(miss_blinks{k}{i}(1,:));
%         result = length(session_beat_pos_corrected{k}{i}(:,1));
%             if detected + manually ~= result
%                disp([int2str(i),' incorrect']); 
%             end
%         end
%     end
% end %no message? Everything is correct:)
%% Calcualte number of blinks for each patient during each of five stages
% save ibi.mat session_ibi good_ind;
% save workspace.mat;
for k = 1:sessions %sessions
    for i = 1:size(session_ibi{k},2);
        session_ibi_len(k,i) = length(session_ibi{k}{i});
    end
end

%session_ibi_len(2,:) = session_ibi_len(2,:) /1 ; %taking first 5 IQ min.
%statistics for number of blinks
[mean(session_ibi_len(:,good_ind)'); std(session_ibi_len(:,good_ind)')]

% Draw BRV for every session
% drawBRVarray(session_ibi, good_ind, session_ibi_len);

%% Calcualte mean and standard deviation for BRV
clear session_ibi_stat
for k = 1:sessions
    for i = 1:length(good_ind)
        session_ibi_stat(good_ind(i),:,k) = [mean(session_ibi{k}{good_ind(i)}) std(session_ibi{k}{good_ind(i)}) std(diff(session_ibi{k}{good_ind(i)}))];
    end
end
figure;plotBlinkMeanPerSubject(session_ibi_stat, good_ind, session_ibi_len);grid on;
figure;plotBlinkNumberPerSubject(session_ibi_len, good_ind);grid on;
figure;plotBlinkStdPerSubject(session_ibi_stat, good_ind, session_ibi_len);grid on;
figure;plotBlinkRMSSDPerSubject(session_ibi_stat, good_ind, session_ibi_len);grid on;

%% Estimate multifractal spectrum for BRV
good_ind = [1:subjects];

L = round(2.^[2:0.25:5])
%L = L(1:10);
Q =  [-12:3:15];
sessions1 =  [1 2 3];%[1 2 3 4 5 3 3 2 2 4];
sessions2 =  [2 3 1];%[2 3 4 5 2 4 5 4 5 5];
flag_lda = 0;
exponents = drawBRV_FS(Q, L, session_ibi, good_ind, sessions1, sessions2, flag_lda);
a_min_IQ = exponents(1:3:end,1); %a_min = q_max
a_peak_IQ = exponents(2:3:end, 1);%a_peak = q_0
a_max_IQ = exponents(3:3:end, 1);%a_max = q_min

a_min_R1 = exponents(1:3:end,2); %a_min = q_max
a_peak_R1 = exponents(2:3:end, 2);%a_peak = q_0
a_max_R1 = exponents(3:3:end, 2);%a_max = q_min


a_min_R2 = exponents(1:3:end,3); %a_min = q_max
a_peak_R2 = exponents(2:3:end, 3);%a_peak = q_0
a_max_R2 = exponents(3:3:end, 3);%a_max = q_min

% scores calculated manually in https://docs.google.com/spreadsheets/d/1-UhgPMf8TXTCcFVw9tVQPwIuIoxCZbntOK6lWKPFan4/edit#gid=0
% order according to subject ids [1:27]
IQ_test_scores = [4 5 4 1 2 2 7 2 2 4 2 3 6 5 3 3 2 2 4 5 4 6 6 0 8 6 3]; %score: 1-correct, 0-incorrect, 0-no answer
%IQ_test_scores = [-5 -3 -5 -11 -9 -9 1 -9 -9 -5 -9 -7 -1 -3 -7 -7 -9 -9 -5 -3 -5 -1 -1 -13 3 -1 -7]; %score: 1-correct, -1-incorrect, 0-no answer


%%
good_ind = [1:subjects];

%they were sleeping during experiment - confirmed with video
good_ind = good_ind(good_ind~=8);
good_ind = good_ind(good_ind~=24);

%negative alphas
good_ind = good_ind(good_ind~=1);%negative R1!!!
good_ind = good_ind(good_ind~=4);%negative IQ and R1
good_ind = good_ind(good_ind~=12);%negative IQ and R1
good_ind = good_ind(good_ind~=15);%negative IQ and R1

%test
good_ind = good_ind(good_ind~=3);%small IQ!!!



%% figures

h(1) = figure;
    stem(good_ind, a_peak_IQ(good_ind)); hold on;stem(good_ind, a_peak_R1(good_ind)); hold on; stem(good_ind, a_peak_R2(good_ind)); 
    title({'$\alpha_{peak} of IQ(blue), R1(red), R2(yellow)$'},'Interpreter','latex');
    grid on;

h(2) = figure;
    y = (a_peak_R1(good_ind));
    x = IQ_test_scores(good_ind);
[r,p]=corrcoef(x,y);
% r(1,2) %correlation coefficient r
% p(1,2) %significance level - as small the better

    stem(x,y, 'Marker', 'o', 'color', 'r', 'markersize', 18);
    txt = mat2cell(good_ind,1,ones(1,size(good_ind,2)));
    text(x,y, ....
    txt, 'color', 'b');
    xlabel('scores');
    ylabel('\alpha_{peak}');
    title({'IQ results vs $\alpha_{peak}$ Rest 1. R=',r(1,2),' with p=',p(1,2)},'Interpreter','latex');
    grid on;
% @TODO: correct figures below            
h(3) = figure;
    y = (a_peak_R2(good_ind));
    x = IQ_test_scores(good_ind);
[r,p]=corrcoef(x,y);

    stem(x,y, 'Marker', 'o', 'color', 'r', 'markersize', 18);
    txt = mat2cell(good_ind,1,ones(1,size(good_ind,2)));
    text(x,y, ....
    txt, 'color', 'b');
    xlabel('scores');
    ylabel('\alpha_{peak}');
    title({'IQ results vs $\alpha_{peak}$ of Rest 2. R=',r(1,2),' with p=',p(1,2)},'Interpreter','latex');
    grid on;
            
h(4) = figure;
    y = abs(a_peak_IQ(good_ind));
    x = IQ_test_scores(good_ind);
[r,p]=corrcoef(x,y);
 
    stem(x,y, 'Marker', 'o', 'color', 'r', 'markersize', 18);
    txt = mat2cell(good_ind,1,ones(1,size(good_ind,2)));
    text(x,y, ....
    txt, 'color', 'b');
    xlabel('scores');
    ylabel('\alpha_{peak}');
    title({'IQ results vs $\alpha_{peak}$ of IQ. R=',r(1,2),' with p=',p(1,2)},'Interpreter','latex');
    grid on;
    %%
h(5) = figure;
figure('Position', [100, 100, 600, 400])

    x = (a_peak_R1(good_ind));
      %x=(x-mean(x))/std(x);

    y = IQ_test_scores(good_ind);
     %  y=(y-mean(y))/std(y);

   
[r,p]=corrcoef(x,y)
plot(x,y,'.', 'Marker', '.', 'color', 'r', 'markersize', 20, 'linewidth',3);
axis([0.3 1.4 1.6 8.6])
    hold on
    a = polyfit(x,y',1); %fit polynomial using MSE (find a and b of y=ax+b)
    yhat=a(1)*x+a(2); %regression line
    plot(x,yhat, 'linewidth',3)
    text(x-0.02,y+0.3, txt, 'color', 'black', 'fontsize',10);
    ylabel('IQ scores');
    xlabel('\alpha of resting');
   % title({'IQ results vs $\alpha $R1. R=',r(1,2),' with p=',p(1,2)},'Interpreter','latex');
    grid on;
   

%% save figures
for i=1:length(h)
    t = ['c',int2str(i),'.fig']
    savefig(h(i),t);
end

%% ANOVA for alpha_peak

 %general test
data = [a_peak_IQ(good_ind) a_peak_R1(good_ind)];
 [P,ANOVATAB,STATS] = anova1(data) %it shows that IQ and R1 have different a_peak (in terms of population)
 
 %% ANOVA for differences between BR of IQ and rest
data = [session_ibi_len(2,good_ind); session_ibi_len(1,good_ind)]; 
[P_ALPHA_IQ,ANOVATAB,STATS] = anova1(data')

 %2 R1 groups comparison - above and below median score
test = [1:length(good_ind); IQ_test_scores(good_ind)]'
avg_score = median(test(:,2));
g1 = test(test(:,2)>avg_score,:);length(g1)
g2 = test(test(:,2)<=avg_score,:);length(g2)
g1_a_peak_R1 = a_peak_R1(good_ind(g1(:,1)));
g2_a_peak_R1 = a_peak_R1(good_ind(g2(:,1)));
data = [g1_a_peak_R1(1:end); g2_a_peak_R1]; %we have to drop 1 subjects-vectors have to be equal!
 names = {'gp1','gp1','gp1','gp1','gp1','gp1','gp1','gp1','gp2','gp2','gp2','gp2','gp2','gp2','gp2','gp2','gp2','gp2','gp2','gp2'};
[P_ALPHA_R1,ANOVATAB,STATS] = anova1(data, names')

%3. IQ groups comparison - above and below median score
g1_a_peak_IQ = a_peak_IQ(good_ind(g1(:,1)))';
g2_a_peak_IQ = a_peak_IQ(good_ind(g2(:,1)))';
data = [g1_a_peak_IQ(1:end) g2_a_peak_IQ];
[P_ALPHA_IQ,ANOVATAB,STATS] = anova1(data, names)


%% ANOVA FOR BR
%  %R1 groups comparison - above and below median score
% g1_BRV_R1 = session_ibi_len(2,good_ind(g1(:,1)));
% g2_BRV_R1 = session_ibi_len(2,good_ind(g2(:,1)));;
% data = [g1_BRV_R1(1:end), g2_BRV_R1]; %we have to drop 1 subjects-vectors have to be equal!
% [P_BRV_R1,ANOVATAB,STATS] = anova1(data, names)
% 
% %IQ groups comparison
% g1_BRV_IQ = session_ibi_len(1,good_ind(g1(:,1)));
% g2_BRV_IQ = session_ibi_len(1,good_ind(g2(:,1)));;
% data = [g1_BRV_IQ(1:end), g2_BRV_IQ]; %we have to drop 1 subjects-vectors have to be equal!
% [P_BRV_IQ,ANOVATAB,STATS] = anova1(data, names)

% %% ANOVA's results for table 2 in latex - NL journal
% disp(['1 & ','$',num2str(mean(g1_BRV_R1/5), '%.2f'),' \pm ', num2str(std(g1_BRV_R1/5), '%.2f'),'$ & $ ',...
%     num2str(mean(g1_a_peak_R1), '%.2f'),' \pm ', num2str(std(g1_a_peak_R1), '%.2f'),'$ & $ ',...
%     num2str(mean(g1_BRV_IQ/10), '%.2f'),' \pm ', num2str(std(g1_BRV_IQ/10), '%.2f'),'$ & $ ',...
%     num2str(mean(g1_a_peak_IQ), '%.2f'),' \pm ', num2str(std(g1_a_peak_IQ), '%.2f'),'$ \\ \hline']);
% 
% disp(['2 & ','$',num2str(mean(g2_BRV_R1/5), '%.2f'),' \pm ', num2str(std(g2_BRV_R1/5), '%.2f'),'$ & $ ',...
%     num2str(mean(g2_a_peak_R1), '%.2f'),' \pm ', num2str(std(g2_a_peak_R1), '%.2f'),'$ & $ ',...
%     num2str(mean(g2_BRV_IQ/10), '%.2f'),' \pm ', num2str(std(g2_BRV_IQ/10), '%.2f'),'$ & $ ',...
%     num2str(mean(g2_a_peak_IQ), '%.2f'),' \pm ', num2str(std(g2_a_peak_IQ), '%.2f'),'$ \\ \hline']);
% 
% disp(['$p$ & ','$',num2str((P_BRV_R1), '%.3f'),'$ & $ ',...
%      num2str((P_ALPHA_R1), '%.3f'),'$ & $ ',...
%    num2str((P_BRV_IQ), '%.3f'),'$ & $ ',...
%     num2str((P_ALPHA_IQ), '%.3f'),'$ \\ \hline']);
% 

%% print data for latex table 1
% ump = [1:length(good_ind)]
% table = [good_ind' session_ibi_len(2,good_ind)' a_peak_R1(good_ind) session_ibi_len(1,good_ind)' a_peak_IQ(good_ind) IQ_test_scores(good_ind)']
% %% a_peak norm plots for all subjects
% x = [-0.2:0.01:1.6]
% 
% normR1 = normpdf(x,mean(a_peak_R1(good_ind)),std(a_peak_R1(good_ind)));
% normR2 = normpdf(x,mean(a_peak_R2(good_ind)),std(a_peak_R2(good_ind)));
% normIQ = normpdf(x,mean(a_peak_IQ(good_ind)),std(a_peak_IQ(good_ind)));
% figure;
% plot(x,normIQ,'LineWidth',2); hold on;
% plot(x,normR1,'LineWidth',2); hold on;
% %plot(x,normR2); hold on;
% x = zeros(1,length(a_peak_IQ(good_ind)));
% stem(a_peak_IQ(good_ind), x,':b','MarkerSize',10,'LineWidth', 2); hold on;
% stem(a_peak_R1(good_ind), x,':xr','MarkerSize',10,'LineWidth', 2); hold on;
% %stem(a_peak_R2(good_ind), x,':xy','MarkerSize',10,'LineWidth', 4); grid on;
% legend('IQ','Rest','Location','NorthEast')

% %% a_peak norm plots for 2 groups - smarter (1) and less smart (2)
% x = [0:0.01:1.8]
% 
%  colors =[ 0    0.4470    0.7410   ;  0.8500    0.3250    0.0980];
% 
% 
% norm1R1 = normpdf(x,mean(g1_a_peak_R1),std(g1_a_peak_R1));
% norm2R1 = normpdf(x,mean(g2_a_peak_R1),std(g2_a_peak_R1));
% figure('Position', [100, 100, 600, 400])
% 
% plot(x,norm1R1,'color',colors(1,:),'LineWidth',2); hold on;
% plot(x,norm2R1,'color',colors(2,:),'LineWidth',2); hold on;
% 
% %plot(x,normR2); hold on;
% norm1IQ = normpdf(x,mean(g1_a_peak_IQ),std(g1_a_peak_IQ));
% norm2IQ = normpdf(x,mean(g2_a_peak_IQ),std(g2_a_peak_IQ));
% % norm1IQ = (norm1IQ -mean(norm1IQ))/std(norm1IQ)
% % norm2IQ = (norm2IQ -mean(norm2IQ))/std(norm2IQ)
% plot(x,norm1IQ,':','color',colors(1,:),'LineWidth',2); hold on;
% plot(x,norm2IQ,':','color',colors(2,:),'LineWidth',2); hold on;
% legend({'$\alpha$ resting of $IQ^+$','$\alpha$ resting of $IQ^-$','$\alpha$ IQ test of $IQ^+$','$\alpha$ IQ test of $IQ^-$'},'Interpreter','latex', 'FontSize',14)
% xlabel({'$\alpha$'},'Interpreter','latex')
%% normality test (should be in the beginning :P)
% clc
% for i=1:sessions
%     for j=1:subjects
%        [H, pValue, SWstatistic]=  swtest(session_ibi{1,i}{j});
%        if(H==0) 
%            disp(['session' num2str(i),' subject ',num2str(i)]);
%        end
%     end
% end
% %% SampEn
% close all
% 
% 
% good_ind = [1:subjects];
% good_ind = good_ind(good_ind~=4); %here is NAN so we have to remove it or we won't get PDF
% 
% test = [1:length(good_ind); IQ_test_scores(good_ind)]'
% avg_score = median(test(:,2));
% g1 = test(test(:,2)>=avg_score,:);length(g1)
% g2 = test(test(:,2)<avg_score,:);length(g2)
%     
% for dim=1:20
%     for r=1:20
%        corrupted = 0;
%     % SampEn    
%         for k = 1:sessions
%             for i = 1:subjects
%                 data = session_ibi{k}{i};
%                 SampEntropy(i,k) = SampEn(dim,0.05*r*std(data),data)
%                 if(isnan(SampEntropy(i,k)) || SampEntropy(i,k)==0) 
%                     corrupted = 1;
%                 end
%             end
%         end
% 
%     %ANOVA  
%         if (~corrupted)
%             g1_a_peak_R1 = SampEntropy(good_ind(g1(:,1)),2);
%             g2_a_peak_R1 = SampEntropy(good_ind(g2(:,1)),2);
%             data = [g1_a_peak_R1; g2_a_peak_R1]; %we have to drop 1 subjects-vectors have to be equal!
%              names = {'gp1','gp1','gp1','gp1','gp1','gp1','gp1','gp1','gp1','gp1','gp1','gp1','gp1','gp1',...
%                          'gp2','gp2','gp2','gp2','gp2','gp2','gp2','gp2','gp2','gp2','gp2','gp2'}; %all but 4th
%             [P,ANOVATAB,STATS] = anova1(data, names', 'off');
%             results(dim, r) = P;
%         end
%     end
% end
% 
%  [dim_R,r_R] = find(results==min(results(:)))
% disp(['Minimum ',num2str(min(results(:))),' we got for dim = ',num2str(dim_R),' and r = ',num2str(r_R*0.05), '*std(data)']);
% %% PDF for all1
% close all
% colors =[ 0    0.4470    0.7410   ;  0.8500    0.3250    0.0980; 0.8500    0.3250    0.9980];
% 
% 
% tempSampEntropy=SampEntropy([good_ind],:);
% 
% x = [-1:0.1:5]
% normR1 = normpdf(x,mean(tempSampEntropy(:,1)),std(tempSampEntropy(:,1)));
% normR2 = normpdf(x,mean(tempSampEntropy(:,2)),std(tempSampEntropy(:,2)));
% normR3 = normpdf(x,mean(tempSampEntropy(:,3)),std(tempSampEntropy(:,3)));
% 
% figure;
% plot(x,normR1,'color',colors(1,:),'LineWidth',2); hold on;
% plot(x,normR2,'color',colors(2,:),'LineWidth',2); hold on;
% plot(x,normR3,'color',colors(3,:),'LineWidth',2); hold on;

%%
% save workspace.mat
%%
sec=10:20:300;
results=zeros(2,15);
for pp=1:length(sec)
    
    seconds = sec(pp);
    %
    powers=zeros(2, length(good_ind));
    for k=1:length(good_ind) %subject
        i = good_ind(k);
    s=1;%IQ - 10 minutes
    session_length = 10;    
        slength = length(session_ibi{s}{i});
        BR = slength/(session_length*60); %BR per second
        scope = round(BR*seconds);
        [C,LAGS] = xcorr(session_ibi{s}{i},session_ibi{s}{i},slength, 'coeff');
       % figure; plot(LAGS, C)
%         axis([-scope, scope, min(C), max(C)])    
    powers(1,k) = sum(C(round(length(C)/2)-scope:round(length(C)/2)+scope));
    s=2;%Rest1 - 5 minutes
    session_length = 5;

        slength = length(session_ibi{s}{i});
        BR = slength/(session_length*60); %BR per second
        scope = round(BR*seconds);
        [C,LAGS] = xcorr(session_ibi{s}{i},session_ibi{s}{i},slength, 'coeff');
        hold on;
 %   plot(LAGS, C)
        axis([-scope, scope, min(C), max(C)])  ;  
    powers(2,k) = sum(C(round(length(C)/2)-scope:round(length(C)/2)+scope));
    end
    
results(1,pp) = sec(pp);
results(2,pp) = sum(powers(1,:)>powers(2,:));
end