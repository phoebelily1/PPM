clc
close all
warning off

% Initialize video reader
v = VideoReader('video2.mp4'); % replace with your video name
numFrames = v.NumFrames;

% Set number of frames to process
n = 200;
coords_matrix = zeros(n, 2);

for i = 1:min(n, numFrames)
    
    e = read(v, i); % read ith frame of the video
    
    f = createMask(e); % apply mask function

    numf = sum(f(:) == 1); % compute number of white pixels

    [f_col, f_row] = find(f.'); % locate row and column of white pixels
    f_coords = [f_col, f_row];
    
    if numf > 0
        f_centroid = sum(f_coords) / numf; % calculate centroid of object
        coords_matrix(i, 1:2) = f_centroid; % assign centroid to coords_matrix
    else
        coords_matrix(i, 1:2) = [NaN, NaN]; % handle frames with no white pixels
    end
end

% Save coordinates to a text file
fileID = fopen('plot.txt', 'w');
fprintf(fileID, '%6.2f %12.8f\n', coords_matrix.');
fclose(fileID);

% Extract Y coordinates and calculate peak-to-peak scaling factor
Y_pixels = coords_matrix(:, 2);  % Second column is Y
Y_pixels = Y_pixels - min(Y_pixels); % Normalize to start from 0

% Calculate scaling factor to convert pixels to cm (peak-to-peak is 10 cm)
y_range_pixels = max(Y_pixels) - min(Y_pixels);
scaling_factor = 8 / y_range_pixels;  % 10 cm peak-to-peak

% Scale Y coordinates to cm
Y_cm = Y_pixels * scaling_factor;

% Generate time vector based on the frame rate of the video
time = (0:min(n, numFrames)-1) / v.FrameRate;  % Time in seconds

% Find the starting index for 2 seconds onwards
start_idx = find(time >= 0, 1);

% Subset data from 2 seconds onward
time_subset = time(start_idx:end);
Y_cm_subset = Y_cm(start_idx:end);

% Plot Y coordinates in Cartesian format for 2 seconds onwards
figure;
plot(time_subset, Y_cm_subset, 'b-', 'LineWidth', 1.5);
set(gca, 'YDir', 'reverse'); % Invert y-axis for Cartesian format
xlabel('Time (seconds)');
ylabel('Y Coordinate (cm)');
title('Y Coordinate over Time (Scaled to 10 cm Peak-to-Peak, Starting at 2 Seconds)');
grid on;
