DROP SCHEMA IF EXISTS raw CASCADE;
CREATE SCHEMA IF NOT EXISTS raw;

DROP TABLE IF EXISTS raw.vehicle_data;
CREATE TABLE raw.vehicle_data (
                                  vin VARCHAR(10),  -- Ejemplo: JTMAB3FV3P
                                  county varchar(50),           -- Ejemplo: Kitsap
                                  city varchar(50),             -- Ejemplo: Seabeck
                                  state varchar(50),            -- Ejemplo: WA
                                  postal_code VARCHAR(10), -- Ejemplo: 98380
                                  model_year smallint,        -- Ejemplo: 2023
                                  make varchar(50),             -- Ejemplo: TOYOTA
                                  model varchar(50),            -- Ejemplo: RAV4 PRIME
                                  vehicle_type varchar(50), -- Ejemplo: Plug-in Hybrid Electric Vehicle (PHEV)
                                  CAFV varchar(100), -- Ejemplo: Clean Alternative Fuel Vehicle Eligible
                                  range smallint,    -- Ejemplo: 42
                                  baseMSRP numeric(10,2),     -- Ejemplo: 0 (puede ser un valor decimal)
                                  legislative_district varchar(4), -- Ejemplo: 35
                                  dol_vehicle_id BIGINT PRIMARY KEY , -- Ejemplo: 240684006
                                  vehicle_location text, -- Ejemplo: POINT (-122.8728334 47.5798304)
                                  electric_utility text, -- Ejemplo: PUGET SOUND ENERGY INC
                                  census_tract varchar(20)    -- Ejemplo: 53035091301
);

\copy raw.vehicle_data (vin, county, city, state, postal_code, model_year, make, model, vehicle_type, CAFV, range, baseMSRP, legislative_district, dol_vehicle_id, vehicle_location, electric_utility, census_tract) FROM '/Users/carlitos73/Documents/ITAM/Cuarto_Semestre/Bases_de_Datos/Electric_Vehicle_Population_Data.csv' WITH (FORMAT CSV, HEADER true, DELIMITER ',');