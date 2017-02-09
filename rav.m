%% this script reads all .TXT files with EEG and saves as .MAT file

clear all
close all
clc


%%
listing=dir('DATA/Rest2/*.TXT');
number_of_files = length(listing);



for i=1:number_of_files %WHY not PARFOR?
    eeg = loadeeg(['DATA/Rest2/',listing(i).name], [2]); %1=fp1, 2=fp2
    len = length(eeg)/(250*60);
    if(len<5) %shorter than 10 minuts needs to be exported again
    disp([int2str(i),' ',listing(i).name,' ',num2str(len)])  
    end
    if(i==8 || i==18) %Eric and Sepi were sampled with 500Hz instead of 250
      eeg = eeg(1:2:end); %resampling
    end
    size(eeg)
    dataFP1(i,:) = eeg(1:75000); %75000 for resting, 150000 for IQ

end
FP2_R2 =dataFP1 

save FP2-R2.mat FP2_R2
