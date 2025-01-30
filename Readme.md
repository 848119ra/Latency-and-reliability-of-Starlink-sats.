# Latency and Reliability of Starlink Satellites

This project calculates the latency and reliability of Starlink satellites for different cities in Finland. It includes scripts to compute satellite positions, calculate the probability of visible satellites, and determine latencies.

## Files

### `compute_satellite_positions.m`
- Reads TLE data of Starlink satellites and calculates their positions over 24 hours with 10-minute intervals.
- Saves the positions in `satellite_positions_24hours.mat`.

### `num_visible_sat.m`
- Calculates the probability of observing at least 1,4 and 8 satellites for different cities in Finland.
- Uses precomputed satellite positions from `satellite_positions_24hours.mat`.
- Plots the probability results for each city.

### `latencies_all_noISL.m`
- Calculates one-way latency values for Starlink LEO satellites.
- Computes the distance from users in different cities in Finland to the nearest satellite and from the satellite to the gateway in Kaunas, Lithuania.
- Plots histograms of latencies for each city.

## Usage

### Compute Satellite Positions
Run `compute_satellite_positions.m` to generate `satellite_positions_24hours.mat`.
Ensure `starlink_tle.txt` is available in the same directory.

### Calculate Probability of Visible Satellites
Run `num_visible_sat.m` to calculate and plot the probability of observing at least 4 satellites.
Ensure `cities_lat_el.xlsx` and `satellite_positions_24hours.mat` are available in the same directory.

### Calculate Latencies
Run `latencies_all_noISL.m` to calculate and plot latencies for different cities.
Ensure `city_positions.xlsx` and `satellite_positions_24hours.mat` are available in the same directory.

## Dependencies
- MATLAB with Mapping Toolbox for coordinate transformations.
- `starlink_tle.txt` for TLE data.
- `cities_lat_el.xlsx` for city latitude and elevation data.
- `city_positions.xlsx` for user location data.

## Commands
To compute satellite positions:
run('compute_satellite_positions.m');
To calculate the probability of visible satellites:
run('num_visible_sat.m');
To calculate latencies:
run('latencies_all_noISL.m');

