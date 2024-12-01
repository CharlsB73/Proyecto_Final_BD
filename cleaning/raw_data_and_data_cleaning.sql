-- Cambio de prueba jeje

DROP SCHEMA IF EXISTS cleaning CASCADE;
CREATE SCHEMA cleaning;

--Creación de tablas de limpieza
DROP TABLE IF EXISTS cleaning.electric_utility;
CREATE TABLE cleaning.electric_utility (
                                           id SERIAL PRIMARY KEY,
                                           name text
);

DROP TABLE IF EXISTS cleaning.location;
CREATE TABLE cleaning.location (
                                    id serial primary key,
                                   postal_code varchar(10),
                                   county varchar(50),
                                   state varchar(50),
                                   city varchar(50),
                                   vehicle_location text,
                                   legislative_district varchar(4)
);

DROP TABLE IF EXISTS cleaning.vehicle_details;
CREATE TABLE cleaning.vehicle_details (
                                          id bigserial primary key ,
                                          model varchar(50),
                                          make varchar(50),
                                          model_year smallint,
                                          vehicle_type varchar(50),
                                          range smallint,
                                          baseMSRP numeric(10,2),
                                          CAFV varchar(100)
);

DROP TABLE IF EXISTS cleaning.vehicle;
CREATE TABLE cleaning.vehicle (
    dol_vehicle_id BIGINT PRIMARY KEY,
    vehicle_details_id BIGINT references cleaning.vehicle_details(id),
    location_id BIGINT references cleaning.location(id),
    electric_utility_id BIGINT references cleaning.electric_utility(id)
);


--Primera etapa de limpieza: limpieza general y orden
INSERT INTO cleaning.vehicle_details (model, make, model_year, vehicle_type, range, baseMSRP, CAFV)
SELECT DISTINCT trim(model), trim(make), model_year, trim(upper(vehicle_type)), range, baseMSRP, trim(upper(CAFV))
FROM raw.vehicle_data;


INSERT INTO cleaning.electric_utility (name)
SELECT DISTINCT trim(electric_utility)
FROM raw.vehicle_data;


INSERT INTO cleaning.location (postal_code, county, state, city, vehicle_location, legislative_district)
SELECT DISTINCT postal_code, trim(upper(county)), trim(state), trim(upper(city)), vehicle_location, legislative_district
FROM raw.vehicle_data;


INSERT INTO cleaning.vehicle (dol_vehicle_id, vehicle_details_id, location_id, electric_utility_id)
SELECT DISTINCT
    rv.dol_vehicle_id,
    vd.id AS vehicle_details_id,
    loc.id AS location_id,
    eu.id AS electric_utility_id
FROM raw.vehicle_data rv
         LEFT JOIN cleaning.vehicle_details vd
                   ON TRIM(rv.model) = vd.model
                       AND TRIM(rv.make) = vd.make
                       AND rv.model_year = vd.model_year
         LEFT JOIN cleaning.location loc
                   ON rv.postal_code = loc.postal_code
         LEFT JOIN cleaning.electric_utility eu
                   ON TRIM(rv.electric_utility) = eu.name;


insert into cleaning.vehicle (dol_vehicle_id)
SELECT DISTINCT dol_vehicle_id
FROM raw.vehicle_data;


--DROP TABLE raw.vehicle_data;