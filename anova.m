%based on https://www.khanacademy.org/math/statistics-probability/analysis-of-variance-anova-library/analysis-of-variance-anova/v/anova-1-calculating-sst-total-sum-of-squares

v(1,:) = [3 2 1]
v(2,:) = [5 3 4] 
v(3,:) = [5 6 7]

m = size(v,1) %number of vectors; number of groups
n = size(v,2) %size of vector; number of members in each group

for i=1:m  %number of vectors
%mean of the vectors
    mv(i) = mean(v(i,:))
end

mm = mean(mv) %x bar bar - mean of the means (mean across all the vectors)

SST = 0; %total sum of squares (or Sum Squares Total)s
for i=1:m %number of sample vectors
    for j=1:n %size of vector
        SST = SST + (v(i,j)-mm)^2
    end
end

df_SST = m*n-1; %degrees of freedom of SST (number of independent variables)
%% Sum of Squares Within - how much of variation is due to how much of these data points are far from their respective mean (their central tendency)
SSW =0;
for i=1:m %number of sample vectors
    for j=1:n %size of vector
        SSW = SSW + (v(i,j)-mv(i))^2
    end
end
df_SSW = m*(n-1); %degrees of freedom of SSW

%% Sum of Squares Between - how much of variation is between the sample vectors
SSB = 0
for i=1:m %number of sample vectors
    for j=1:n %size of vector
        SSB = SSB + (mv(i) - mm)^2
    end
end
df_SSB = m-1; %degrees of freedom of SSB
%% check if everything is all right
if (SSB + SSW) ~= SST
    error('SSB and SSW are NOT summing up to SST');
end

if (df_SSB + df_SSW) ~= df_SST
    error('DoF of SSB and SSW are NOT summing up to DoF of SST');
end
%% now Fisher test (F-test)
% based on sample mean mv(1) and mv(2), can we say that population mean (1)
% and population mean(2) are the equal (then it means the 'food' does NOT make a difference)? This is hypothesis 0. We can accept
% it for some p, or reject (so we will have hypothesis 1, where population means are NOT equal, and so the 'food' DOES make a difference)
% we assume H_0 is true
% F-statistic - ratio of SSB to SSW (ratio of two Chi statistics so F will
% be also Chi statistic)
%   - if numerator is much bigger than denominator it means the variation
%   in this data is mostly due to the differences between actual means and
%   less due to variation within the means. In that case we can believe
%   there should be a difference between population mean, so there is a
%   higher chance to reject the null hypothesis
%   - if denominator is big, then variation is mostly due to differences
%   between the vectors' means, and so it is probably just random, so it's
%   harder to reject the null hypothesis
F = (SSB/df_SSB)/(SSW/df_SSW)
p = 0.1 %level of significance. It means if there is less than 10% chance of getting the result of we got F, then we reject H_0
%http://www.socr.ucla.edu/Applets.dir/F_Table.html#FTable0.1
Fcritical =  3.46330; %this value has to be read from tables for alpha=p, df_1 = df_SSB, df_2 = df_SSW. 
if(F>Fcritical)
    disp('Null hypothesis rejected'); %so the population means are NOT equal
else
    disp('Null hypothesis accepted'); %so the population means ARE equal
end

%% MATLAB's anova
anova1(v')

%% another approach
vartestn(v')

%%
