/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */
-- ANÁLISIS PRELIMINAR
/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */

-- Conteo Inicial: 205,439 tuplas
SELECT COUNT(*) FROM raw.vehicle_data;


-- Vista preliminar
SELECT * FROM raw.vehicle_data LIMIT 10;


-- ¿El DOL es único? R: SÌ
SELECT COUNT(DISTINCT dol_vehicle_id) FROM raw.vehicle_data;


-- ¿El código postal es único? R: NO
SELECT COUNT(DISTINCT postal_code) FROM raw.vehicle_data;


-- ¿El VIN es único? R: NO
SELECT COUNT(DISTINCT vin) FROM raw.vehicle_data;


-- ¿El census track es único? R: NO
SELECT COUNT(DISTINCT census_tract) FROM raw.vehicle_data;


-- ¿Solo hay registros para el estado de Washington? R: NO
SELECT * FROM raw.vehicle_data WHERE state <> 'WA';


-- ¿Para todos los registros fuera de Washington la compañía eléctrica es "NON WASHINGTON
-- STATE ELECTRIC UTILITY"? R: NO
SELECT DISTINCT electric_utility
FROM raw.vehicle_data
WHERE state <> 'WA';


-- ¿Qué años abarcan los modelos de los vehículos?
SELECT DISTINCT model_year FROM raw.vehicle_data ORDER BY model_year;
-- 1997, 1999, 2000, 2002, 2003, 2008, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017,
-- 2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025


-- ¿Qué fabricantes están registrados?
SELECT DISTINCT make FROM raw.vehicle_data;


-- Comprobamos que solo existan los 2 tipos de vehículos
SELECT DISTINCT vehicle_type FROM raw.vehicle_data;
-- Battery Electric Vehicle (BEV)
-- Plug-in Hybrid Electric Vehicle (PHEV)


-- Comprobamos que solo existan los 3 tipos de CAFV
SELECT DISTINCT cafv FROM raw.vehicle_data;
-- Clean Alternative Fuel Vehicle Eligible
-- Eligibility unknown as battery range has not been researched
-- Not eligible due to low battery range


-- ¿Qué tan común es que un vehículo no tenga MSRP?
-- R: La gran mayoría de los vehículos no tienen MSRP
SELECT basemsrp, COUNT(dol_vehicle_id)
FROM raw.vehicle_data
group by  basemsrp;


-- ¿Hay algún dato fuera del estado de Washington con un distrito legislativo? R: NO
SELECT DISTINCT legislative_district
FROM raw.vehicle_data
WHERE state != 'WA';


-- La página DATA.GOV advertía acerca de los datos que algunos registros no tienen un
-- código postal, esto puede representar un problema ya que muchos atributos de la ubicación
-- dependen de este código.
SELECT * FROM raw.vehicle_data WHERE postal_code IS NULL;

-- Nos damos cuenta que solo los vehículos que no tienen código postal contienen los atributos
-- county, city, state, census_track y electric_utility como nulos, para todas las demás tuplas no son NULL.
SELECT * FROM raw.vehicle_data
WHERE county IS NULL
   OR city IS NULL
   OR state IS NULL
   OR census_tract IS NULL
   OR electric_utility IS NULL;


-- Además de estos 3 atributos que no son nulos comprobamos para los demás
SELECT make FROM raw.vehicle_data WHERE make IS NULL;                                   -- NO hay NULLs
SELECT model_year FROM raw.vehicle_data WHERE model_year IS NULL;                       -- NO hay NULLs
SELECT vehicle_type FROM raw.vehicle_data WHERE vehicle_type IS NULL;                   -- NO hay NULLs
SELECT cafv FROM raw.vehicle_data WHERE cafv IS NULL;                                   -- NO hay NULLs
SELECT legislative_district FROM raw.vehicle_data WHERE legislative_district IS NULL;   -- SÍ hay NULLs
SELECT vehicle_location FROM raw.vehicle_data WHERE vehicle_location IS NULL;           -- SÍ hay NULLs
SELECT range FROM raw.vehicle_data WHERE range IS NULL;                                 -- SÍ hay NULLs
SELECT basemsrp FROM raw.vehicle_data WHERE basemsrp IS NULL;                           -- SÍ hay NULLs
SELECT model FROM raw.vehicle_data WHERE model IS NULL;                                 -- SÍ hay NULLs