-- Para que la tabla pueda ingresarse de manera correcta es necesario instalar la extensión
-- de PostGIS para guardar la ubicación del vehículo como un datos de tipo POINT (coordenadas)
-- Para instalar PostGIS es necesario seguir los sigueintes pasos:
    -- 1) Abrir la aplicación Stack Builder (instalada con PostgreSQL)
    -- 2) Seleccionar la versión de PostgreSQL que se esté utilizando
    -- 3) Desplegar la sección de Categorías -> Spatial Extensions -> PostGIS 3.5 y descargar la extensión
    -- 4) Una vez terminada la instalación correr el sigueinte comando: CREATE EXTENSION postgis;


/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */
-- CREACIÓN DE LA TABLA RAW
/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */

DROP SCHEMA IF EXISTS raw CASCADE;
CREATE SCHEMA IF NOT EXISTS raw;

DROP TABLE IF EXISTS raw.vehicle_data;
CREATE TABLE raw.vehicle_data (
    vin VARCHAR(10),                        -- Ejemplo: JTMAB3FV3P
    county VARCHAR(50),                     -- Ejemplo: Kitsap
    city VARCHAR(50),                       -- Ejemplo: Seabeck
    state VARCHAR(2),                       -- Ejemplo: WA
    postal_code VARCHAR(10),                -- Ejemplo: 98380
    model_year SMALLINT,                    -- Ejemplo: 2023
    make VARCHAR(50),                       -- Ejemplo: TOYOTA
    model VARCHAR(50),                      -- Ejemplo: RAV4 PRIME
    vehicle_type VARCHAR(100),              -- Ejemplo: Plug-in Hybrid Electric Vehicle (PHEV)
    CAFV VARCHAR(100),                      -- Ejemplo: Clean Alternative Fuel Vehicle Eligible
    range SMALLINT,                         -- Ejemplo: 42
    baseMSRP NUMERIC(10,2),                 -- Ejemplo: 36,000.5
    legislative_district VARCHAR(2),        -- Ejemplo: 35
    dol_vehicle_id BIGINT PRIMARY KEY,      -- Ejemplo: 240684006
    vehicle_location GEOMETRY(Point, 4326), -- Ejemplo: POINT (-122.8728334 47.5798304)
    electric_utility TEXT,                  -- Ejemplo: PUGET SOUND ENERGY INC
    census_tract VARCHAR(12)                -- Ejemplo: 53035091301
);

/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */
-- INSERCIÓN DE LOS DATOS EN LA TABLA RAW
/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */

-- Para Ingresar los datos se debe correr cualqueira de los siguientes 2 comandos cambiando la dirección del archivo

-- Mac (Charly)
-- \copy raw.vehicle_data (vin, county, city, state, postal_code, model_year, make, model, vehicle_type, CAFV, range, baseMSRP, legislative_district, dol_vehicle_id, vehicle_location, electric_utility, census_tract)
-- FROM '/Users/carlitos73/Documents/ITAM/Cuarto_Semestre/Bases_de_Datos/Electric_Vehicle_Population_Data.csv'
-- WITH (FORMAT CSV, HEADER true, DELIMITER ',');

-- Windows (Pablo)
-- COPY raw.vehicle_data (vin, county, city, state, postal_code, model_year, make, model, vehicle_type, CAFV, range, baseMSRP, legislative_district, dol_vehicle_id, vehicle_location, electric_utility, census_tract)
-- FROM 'D:/PABLO/ITAM/Materias 4 Semestre/Bases de Datos/Proyecto Final/Electric_Vehicle_Population_Data.csv'
-- WITH (FORMAT CSV, HEADER true, DELIMITER ',');



