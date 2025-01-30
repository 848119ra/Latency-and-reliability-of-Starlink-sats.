% By this code, the probability of visiting at least 1, 4 and 8 satellites
% for different cities in Finland has been calculates for the beat
% situation if minimum elevation angle and the worst situation of minimum
% elevation angle given in cities_lat_el.xlsx file.


% Load precomputed satellite positions for 24 hours
load('satellite_positions_24hours.mat', 'sat_positions', 'intervalMinutes');

% Load city data from Excel file
filename = 'cities_lat_el.xlsx';
city_data = readtable(filename, 'VariableNamingRule', 'preserve');
prob_4_sats = zeros(height(city_data), 1);
default_altitude = 84; % meters

% Define the total time steps based on intervals
total_time_steps = size(sat_positions, 2);

for city_idx = 1:height(city_data)
    user_lat = city_data.latitude(city_idx);
    user_lon = city_data.longtitude(city_idx);
    min_elevation = city_data.("min elev. Angle_best")(city_idx);
    user_ECEF = lla2ecef([user_lat, user_lon, default_altitude]);

    num_times_4_sats = 0;

    for t_idx = 1:total_time_steps
        num_visible_sats = 0;

        for sat_idx = 1:size(sat_positions, 1)
            sat_position = sat_positions{sat_idx, t_idx};
            if isempty(sat_position)
                continue; % Skip if position data is missing
            end

            [~, elevation, ~] = ecef2aer(sat_position(1), sat_position(2), sat_position(3), ...
                                         user_lat, user_lon, default_altitude, wgs84Ellipsoid);

            if elevation >= min_elevation
                num_visible_sats = num_visible_sats + 1;
            end
        end

        if num_visible_sats >= 4
            num_times_4_sats = num_times_4_sats + 1;
        end
    end
    num_times_4_sats

    % Calculate probability for the city
    prob_4_sats(city_idx) = num_times_4_sats / total_time_steps;
end

% Plot the probability results
figure;
bar(prob_4_sats);
set(gca, 'XTickLabel', strcat(city_data.city));
xlabel('City');
ylabel('Probability of at least 4 Visible Satellites');
title('Probability of observing at least 4 Satellites(worst situation)');
grid on;
