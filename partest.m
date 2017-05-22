A = zeros(4, 10);
parfor i = 1:4
    for j = 1:10
        A(i, j) = i + j;
    end
    disp(A(i, 1))
end
%%
for k = 1:sessions
    for i = 1:subjects
        data = session_ibi{k}{i};
        SampEntropy(i,k) = SampEn(dim,0.05*r*std(data),data)
        if(isnan(SampEntropy(i,k)) || SampEntropy(i,k)==0) 
            corrupted = 1;
        end
    end
end
%%
A = zeros(4, 10);
parfor i = 1:4
    v = zeros(1, 10);
    for j = 1:10
        v(j) = i + j;
    end
    disp(v(1))
    A(i, :) = v;
end
%%
SampEntropy = zeros(subjects, sessions);
parfor k = 1:sessions
    v = zeros(1, subjects);
    for i = 1:subjects
        data = session_ibi{k}{i};
        v(j) = SampEn(dim,0.05*r*std(data),data);
    end
    SampEntropy(:,k) = v;
end