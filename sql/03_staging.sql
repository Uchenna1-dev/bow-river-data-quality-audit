drop table if exists staging.observations;
create table staging.observations as
select nullif(TRIM(station_number),'') as sampling_point_id,
nullif(Trim(station),'') as sampling_point_label,
nullif(Trim(sample_number),'') as sample_number,
nullif(TRIM(variable_code),'') as determinand_code,
nullif(TRIM(variable_name),'') as determinand_label,
nullif(TRIM(vmv_code),'') as method_variant_code,
nullif(TRIM(unit_code),'') as unit,
nullif(TRIM(source_file),'') as source_file,
sample_datetime as sample_datetime_raw, 
measurement_flag as flag_raw, 
measurement_value as result_raw,
case when nullif(trim(measurement_flag),'')=  'L' then  '<' else null end as result_qualifier,
cast (nullif(trim(measurement_value),'') as numeric) as result_value,
cast (nullif(trim(sample_detect_limit), '') as numeric) as sample_detect_limit,
cast (nullif(trim(method_detection_limit),'') as numeric) as method_detection_limit,
cast (nullif(trim(latitude),'') as numeric) as latitude,
cast (nullif(trim(longitude),'') as numeric) as longitude,
cast (to_timestamp (nullif(trim(sample_datetime),''), 'MM/DD/YYYY HH24:MI:SS') as timestamp) as sample_ts
from raw.bow_river br;

alter table staging.observations add column observation_id SERIAL primary key;
