-- Dado que en la base de datos normalizada no se consideran los atributos VIN y census_track
-- no serán revisados para limpieza.

-- .: LIMPIEZA DE LOS DATOS :.

-- Colocamos un default a todos los valores que habíamos encontrado como nulls
UPDATE raw.vehicle_data SET legislative_district = '-' WHERE legislative_district IS NULL;
UPDATE raw.vehicle_data SET vehicle_location = ST_SetSRID(ST_MakePoint(0, 0), 4326) WHERE vehicle_location IS NULL;
UPDATE raw.vehicle_data SET range = 0 WHERE range IS NULL;
UPDATE raw.vehicle_data SET baseMSRP = 0.00 WHERE baseMSRP IS NULL;
UPDATE raw.vehicle_data SET model = '-' WHERE model IS NULL;


-- Eliminamos todos los espacios inncesarios y colocamos todos los textos en mayúsculas
UPDATE raw.vehicle_data SET electric_utility = TRIM(UPPER(electric_utility));
UPDATE raw.vehicle_data SET postal_code = TRIM(postal_code);
UPDATE raw.vehicle_data SET county = TRIM(UPPER(county));
UPDATE raw.vehicle_data SET state = TRIM(UPPER(state));
UPDATE raw.vehicle_data SET legislative_district = TRIM(legislative_district);
UPDATE raw.vehicle_data SET model = TRIM(UPPER(model));
UPDATE raw.vehicle_data SET make = TRIM(UPPER(make));
UPDATE raw.vehicle_data SET vehicle_type = TRIM(UPPER(vehicle_type));
UPDATE raw.vehicle_data SET cafv = TRIM(UPPER(cafv));



-- .: CREACIÓN DE LOS ESQUEMAS :.

--Creación del esquema para la limpieza de los datos
DROP SCHEMA IF EXISTS cleaning CASCADE;
CREATE SCHEMA cleaning;

-- Creación de la tabla para los servicios de energía
DROP TABLE IF EXISTS cleaning.electric_utility;
CREATE TABLE cleaning.electric_utility (
    id SERIAL PRIMARY KEY, -- Es serial pues no esperamos una gran cantidad de servicios
    name TEXT
);

-- Creación de la tabla para la ubicación del vehículo
DROP TABLE IF EXISTS cleaning.location;
CREATE TABLE cleaning.location (
    id BIGSERIAL PRIMARY KEY,
    postal_code VARCHAR(10),
    county VARCHAR(50),
    state VARCHAR(2),
    city VARCHAR(50),
    legislative_district VARCHAR(2),
    vehicle_location GEOMETRY(Point, 4326)
);

-- Creación de la tabla para los detalles del vehículo
DROP TABLE IF EXISTS cleaning.vehicle_details;
CREATE TABLE cleaning.vehicle_details (
    id BIGSERIAl PRIMARY KEY,
    model VARCHAR(50),
    make VARCHAR(50),
    model_year SMALLINT,
    vehicle_type VARCHAR(100),
    range SMALLINT,
    baseMSRP NUMERIC(10,2),
    CAFV VARCHAR(100)
);

-- Creación de la tabla general para los vehículos
DROP TABLE IF EXISTS cleaning.vehicle;
CREATE TABLE cleaning.vehicle (
    dol_vehicle_id BIGINT PRIMARY KEY,
    vehicle_details_id BIGSERIAL references cleaning.vehicle_details(id),
    location_id BIGSERIAL references cleaning.location(id),
    electric_utility_id SERIAL references cleaning.electric_utility(id)
);



--  .: INSERCIÓN DE LOS DATOS LIMPIOS :.

-- Inserción de los datos del servicio de energía
INSERT INTO cleaning.electric_utility (name)
SELECT DISTINCT electric_utility
FROM raw.vehicle_data;

-- Comprobar que los datos se agregaron de manera correcta (75 tuplas)
SELECT * FROM cleaning.electric_utility;


-- Inserción de los datos de la ubicación del vehìculo
INSERT INTO cleaning.location (postal_code, county, state, city, vehicle_location, legislative_district)
SELECT DISTINCT postal_code,county, state, city, vehicle_location, legislative_district
FROM raw.vehicle_data;

-- Comprobar que los datos se agregaron de manera correcta (1,438 tuplas)
SELECT * FROM cleaning.location;


-- Inserción de los datos de la información acerca del vehìculo
INSERT INTO cleaning.vehicle_details (model, make, model_year, vehicle_type, range, baseMSRP, CAFV)
SELECT DISTINCT model, make, model_year, vehicle_type, range, baseMSRP, CAFV
FROM raw.vehicle_data;

-- Comprobar que los datos se agregaron de manera correcta (596 tuplas)
SELECT * FROM cleaning.vehicle_details;

-- Inserción de los datos de todas las llaves para la tabla de vehículo
-- NOTAS PARA ENTENDER LOS LEFT JOINS:
-- Existen 3 tuplas que no tienen registrado un servicio de energía
-- Un mismo codigo postal puede tener distintos distritos legislativosm, ciudades o condados
-- Hay tuplas que solo tien estado y ninguna otra información
-- Hay tuplas que no tienen información de ubicación
-- Existe 1 tuplas que no tienen registrado un servicio de energía
-- Puede que un vehículo de mismo modelo y año tenga un precio sugerido, autonomía y tipo de vehículo diferente
INSERT INTO cleaning.vehicle (dol_vehicle_id, vehicle_details_id, location_id, electric_utility_id)
SELECT DISTINCT
    rv.dol_vehicle_id,
    vd.id AS vehicle_details_id,
    loc.id AS location_id,
    eu.id AS electric_utility_id
FROM raw.vehicle_data rv
LEFT JOIN cleaning.electric_utility eu
    ON rv.electric_utility = eu.name
LEFT JOIN cleaning.location loc
    ON rv.postal_code = loc.postal_code
    AND rv.city = loc.city
    AND rv.legislative_district = loc.legislative_district
    AND rv.county = loc.county
LEFT JOIN cleaning.vehicle_details vd
    ON rv.model = vd.model
    AND rv.model_year = vd.model_year
    AND rv.range = vd.range
    AND rv.basemsrp = vd.baseMSRP
    AND rv.vehicle_type = vd.vehicle_type;


SELECT * FROM cleaning.vehicle



















-- Como la tabla normalizada contiene una entidad "location" decidimos
-- eliminar las tuplas con estos datos faltantes ya que casi no aportan información.
-- 3 tuplas deben de ser eliminadas
DELETE FROM raw.vehicle_data
WHERE raw.vehicle_data.dol_vehicle_id IN (
    SELECT dol_vehicle_id
    FROM raw.vehicle_data
    WHERE postal_code IS NULL
);
