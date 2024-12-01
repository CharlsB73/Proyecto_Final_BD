
DROP SCHEMA IF EXISTS cleaning CASCADE;
CREATE SCHEMA cleaning;

DROP TABLE IF EXISTS cleaning.vehicle;
CREATE TABLE cleaning.vehicle (
    dol_vehicle_id BIGINT PRIMARY KEY,
    vehicle_details_id BIGSERIAL references cleaning.vehicle_details(id),
    postal_code varchar(10) references cleaning.location(postal_code),
    electric_utility_id serial references cleaning.electric_utility(id)
);

DROP TABLE IF EXISTS cleaning.electric_utility;
CREATE TABLE cleaning.electric_utility (
    id SERIAL PRIMARY KEY,
    name varchar(100)
);

DROP TABLE IF EXISTS cleaning.location;
CREATE TABLE cleaning.location (
    postal_code varchar(10) PRIMARY KEY,
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

--Primera etapa de limpieza: limpieza general y orden
INSERT INTO cleaning.vehicle
SELECT distinct dol_vehicle_id,
       vehicle_details_id,
       postal_code,
       electric_utility
FROM raw.vehicle_data;



SELECT COUNT(*) FROM cleaning.vehicle;
SELECT COUNT(*) FROM cleaning.location;
SELECT COUNT(*) FROM cleaning.vehicle_details;

DROP TABLE raw.vehicle_data;