CREATE SCHEMA RAW;
SET search_path TO RAW; 

CREATE TABLE raw_production (
production_id SERIAL PRIMARY KEY,
site_id INT NOT NULL,
sensor_id INT NOT NULL,
production_date DATE,
energy_generated DECIMAL(10, 2),
energy_type VARCHAR(50)
);

CREATE TABLE raw_sites (
site_id SERIAL PRIMARY KEY,
site_name VARCHAR(100),
location VARCHAR(100),
installation_date DATE,
total_capacity DECIMAL(10, 2)
);

CREATE TABLE raw_sensors (
sensor_id SERIAL PRIMARY KEY,
site_id INT NOT NULL,
sensor_type VARCHAR(50),
installation_date DATE,
status VARCHAR(50)
);

-- COPY raw_production(production_id, site_id, sensor_id, production_date, energy_generated, energy_type)
-- FROM 'data/production_renewable.csv' DELIMITER ',' CSV HEADER;

-- COPY raw_sites(site_id, site_name, location, installation_date, total_capacity)
-- FROM 'data/sites_renewable.csv' DELIMITER ',' CSV HEADER;

-- COPY raw_sensors(sensor_id, site_id, sensor_type, installation_date, status)
-- FROM 'data/sensors_renewable.csv' DELIMITER ',' CSV HEADER;