-- Cantidad de vehículos registrados por año del modelo
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


-- Top 10 de fabricantes según la autonomía de  com mayor autonomía
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

SELECT DISTINCT cleaning.vehicle_details.make FROM cleaning.vehicle_details;