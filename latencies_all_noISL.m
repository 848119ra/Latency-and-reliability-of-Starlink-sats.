% One way latency values for Starlink LEO satellites constellation, by using
% satellite_positions_24hours.mat file that has the position of Starlink satellites
% for June 18, 2024 and for 24 hours after it, has been calculated. The
% distance from user(in different cities in Finland) to the nearest
% Starlink satellite and the distance from the satellite to the
% gateway in Kaunas, Lithuania, has been calculated. 


clc;
close all;
clear all;

% Load precomputed satellite positions
load('satellite_positions_24hours.mat', 'sat_positions', 'intervalMinutes');

% Define number of time intervals
numIntervals = 144;  % Fixed number of time intervals

% Ground station coordinates in Kaunas, Lithuania (latitude, longitude, altitude in m)
gateway_lat = 54.88;
gateway_long = 23.84;
gateway_alt = 77;

gateway_ECEF = lla2ecef([gateway_lat, gateway_long, gateway_alt]);  % Kaunas, Lithuania

% Speed of light in m/s
c = 2.988 * 1e8;

% Read user data from Excel file
user_data = readtable('city_positions.xlsx');

% Initialize arrays to store results
cities = user_data{:, 1};
latencies = zeros(height(user_data), numIntervals);  % Two-dimensional array for latencies

% Iterate over each user location
for i = 1:height(user_data)
    % Get user coordinates
    user_lat = user_data{i, 2};
    user_lon = user_data{i, 3};
    user_alt = user_data{i, 4};

    % Convert user's location to ECEF coordinates
    user_ECEF = lla2ecef([user_lat, user_lon, user_alt]);

    % Iterate over each time interval
    for t_idx = 1:numIntervals
        % Get satellite positions for the current time interval
        sat_positions_ECEF = [];
        for sat_idx = 1:size(sat_positions, 1)
            sat_positions_ECEF(:, sat_idx) = sat_positions{sat_idx, t_idx}; % Collect positions into a matrix
        end

        % Calculate distances from the user to all satellites at this time interval
        distances_to_sats = vecnorm(sat_positions_ECEF - user_ECEF', 2, 1); % Calculate distances

        % Find the minimum distance and the corresponding satellite position
        [min_distance, min_index] = min(distances_to_sats);
        nearest_sat_pos = sat_positions_ECEF(:, min_index); % Get nearest satellite position

        % Calculate distance to ground station
        distance_to_gateway = norm(nearest_sat_pos - gateway_ECEF); % Distance to ground station

        % Calculate propagation latency
        %latency = ((min_distance + distance_to_gateway) / c); 
        latency = 2 * ((min_distance + distance_to_gateway) / c); % Round trip delay
        latencies(i, t_idx) = latency; % Store latency for current user and time interval
    end
end


% Plot histogram of latencies for each city separately
figure;
for i = 1:height(user_data)
    % Create a subplot for each city
    subplot(3, 2, i);  % Adjust the layout based on the number of cities
    histogram(latencies(i, :) * 1e3, 'Normalization', 'probability');  % Convert to ms
    xlabel('Latency (ms)');
    ylabel('Probability');
    title([ cities{i}]);
    grid on;
end


% Plot histogram of latencies for each user
%figure;
%histogram(latencies(:), 'Normalization', 'probability');  % Flatten latencies for the histogram
%xlabel('Propagation Latency (s)');
%ylabel('Probability');
%title('Histogram of Propagation Latencies');
%grid on;
