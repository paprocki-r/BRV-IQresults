function [ eeg ] = loadeeg( filename, columns)

%columns=[22 23]
%filename='1-ERIC-1-VERBAL.TXT'; 

data = load(filename);
size(data);
eeg=data(:,columns);

end

