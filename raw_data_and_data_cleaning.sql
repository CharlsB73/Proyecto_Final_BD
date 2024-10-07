CREATE SCHEMA IF NOT EXISTS raw;

CREATE TABLE raw.vehicle_data (
                                  vin TEXT PRIMARY KEY,  -- Ejemplo: JTMAB3FV3P
                                  county TEXT,           -- Ejemplo: Kitsap
                                  city TEXT,             -- Ejemplo: Seabeck
                                  state TEXT,            -- Ejemplo: WA
                                  postal_code VARCHAR(10), -- Ejemplo: 98380
                                  model_year INT,        -- Ejemplo: 2023
                                  make TEXT,             -- Ejemplo: TOYOTA
                                  model TEXT,            -- Ejemplo: RAV4 PRIME
                                  electric_vehicle_type TEXT, -- Ejemplo: Plug-in Hybrid Electric Vehicle (PHEV)
                                  cafv_eligibility TEXT, -- Ejemplo: Clean Alternative Fuel Vehicle Eligible
                                  electric_range INT,    -- Ejemplo: 42
                                  base_msrp DECIMAL,     -- Ejemplo: 0 (puede ser un valor decimal)
                                  legislative_district INT, -- Ejemplo: 35
                                  dol_vehicle_id BIGINT, -- Ejemplo: 240684006
                                  vehicle_location TEXT, -- Ejemplo: POINT (-122.8728334 47.5798304)
                                  electric_utility TEXT, -- Ejemplo: PUGET SOUND ENERGY INC
                                  census_tract BIGINT    -- Ejemplo: 53035091301
);


CREATE TEMP TABLE temp_vehicle_data AS TABLE raw.vehicle_data WITH NO DATA;


\copy temp_vehicle_data (vin, county, city, state, postal_code, model_year, make, model, electric_vehicle_type, cafv_eligibility, electric_range, base_msrp, legislative_district, dol_vehicle_id, vehicle_location, electric_utility, census_tract) FROM '/Users/carlitos73/Documents/ITAM/Cuarto_Semestre/Bases_de_Datos/Electric_Vehicle_Population_Data.csv' WITH (FORMAT CSV, HEADER true, DELIMITER ',');


INSERT INTO raw.vehicle_data
SELECT DISTINCT ON (vin) *
FROM temp_vehicle_data;

select *
from raw.vehicle_data;

CREATE SCHEMA IF NOT EXISTS cleaning;


CREATE TABLE cleaning.vehicles (
                                   vin TEXT PRIMARY KEY,
                                   model_year INT,
                                   make TEXT,
                                   model TEXT,
                                   electric_vehicle_type TEXT,
                                   electric_range INT,
                                   base_msrp DECIMAL
);


CREATE TABLE cleaning.location (
                                   location_id BIGSERIAL PRIMARY KEY,
                                   vin TEXT REFERENCES cleaning.vehicles(vin),
                                   county TEXT,
                                   city TEXT,
                                   state TEXT,
                                   postal_code VARCHAR(10),
                                   vehicle_location TEXT,
                                   census_tract BIGINT
);


CREATE TABLE cleaning.energy_utility (
                                         utility_id BIGSERIAL PRIMARY KEY,
                                         vin TEXT REFERENCES cleaning.vehicles(vin),
                                         electric_utility TEXT,
                                         cafv_eligibility TEXT,
                                         legislative_district INT,
                                         dol_vehicle_id BIGINT
);


INSERT INTO cleaning.vehicles (vin, model_year, make, model, electric_vehicle_type, electric_range, base_msrp)
SELECT DISTINCT vin, model_year, make, model, electric_vehicle_type, electric_range, base_msrp
FROM raw.vehicle_data;


INSERT INTO cleaning.location (vin, county, city, state, postal_code, vehicle_location, census_tract)
SELECT vin, county, city, state, postal_code, vehicle_location, census_tract
FROM raw.vehicle_data;


INSERT INTO cleaning.energy_utility (vin, electric_utility, cafv_eligibility, legislative_district, dol_vehicle_id)
SELECT vin, electric_utility, cafv_eligibility, legislative_district, dol_vehicle_id
FROM raw.vehicle_data;


SELECT COUNT(*) FROM cleaning.vehicles;
SELECT COUNT(*) FROM cleaning.location;
SELECT COUNT(*) FROM cleaning.energy_utility;

DROP TABLE raw.vehicle_data;
