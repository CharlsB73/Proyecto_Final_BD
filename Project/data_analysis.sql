-- Cantidad de vehículos registrados por año del modelo
SELECT vehicle_details.model_year,
       COUNT(vehicle.dol_vehicle_id)
FROM vehicle
INNER JOIN vehicle_details
    ON vehicle.vehicle_details_id = vehicle_details.id
GROUP BY vehicle_details.model_year
ORDER BY vehicle_details.model_year DESC;


-- Cantidad de vehículos registrados por condado en Washington (Top 15)
SELECT geographical_location.county,
       COUNT(vehicle.*)
FROM vehicle
INNER JOIN location
ON vehicle.location_id = location.id
INNER JOIN geographical_location
    ON location.geographical_location_id = geographical_location.id
    AND geographical_location.state = 'WA'
GROUP BY geographical_location.county
ORDER BY COUNT(vehicle.*) DESC
LIMIT 15;


-- Vehículo con mayor autonomía de cada fabricante
WITH vehiculosRankeados AS (
    SELECT vehicle_details.make,
           vehicle_details.model,
           vehicle_details.model_year,
           vehicle_specs.range,
           ROW_NUMBER() OVER (PARTITION BY make ORDER BY vehicle_specs.range DESC) AS rank
    FROM vehicle_details
    INNER JOIN vehicle_specs
        ON vehicle_details.vehicle_specs_id = vehicle_specs.id
)

SELECT make, model, model_year, range
FROM vehiculosRankeados
WHERE rank = 1
ORDER BY range DESC;


-- Top 10 compañías de electricidad con mayor cantidad de vehículos asignados
SELECT electric_utility.name,
       COUNT(vehicle.*)
FROM vehicle
INNER JOIN electric_utility
    ON vehicle.electric_utility_id = electric_utility.id
GROUP BY electric_utility.name
ORDER BY COUNT(vehicle.*) DESC
LIMIT 10;


-- Los 15 autos con precio de mercado sugerido más altos
SELECT DISTINCT vehicle_details.make,
                vehicle_details.model,
                vehicle_details.model_year,
                vehicle_specs.basemsrp
FROM vehicle
INNER JOIN vehicle_details
    ON vehicle.vehicle_details_id = vehicle_details.id
INNER JOIN vehicle_specs
    ON vehicle_details.vehicle_specs_id = vehicle_specs.id
    AND vehicle_specs.basemsrp != 0.00
ORDER BY vehicle_specs.basemsrp DESC
LIMIT 15;


-- Top 5 distritos legislativos con más autos registrados
SELECT location.district,
       COUNT(vehicle.*)
FROM vehicle
INNER JOIN location
ON vehicle.location_id = location.id
GROUP BY location.district
ORDER BY COUNT(vehicle.*) DESC
LIMIT 5;


-- Cantidad de vehículos de batería eléctrica vs híbridos
SELECT vehicle_details.vehicle_type,
       COUNT(vehicle.*)
FROM vehicle
INNER JOIN vehicle_details
    ON vehicle.vehicle_details_id = vehicle_details.id
GROUP BY vehicle_details.vehicle_type
ORDER BY COUNT(vehicle.*) DESC;


-- Proveedor eléctrico con más vehículos registrados por ciudad
WITH tarifasRankeadas AS (
    SELECT geographical_location.city,
        electric_utility.name AS proveedor_electrico,
        COUNT(vehicle.dol_vehicle_id) AS cantidad_vehiculos,
        RANK() OVER (PARTITION BY geographical_location.city ORDER BY COUNT(vehicle.dol_vehicle_id) DESC) AS rank
    FROM vehicle
    INNER JOIN location
        ON vehicle.location_id = location.id
    INNER JOIN geographical_location
        ON location.geographical_location_id = geographical_location.id
    INNER JOIN electric_utility
        ON vehicle.electric_utility_id = electric_utility.id
    GROUP BY geographical_location.city, electric_utility.name
)

SELECT city,
    proveedor_electrico,
    cantidad_vehiculos
FROM tarifasRankeadas
WHERE rank = 1
ORDER BY city;


-- Cantidad de vehículos elegibles para combustible alternativo limpio
SELECT vehicle_specs.cafv,
       COUNT(vehicle.*)
FROM vehicle
INNER JOIN vehicle_details
    ON vehicle.vehicle_details_id = vehicle_details.id
INNER JOIN vehicle_specs
    ON vehicle_details.vehicle_specs_id = vehicle_specs.id
GROUP BY vehicle_specs.cafv
ORDER BY COUNT(vehicle.*) DESC;
