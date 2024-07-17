CREATE SCHEMA IF NOT EXISTS DIM;
SET search_path TO DIM; 

DROP TABLE IF EXISTS dim_sites; 
WITH site_sensors AS (
	SELECT 
		site_id, 
		COUNT(*) AS nb_sensors,
		SUM(CASE WHEN status = 'active' THEN 1 ELSE 0 END) AS nb_active_sensors
	FROM src.src_sensors
	GROUP BY site_id
)

SELECT 
    src_sites.site_id, 
    site_name, 
    location, 
    installation_date, 
    total_capacity, 
    CASE WHEN nb_active_sensors = nb_sensors THEN 'Operational'
        WHEN nb_active_sensors = 0 THEN 'Non Operational'
        ELSE 'Partially Operational'
    END AS site_status
INTO dim_sites
FROM src.src_sites
LEFT JOIN site_sensors ON src_sites.site_id = site_sensors.site_id;
CREATE SCHEMA IF NOT EXISTS dim;
SET search_path TO dim; 
DROP TABLE IF EXISTS dim_sensors; 
SELECT 
    sensor_id, 
    site_id,
    sensor_type, 
    installation_date, 
    status, 
    current_date - installation_date AS sensor_age
INTO dim_sensors
FROM src.src_sensors
