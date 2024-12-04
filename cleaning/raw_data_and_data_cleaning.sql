-- Se requiere de la extensión PostGIS para poder guardar datos de tipo POINT como coordenadas
-- el proceso de su isntalación está especificado en raw_data_schema_creation.sql



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

-- Comprobar que los datos se agregaron de manera correcta (205,436 tuplas)
SELECT * FROM cleaning.vehicle;






-- Cantidad de vehículos registrados por año
SELECT cleaning.vehicle_details.model_year,
       COUNT(cleaning.vehicle.dol_vehicle_id)
FROM cleaning.vehicle
INNER JOIN cleaning.vehicle_details
    ON cleaning.vehicle.vehicle_details_id = cleaning.vehicle_details.id
group by cleaning.vehicle_details.model_year
ORDER BY COUNT(cleaning.vehicle.dol_vehicle_id) DESC;


-- Cantidad de vehículos registrados por condado en Washington
SELECT cleaning.location.county,
       COUNT(cleaning.vehicle.dol_vehicle_id)
FROM cleaning.vehicle
INNER JOIN cleaning.location
    ON cleaning.vehicle.location_id = cleaning.location.id
    AND cleaning.location.state = 'WA'
GROUP BY cleaning.location.county
ORDER BY COUNT(cleaning.vehicle.dol_vehicle_id) DESC;


-- Top 10 de fabricantes segun la autonomía de  com mayor autonomía
WITH vehiculosRankeados AS (
    SELECT cleaning.vehicle_details.make,
           cleaning.vehicle_details.model,
           cleaning.vehicle_details.model_year,
           cleaning.vehicle_details.range,
           RANK() OVER (PARTITION BY make ORDER BY cleaning.vehicle_details.range DESC) AS rank
    FROM cleaning.vehicle_details
)

SELECT DISTINCT(make), model, model_year, range
FROM vehiculosRankeados
WHERE rank = 1
ORDER BY range DESC
LIMIT 10;


-- Top 8 compañías de electricidad con mayor cantidad de vehículos asignados
SELECT cleaning.electric_utility.name,
       COUNT(cleaning.vehicle.dol_vehicle_id)
FROM cleaning.vehicle
INNER JOIN cleaning.electric_utility
    ON cleaning.vehicle.electric_utility_id = cleaning.electric_utility.id
group by cleaning.electric_utility.name
ORDER BY COUNT(cleaning.vehicle.dol_vehicle_id) DESC
LIMIT 8;


-- Los 15 autos con precio de mercado sugerido más altos
SELECT DISTINCT cleaning.vehicle_details.make,
                cleaning.vehicle_details.model,
                cleaning.vehicle_details.model_year,
                cleaning.vehicle_details.basemsrp
FROM cleaning.vehicle
INNER JOIN cleaning.vehicle_details
    ON cleaning.vehicle.vehicle_details_id = cleaning.vehicle_details.id
WHERE cleaning.vehicle_details.basemsrp != 0.00
ORDER BY cleaning.vehicle_details.basemsrp DESC
LIMIT 15;
