function plotArrayOfTS(timeseries, title_fig, x_label, y_label, sampling_rate)

    num_sig = size(timeseries,1);
    
%     for i = 1:num_sig
%         color(i,:) = [ mod(i,3)/3 mod(i, 5)/5 abs(0.5 - i/num_sig)];
%     end

    
    shift = 0;

    figure('Position', [100, 100, 540, 257]), hold on; 

    title(title_fig);
    xlabel(x_label); 
    ylabel(y_label);
    for i = 1:num_sig
        plot((1:length(timeseries(i,:)))/sampling_rate, (timeseries(i,:) + shift));%, 'color', color(i,:)
        line([0, length(timeseries(i,:))/sampling_rate], [shift, shift], 'Color', [0.25 0.25 0.25], 'LineStyle', '--');
        shift = shift + 7*std(timeseries(i,:))
    end

    
end