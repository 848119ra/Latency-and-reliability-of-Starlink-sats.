% File: compute_satellite_positions_24hours.m
% Read the TLE data of Starlink satellites(with inclination higher than 53 degrees that can be seen
% in Finland), from starlink_tle.txt file, and calculates the positions of
% satellites in duration of 24 hours with 10 minutes intervals.Then saves
% the positions in satellite_positions_24hours.mat file.

% Read TLE data from text file
tleFileName = 'starlink_tle.txt';
tle_data = tleread(tleFileName); % Ensure you have the function tleread or relevant toolbox
satellite_cat_num = arrayfun(@num2str, [tle_data.SatelliteCatalogNumber], 'UniformOutput', false);

% Define initial time and intervals
initialStartTime = datetime(2024, 6, 18, 4, 0, 51); % Initial start time
numIntervals = 144; % Total intervals over 24 hours
intervalMinutes = 10; % Minutes per interval

% Preallocate storage for satellite positions across intervals
sat_positions = cell(length(satellite_cat_num), numIntervals); % cell array to store positions

for intervalIdx = 1:numIntervals
    % Define the start and stop times for each interval (each interval is just 1 second)
    startTime = initialStartTime + minutes((intervalIdx - 1) * intervalMinutes);
    stopTime = startTime + seconds(0); % Stop time is the same as start time (instantaneous position)
    sampleTime = 1; % 1-second sample time to capture exact moment

    % Create a satellite scenario
    sc = satelliteScenario(startTime, stopTime, sampleTime);
    sats = satellite(sc, tleFileName); % Load satellite objects from TLE data

    % Capture position for each satellite at this time interval
    for sat_idx = 1:length(sats)
        [sat_pos, ~] = states(sats(sat_idx), startTime, 'CoordinateFrame', 'ecef');
        sat_positions{sat_idx, intervalIdx} = sat_pos(:)'; % Store as row vector in cell array
    end
end

% Save to a .mat file
save('satellite_positions_24hours.mat', 'sat_positions', 'initialStartTime', 'intervalMinutes');
