CREATE SCHEMA IF NOT EXISTS SRC;
SET search_path TO SRC; 

--src_productions
DROP TABLE IF EXISTS src_production; 
SELECT DISTINCT ON (site_id, sensor_id, production_date)
    site_id, 
    sensor_id, 
    production_date, 
    energy_generated, 
    energy_type 
INTO src_production
FROM RAW.raw_production
WHERE 
    site_id IS NOT NULL
    AND sensor_id IS NOT NULL
    AND production_date IS NOT NULL
    AND energy_generated IS NOT NULL
    AND energy_type IS NOT NULL
ORDER BY site_id, sensor_id, production_date, production_id DESC;

-- src_sites
DROP TABLE IF EXISTS src_sites; 
WITH first_data AS (
    SELECT
        MIN(site_id) AS site_id,
		site_name
    FROM raw.raw_sites
	GROUP BY site_name
),
last_data AS (
    SELECT DISTINCT ON (site_name)
    site_name, 
    location, 
    installation_date, 
    total_capacity
	FROM raw.raw_sites
	ORDER BY site_name, site_id DESC
)
SELECT
	first_data.site_id,
    first_data.site_name, 
    last_data.location, 
    last_data.installation_date, 
    last_data.total_capacity
INTO src_sites
FROM first_data
LEFT JOIN last_data
ON first_data.site_name = last_data.site_name;

-- src_sensors
DROP TABLE IF EXISTS src_sensors; 
SELECT DISTINCT ON (sensor_id)
    sensor_id, 
    site_id, 
    sensor_type, 
    installation_date, 
    status
INTO src_sensors
FROM RAW.raw_sensors
WHERE 
    sensor_id IS NOT NULL
    AND site_id IS NOT NULL
    AND sensor_type IS NOT NULL
    AND installation_date IS NOT NULL
    AND status IS NOT NULL;
