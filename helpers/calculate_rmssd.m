function rmssd = calculate_rmssd(IBI)
    % This function calculates RMSSD for a given IBI data ignoring NaN values

    % Remove NaN values from IBI
    IBI = IBI(~isnan(IBI));

    % Calculate successive differences
    successive_diffs = diff(IBI);

    % Square the differences
    squared_diffs = successive_diffs .^ 2;

    % Compute mean of squared differences
    mean_squared_diff = mean(squared_diffs, "omitnan");

    % Compute RMSSD
    rmssd = sqrt(mean_squared_diff);
end
