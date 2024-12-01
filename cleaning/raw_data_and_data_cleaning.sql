
DROP SCHEMA IF EXISTS cleaning CASCADE;
CREATE SCHEMA cleaning;

--CREATE TEMP TABLE temp_vehicle_data AS TABLE raw.vehicle_data WITH NO DATA;



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