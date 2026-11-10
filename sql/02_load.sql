-- Run this \copy line in psql, connected to the water_quality database.
-- Update the file path to where the CSV is saved on your machine.
\copy raw.bow_river (project_number, sample_number, continental_river_basin_code, river_basin_code, river_sub_basin_code, station_type_code, station_number, station, latitude, longitude, sample_matrix_code, sample_type_code, collection_code, qc_sample_flag, sample_comment, sample_datetime, vmv_code, variable_code, variable_name, measurement_flag, measurement_value, unit_code, sample_detect_limit, measurement_comment, measurement_qualifier, measurement_qualifier_description, measurement_qualifier_comment, method_code, method_detection_limit, lab_code) FROM 'data/raw/bow_river_raw.csv' WITH (FORMAT csv, HEADER true);

-- Then run the rest in DBeaver
UPDATE raw.bow_river
SET source_file = 'bow_river_raw.csv'
WHERE source_file IS NULL;
SELECT COUNT(*) FROM raw.bow_river;                       -- expect 594
SELECT COUNT(DISTINCT station_number) FROM raw.bow_river; -- expect 6