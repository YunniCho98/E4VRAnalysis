%plot_segments - Plots data with indicators for sequence changes. The data itself is not segmented, we
% just plot all the data as is with vertical lines indicating where the sequence changes occur.
%
%   USAGE:
%       plot_segments(e4_time, e4_values, seq_time, seq_ids)
%       plot_segments(e4_time, e4_values, seq_time, seq_ids, 'Parameter', value, ...)
%
%   INPUT PARAMETERS:
%       e4_time   : Vector of time for the data from the empatica E4.
%       e4_values : Vector of data values from the empatica E4.
%       seq_time  : Vector of time for sequence IDs from the eye-tracker.
%       seq_ids   : Vector of sequence IDs from the eye-tracker.
%
%   OPTIONAL PARAMETERS:
%       'xlabel'    : Label for the x-axis (default 'Time [s]').
%       'ylabel'    : Label for the y-axis (default 'Value').
%       'title'     : Title for the plot (default 'Data with Sequence Change Indicators').
%       'linestyle' : Style for the vertical line indicating sequence change (default '-').
%
%   EXAMPLES:
%       plot_segments(t, v, seq_t, seq_id);
%       plot_segments(t, v, seq_t, seq_id, 'xlabel', 'Time (h)', 'ylabel', 'Amplitude', 'title', 'Sequence Changes', 'linestyle', '--');
%
function segmented_data = plot_segments(e4_time, e4_values, seq_time, seq_ids, vector_gaze, baseline_duration, varargin)
    p = inputParser;
    addParameter(p, 'xlabel', 'Time [s]', @ischar);
    addParameter(p, 'ylabel', 'Value', @ischar);
    addParameter(p, 'title', 'Data with Sequence Change Indicators', @ischar);
    addParameter(p, 'linestyle', '-', @ischar);
    addParameter(p, 'segmentcolors', lines(10), @isnumeric); % Colors for different segments
    addParameter(p, 'linewidth', 1, @isnumeric); % Line width for plot and sequence change indicators

    % Parse the input parameters
    parse(p, varargin{:});
    opts = p.Results;

    % Segment the data
    segmented_data = segment_data(e4_time, e4_values, seq_time, seq_ids, vector_gaze, baseline_duration);

    % Create a new figure
    figure;

    % Plot the overall data with specified line width
    % plot(e4_time, e4_values, opts.linestyle, 'Color', [0.7, 0.7, 0.7], 'LineWidth', opts.linewidth);
    plot(e4_time, e4_values, opts.linestyle, 'Color', [0.7, 0.7, 0.7]);
    xlabel(opts.xlabel);
    ylabel(opts.ylabel);
    title(opts.title);

    xlim([e4_time(1), e4_time(end)]);

    % Hold the plot for adding segmented data and vertical lines
    hold on;

    % Iterate over each segment to plot its data and vertical lines
    for i = 1:length(segmented_data.id_list)
        % Extract segment time, values, and ID
        segment_time   = segmented_data.time{i};
        segment_values = segmented_data.e4_values{i};
        segment_id     = segmented_data.id_list{i};

        % Plot the segmented data
        if ~isempty(segment_time)
            plot(segment_time, segment_values, 'Color', opts.segmentcolors(mod(i, size(opts.segmentcolors, 1)) + 1, :), 'LineWidth', opts.linewidth);
            xline(segment_time(1), '--', {sprintf('ID: %s', segment_id)}, 'LabelOrientation', 'horizontal', 'LabelHorizontalAlignment', 'center');
            %xline(segment_time(1), '--');

        end
    end

    % Release the hold on the plot
    hold off;
end
