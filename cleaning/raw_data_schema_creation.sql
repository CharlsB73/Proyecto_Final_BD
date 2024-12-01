DROP SCHEMA IF EXISTS raw CASCADE;
CREATE SCHEMA IF NOT EXISTS raw;

DROP TABLE IF EXISTS raw.vehicle_data;
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

\copy raw.vehicle_data (vin, county, city, state, postal_code, model_year, make, model, electric_vehicle_type, cafv_eligibility, electric_range, base_msrp, legislative_district, dol_vehicle_id, vehicle_location, electric_utility, census_tract) FROM '/Users/carlitos73/Documents/ITAM/Cuarto_Semestre/Bases_de_Datos/Electric_Vehicle_Population_Data.csv' WITH (FORMAT CSV, HEADER true, DELIMITER ',');