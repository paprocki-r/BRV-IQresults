%Biploar electrode placement
function [session_raw_fp1_fp3 session_raw_fp2_fp4] = readSplitFrontElectrodes(path)
    counter = 0;
    labels = [];
    for i = 1:40
        i
        file_resting_1 = [path num2str(i) '-1.txt'];
        file_resting_2 = [path num2str(i) '-3.txt'];
        file_iq = [path num2str(i) '-2.txt'];
        file_memory = [path num2str(i) '-4.txt'];
        if exist(file_resting_1, 'file')
            counter = counter + 1;        
            temp_resting_1 = importdata(file_resting_1, ' ', 0);
            temp_resting_2 = importdata(file_resting_2, ' ', 0);
            temp_iq = importdata(file_iq, ' ', 0);
            temp_memory = importdata(file_memory, ' ', 0);
            labels(counter) = i;
            fp2_fp4_rest1(counter, :) = temp_resting_1(:,9);
            fp1_fp3_rest1(counter, :) = temp_resting_1(:,13);
            fp2_fp4_rest2(counter, :) = temp_resting_2(:,9);
            fp1_fp3_rest2(counter, :) = temp_resting_2(:,13);
            fp2_fp4_iq(counter, :) = temp_iq(:,9);
            fp1_fp3_iq(counter, :) = temp_iq(:,13);
            fp2_fp4_memory(counter, 1:length(temp_memory(:,9))) = temp_memory(:,9);
            fp1_fp3_memory(counter, 1:length(temp_memory(:,13))) = temp_memory(:,13);
        end
    end
    
	for i = 1:size(fp1_fp3_rest1,1)
        session_raw_fp1_fp3{1}(i,:) = fp1_fp3_rest1(i,:);
        session_raw_fp1_fp3{2}(i,:) = fp1_fp3_iq(i,:);
        session_raw_fp1_fp3{3}(i,:) = fp1_fp3_rest2(i,:);
        session_raw_fp1_fp3{4}(i,:) = fp1_fp3_memory(i,1:75000);
        session_raw_fp1_fp3{5}(i,:) = fp1_fp3_memory(i,75001:end);

        session_raw_fp2_fp4{1}(i,:) = fp2_fp4_rest1(i,:);
        session_raw_fp2_fp4{2}(i,:) = fp2_fp4_iq(i,:);
        session_raw_fp2_fp4{3}(i,:) = fp2_fp4_rest2(i,:);
        session_raw_fp2_fp4{4}(i,:) = fp2_fp4_memory(i,1:75000);
        session_raw_fp2_fp4{5}(i,:) = fp2_fp4_memory(i,75001:end);    
	end

end