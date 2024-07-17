CREATE SCHEMA IF NOT EXISTS fct;
SET search_path TO fct; 

DROP TABLE IF EXISTS fct_production; 
SELECT 
    production_id, 
    src_production.site_id, 
    sensor_id, 
    production_date, 
    energy_generated, 
    energy_type, 
    dim_sites.total_capacity, 
    energy_generated / dim_sites.total_capacity AS energy_efficiency, 
	SUM(energy_generated) OVER (PARTITION BY sensor_id, energy_type ORDER BY production_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_energy
INTO fct_production
FROM src.src_production
LEFT JOIN dim.dim_sites ON src_production.site_id = dim_sites.site_id;
