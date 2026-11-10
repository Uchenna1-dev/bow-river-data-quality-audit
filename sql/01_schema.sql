CREATE SCHEMA IF NOT EXISTS raw;      -- the CSV as loaded
CREATE SCHEMA IF NOT EXISTS ref;      -- lookup tables you maintain
CREATE SCHEMA IF NOT EXISTS staging;  -- typed, cleaned-up copy
CREATE SCHEMA IF NOT EXISTS audit;    -- the issue log
CREATE SCHEMA IF NOT EXISTS mart;     -- views for Power BI

-- All 30 columns of the Bow River file, in file order, as text
CREATE TABLE raw.bow_river (
  project_number                    text,
  sample_number                     text,
  continental_river_basin_code      text,
  river_basin_code                  text,
  river_sub_basin_code              text,
  station_type_code                 text,
  station_number                    text,
  station                           text,
  latitude                          text,
  longitude                         text,
  sample_matrix_code                text,
  sample_type_code                  text,
  collection_code                   text,
  qc_sample_flag                    text,
  sample_comment                    text,
  sample_datetime                   text,
  vmv_code                          text,
  variable_code                     text,
  variable_name                     text,
  measurement_flag                  text,
  measurement_value                 text,
  unit_code                         text,
  sample_detect_limit               text,
  measurement_comment               text,
  measurement_qualifier             text,
  measurement_qualifier_description text,
  measurement_qualifier_comment     text,
  method_code                       text,
  method_detection_limit            text,
  lab_code                          text,
  source_file                       text,
  loaded_at                         timestamptz DEFAULT now()
);