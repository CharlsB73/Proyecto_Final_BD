-- Se requiere de la extensión PostGIS para poder guardar datos de tipo POINT como coordenadas
-- Pasos para la instalación:
    -- 1) Abrir Stack Builder
    -- 2) Seleccionar la versión de PostgreSQL que se esté utilizando
    -- 3) En la sección de Categorías -> Spatial Extensions -> PostGIS 3.5 descargar la extensión
    -- 4) Una vez terminada la instalación correr el sigueinte comando: CREATE EXTENSION postgis;

DROP SCHEMA IF EXISTS raw CASCADE;
CREATE SCHEMA IF NOT EXISTS raw;

DROP TABLE IF EXISTS raw.vehicle_data;
CREATE TABLE raw.vehicle_data (
    vin VARCHAR(10),                        -- Ejemplo: JTMAB3FV3P
    country VARCHAR(50),                    -- Ejemplo: Kitsap
    city VARCHAR(50),                       -- Ejemplo: Seabeck
    state VARCHAR(2),                       -- Ejemplo: WA
    postal_code VARCHAR(10),                -- Ejemplo: 98380
    model_year SMALLINT,                    -- Ejemplo: 2023
    make VARCHAR(50),                       -- Ejemplo: TOYOTA
    model VARCHAR(50),                      -- Ejemplo: RAV4 PRIME
    vehicle_type VARCHAR(100),              -- Ejemplo: Plug-in Hybrid Electric Vehicle (PHEV)
    CAFV VARCHAR(100),                      -- Ejemplo: Clean Alternative Fuel Vehicle Eligible
    range SMALLINT DEFAULT 0,               -- Ejemplo: 42
    baseMSRP NUMERIC(10,2),                 -- Ejemplo: 36,000.5
    legislative_district VARCHAR(2),        -- Ejemplo: 35
    dol_vehicle_id BIGINT PRIMARY KEY,      -- Ejemplo: 240684006
    vehicle_location GEOMETRY(Point, 4326), -- Ejemplo: POINT (-122.8728334 47.5798304)
    electric_utility TEXT,                  -- Ejemplo: PUGET SOUND ENERGY INC
    census_tract VARCHAR(12)                -- Ejemplo: 53035091301
);

-- Ingresar los datos en MAC
-- \copy raw.vehicle_data (vin, county, city, state, postal_code, model_year, make, model, vehicle_type, CAFV, range, baseMSRP, legislative_district, dol_vehicle_id, vehicle_location, electric_utility, census_tract) FROM '/Users/carlitos73/Documents/ITAM/Cuarto_Semestre/Bases_de_Datos/Electric_Vehicle_Population_Data.csv' WITH (FORMAT CSV, HEADER true, DELIMITER ',');

-- Ingresar los datos en Windows
COPY raw.vehicle_data (vin, country, city, state, postal_code, model_year, make, model, vehicle_type, CAFV, range, baseMSRP, legislative_district, dol_vehicle_id, vehicle_location, electric_utility, census_tract) FROM 'D:/PABLO/ITAM/Materias 4 Semestre/Bases de Datos/Proyecto Final/Electric_Vehicle_Population_Data.csv' WITH (FORMAT CSV, HEADER true, DELIMITER ',');

-- Por una razón desconocida el default no coloca las tuplas nulas con en valor por defecto
-- Es necesario ejecutar las siguientes linear para que se realicen los cambios
UPDATE raw.vehicle_data SET range = 0 WHERE range IS NULL;
UPDATE raw.vehicle_data SET baseMSRP = 0.00 WHERE baseMSRP IS NULL;
UPDATE raw.vehicle_data SET model = '-' WHERE model IS NULL;
UPDATE raw.vehicle_data SET legislative_district = '-' WHERE legislative_district IS NULL;

-- Debido a la incompletitud de los datos de las siguientes tres tuplas, pues no contienen información
-- esencial como condado, ciudad, código postal, servicio de energía, código censal y ubicación del vehículo,
-- decidimos como parte de la limpieza de la tabla eliminarlas
DELETE FROM raw.vehicle_data WHERE raw.vehicle_data.dol_vehicle_id = 244582593;
DELETE FROM raw.vehicle_data WHERE raw.vehicle_data.dol_vehicle_id = 159850029;
DELETE FROM raw.vehicle_data WHERE raw.vehicle_data.dol_vehicle_id = 477613216;

-- 205,436 tuplas deben de ser afectadas
SELECT * FROM raw.vehicle_data;

-- Para seleccionar un dato de tipo POINT como coordenadas de texto se debe hacer de la sigueinte manera:
-- SELECT ST_AsText(vehicle_location) FROM raw.vehicle_data;
