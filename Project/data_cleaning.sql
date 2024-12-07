/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */
-- INSERCIÓN DE LOS DATOS EN EL ESQUEMA DE LIMPIEZA
/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */

-- Cereación del esquema
-- Ya no incluirmeos los atributos VIN y census_track pues estos serán desechados
DROP SCHEMA IF EXISTS cleaning CASCADE;
CREATE SCHEMA IF NOT EXISTS cleaning;

-- Colocamos un default a todos los valores que habíamos encontrado como nulls
-- Decidimos usar el valor '-' ya que en el ordenamiento aparece primero y nos
-- facilita ver valores faltantes.
-- Para las coordenadas colocamos como default las (0,0)
DROP TABLE IF EXISTS cleaning.vehicle_data;
CREATE TABLE cleaning.vehicle_data (
    county VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(2),
    postal_code VARCHAR(10),
    model_year SMALLINT,
    make VARCHAR(50),
    model VARCHAR(50) DEFAULT '-',
    vehicle_type VARCHAR(100),
    CAFV VARCHAR(100),
    range SMALLINT DEFAULT 0,
    baseMSRP BIGINT DEFAULT 0,
    legislative_district VARCHAR(2) DEFAULT '-',
    dol_vehicle_id BIGINT PRIMARY KEY,
    vehicle_location GEOMETRY(Point, 4326) DEFAULT ST_SetSRID(ST_MakePoint(0, 0), 4326),
    electric_utility TEXT
);

--Corroborar que se efectuaron correctamente los DEFAULT
SELECT *
FROM cleaning.vehicle_data
WHERE range IS NULL
    OR basemsrp IS NULL
    OR model IS NULL
    OR legislative_district IS NULL
    OR vehicle_location IS NULL;

-- Como parte de la limpieza los atributos de tipo texto serán puestos en mayúsculas y sin espacios innecesarios
INSERT INTO cleaning.vehicle_data
SELECT TRIM(UPPER(county)),
       TRIM(UPPER(city)),
       TRIM(UPPER(state)),
       TRIM(UPPER(postal_code)),
       model_year,
       TRIM(UPPER(make)),
       TRIM(UPPER(model)),
       TRIM(UPPER(vehicle_type)),
       TRIM(UPPER(CAFV)),
       range,
       baseMSRP,
       TRIM(UPPER(legislative_district)),
       dol_vehicle_id,
       TRIM(UPPER(vehicle_location)),
       TRIM(UPPER(electric_utility))
FROM raw.vehicle_data;


-- Comprobamos que las 205,439 tuplas se ingresaron correctamente
SELECT * FROM cleaning.vehicle_data;



/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */
-- LIMPIEZA DE LOS DATOS
/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */

-- Como la tabla normalizada contiene una entidad "location" que depende del código postal para su información
-- eliminaremos las tuplas con este deato faltante, pues estas tuplas no aportan información útil.
-- 3 tuplas deben de ser eliminadas
DELETE FROM cleaning.vehicle_data
WHERE cleaning.vehicle_data.dol_vehicle_id IN (
    SELECT dol_vehicle_id
    FROM cleaning.vehicle_data
    WHERE postal_code IS NULL
);


-- Simplificamos los tipos de vehículos a BATTERY ELECTRIC e HYBRID ELECTRIC
UPDATE cleaning.vehicle_data
SET vehicle_type = 'BATTERY ELECTRIC'
WHERE vehicle_type = 'BATTERY ELECTRIC VEHICLE (BEV)';

UPDATE cleaning.vehicle_data
SET vehicle_type = 'HYBRID ELECTRIC'
WHERE vehicle_type = 'PLUG-IN HYBRID ELECTRIC VEHICLE (PHEV)';


-- Simplificamos el CAFV de los vehículos a CLEAN, ELIGIBILITY UNKNOWN y NOT ELIGIBLE
UPDATE cleaning.vehicle_data
SET cafv = 'CLEAN'
WHERE cafv = 'CLEAN ALTERNATIVE FUEL VEHICLE ELIGIBLE';

UPDATE cleaning.vehicle_data
SET cafv = 'ELIGIBILITY UNKNOWN'
WHERE cafv = 'ELIGIBILITY UNKNOWN AS BATTERY RANGE HAS NOT BEEN RESEARCHED';

UPDATE cleaning.vehicle_data
SET cafv = 'NOT ELIGIBLE'
WHERE cafv = 'NOT ELIGIBLE DUE TO LOW BATTERY RANGE';


-- Simplificamos el electric_utility de los vehículos fuera de Washington a NON WASHINGTON
UPDATE cleaning.vehicle_data
SET electric_utility = 'NON WASHINGTON'
WHERE electric_utility = 'NON WASHINGTON STATE ELECTRIC UTILITY';


-- Consideramos que un vehículo del mismo fabricante, modelo, año y autonomía debe de tener siempre el
-- mismo precio sugerido de venta, pues no tinene sentido que este cmabie por cualquiera de los otros atributos.
-- Ya que los unicos vehículos que entran en este caso solo tienen dos precios de venta sugeridos distintos, el
-- 0 (no definido) y otro, se tomará ese otro precio como el definido para todos lo demás.
-- De la exploración de las dependencias sabemos que los vehículos a modificar son los siguientes 3:

UPDATE cleaning.vehicle_data
SET basemsrp = (
    SELECT DISTINCT basemsrp
    FROM cleaning.vehicle_data
    WHERE model = 'CAYENNE' AND model_year = 2020 AND range = 14
    AND basemsrp != 0
)
WHERE model = 'CAYENNE' AND model_year = 2020 AND range = 14;


UPDATE cleaning.vehicle_data
SET basemsrp = (
    SELECT DISTINCT basemsrp
    FROM cleaning.vehicle_data
    WHERE model = 'PANAMERA' AND model_year = 2018 AND range = 14
    AND basemsrp != 0
)
WHERE model = 'PANAMERA' AND model_year = 2018 AND range = 14;

UPDATE cleaning.vehicle_data
SET basemsrp = (
    SELECT DISTINCT basemsrp
    FROM cleaning.vehicle_data
    WHERE model = 'XC60' AND model_year = 2019 AND range = 17
    AND basemsrp != 0
)
WHERE model = 'XC60' AND model_year = 2019 AND range = 17;



/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */
-- CREACIÓN DE LAS TABLAS NORMALIZADAS
/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */

-- Tabla para los servicios de electricidad
-- El id es SERIAL pues no esperamos una gran cantidad de servicios
DROP TABLE IF EXISTS electric_utility CASCADE;
CREATE TABLE electric_utility (
    id SERIAL PRIMARY KEY,
    name TEXT
);


-- Tabla para el mapeo a través del código postal
DROP TABLE IF EXISTS postal_mapping CASCADE;
CREATE TABLE postal_mapping (
    postal_code VARCHAR(10) PRIMARY KEY,
    coordinates GEOMETRY(Point, 4326)
);


-- Tabla para la ubicación geográfica de ciudad, condado y estado
DROP TABLE IF EXISTS geographical_location CASCADE;
CREATE TABLE geographical_location (
    id BIGSERIAL PRIMARY KEY,
    city VARCHAR(50),
    county VARCHAR(50),
    state VARCHAR(2)
);


-- Tabla para la ubicación general
DROP TABLE IF EXISTS location CASCADE;
CREATE TABLE location (
    id BIGSERIAL PRIMARY KEY,
    district VARCHAR(2),
    geographical_location_id BIGSERIAL references public.geographical_location(id),
    postal_code VARCHAR(10) references public.postal_mapping(postal_code)
);


-- Tabla para las especificaciones del vehículo
DROP TABLE IF EXISTS vehicle_specs CASCADE;
CREATE TABLE vehicle_specs (
    id BIGSERIAl PRIMARY KEY,
    range SMALLINT,
    baseMSRP BIGINT,
    CAFV VARCHAR(100)
);


-- Tabla para los detalles del vehículo
DROP TABLE IF EXISTS vehicle_details CASCADE;
CREATE TABLE vehicle_details (
    id BIGSERIAl PRIMARY KEY,
    model VARCHAR(50),
    make VARCHAR(50),
    model_year SMALLINT,
    vehicle_type VARCHAR(100),
    vehicle_specs_id BIGSERIAL references public.vehicle_specs(id)
);


-- Tabla general que contiene todos los IDs para la información del vehículo y el ID principal (DOL)
DROP TABLE IF EXISTS vehicle CASCADE;
CREATE TABLE vehicle (
    dol_vehicle_id BIGINT PRIMARY KEY,
    vehicle_details_id BIGSERIAL references public.vehicle_details(id),
    location_id BIGSERIAL references public.location(id),
    electric_utility_id SERIAL references public.electric_utility(id)
);



/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */
-- INSERCIÓN DE LOS DATOS LIMPIOS
/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */

-- Inserción de los datos del servicio de electricidad (74 tuplas)
INSERT INTO public.electric_utility (name)
SELECT DISTINCT electric_utility
FROM cleaning.vehicle_data;


-- Inserción de los datos del mapeo a través del código postal (929 tuplas)
INSERT INTO postal_mapping (postal_code, coordinates)
SELECT DISTINCT postal_code, vehicle_location
FROM cleaning.vehicle_data;


-- Inserción de los datos de la ubicación geográfica (834 tuplas)
INSERT INTO geographical_location (city, county, state)
SELECT DISTINCT city, county, state
FROM cleaning.vehicle_data;


-- Inserción de los datos de la ubicación (1,436 tuplas)
INSERT INTO location (district, geographical_location_id, postal_code)
SELECT DISTINCT
    cleaning.vehicle_data.legislative_district,
    public.geographical_location.id,
    public.postal_mapping.postal_code
FROM cleaning.vehicle_data
LEFT JOIN public.geographical_location
    ON cleaning.vehicle_data.city = public.geographical_location.city
    AND cleaning.vehicle_data.county = public.geographical_location.county
LEFT JOIN public.postal_mapping
    ON cleaning.vehicle_data.postal_code = public.postal_mapping.postal_code;


-- Inserción de los datos de las especificaciones del vehículo (133 tuplas)
INSERT INTO vehicle_specs (range, basemsrp, cafv)
SELECT DISTINCT range, basemsrp, cafv
FROM cleaning.vehicle_data;


-- Inserción de los datos de los detalles del vehículo (593 tuplas)
INSERT INTO vehicle_details (model, make, model_year, vehicle_type, vehicle_specs_id)
SELECT DISTINCT
    cleaning.vehicle_data.model,
    cleaning.vehicle_data.make,
    cleaning.vehicle_data.model_year,
    cleaning.vehicle_data.vehicle_type,
    public.vehicle_specs.id
FROM cleaning.vehicle_data
LEFT JOIN public.vehicle_specs
    ON cleaning.vehicle_data.range = public.vehicle_specs.range
    AND cleaning.vehicle_data.basemsrp = public.vehicle_specs.basemsrp
    AND cleaning.vehicle_data.cafv = public.vehicle_specs.cafv;


-- Inserción de los datos de todas las llaves para la tabla de vehículo (205,436 tuplas)
WITH location_complete_table AS (
    SELECT location.id,
           location.postal_code,
           location.district,
           geographical_location.city,
           geographical_location.county
    FROM public.location
    INNER JOIN public.geographical_location
        ON location.geographical_location_id = public.geographical_location.id
),

vehicle_details_complete_table AS (
    SELECT public.vehicle_details.id,
           public.vehicle_details.model,
           public.vehicle_details.model_year,
           public.vehicle_details.vehicle_type,
           public.vehicle_specs.range,
           public.vehicle_specs.basemsrp
    FROM public.vehicle_details
    INNER JOIN public.vehicle_specs
        ON public.vehicle_details.vehicle_specs_id = public.vehicle_specs.id
)

INSERT INTO public.vehicle (dol_vehicle_id, vehicle_details_id, location_id, electric_utility_id)
SELECT DISTINCT
    cl.dol_vehicle_id,
    vd.id,
    loc.id,
    eu.id
FROM cleaning.vehicle_data cl
LEFT JOIN public.electric_utility eu
    ON cl.electric_utility = eu.name
LEFT JOIN location_complete_table loc
    ON cl.postal_code = loc.postal_code
    AND cl.legislative_district = loc.district
    AND cl.city = loc.city
    AND cl.county = loc.county
LEFT JOIN vehicle_details_complete_table vd
    ON cl.model = vd.model
    AND cl.model_year = vd.model_year
    AND cl.vehicle_type = vd.vehicle_type
    AND cl.range = vd.range
    AND cl.basemsrp = vd.basemsrp;
