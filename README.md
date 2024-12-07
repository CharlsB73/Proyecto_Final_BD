# Proyecto_Final_BD
Subida del proyecto final elaborado en DataGrip 

## Contenidos
1. [Proyecto](#proyecto)
   1. [Integrantes del equipo](#integrantes-del-equipo)
   1. [Introducción](#introducción)
   1. [Problema a estudiar](#problema-a-estudiar)
   1. [Descripción de los datos y procesamiento](#descripción-de-los-datos)
      1. [Diseño](#diseño-original)
      1. [Atributos](#atributos)
      1. [Dependencias funcionales](#dependencias-funcionales)
      1. [Normalización](#normalización)
      1. [Consideraciones](#consideraciones)
1. [Configuración y proyecto](#configuración)
   1. [DataGrip y requerimientos](#datagrip-y-requerimientos)
   1. [Base de datos](#base-de-datos)
      1. [Carga inicial](#carga-inicial)
      1. [Análisis preliminar](#análisis-preliminar)
      1. [Limpieza de datos](#limpieza-de-datos)
      1. [Análisis de datos](#análisis-de-datos)
      1. [Conclusión](#conclusión)
1. [Estructura del proyecto](#estructura-del-proyecto)

## Proyecto

### Integrantes del equipo:
* [Carlos Gerardo Castillo Campos](https://github.com/CharlsB73)
* [Pablo Ernesto Gómez](https://github.com/Pabo-0)


### Introducción
En este proyecto nos encargamos del proceso de normalización, limpieza y análisis de datos de una base de datos acerca de vehículos eléctricos en el estado de Washington, este proyecto tiene como objetivo optimizar la organización del conjunto de datos aplicando todos los conocimientos adquiridos en clase. En los siguientes apartados abordaremos el proceso de la recopilación de los datos sobre los registros de los vehículos, incluyendo datos como el fabricante, modelo, tipo de carga y ubicación dentro del estado. También buscaremos eliminar todo tipo de redundancia, datos faltantes y otros errores durante el proceso de la limpieza, garantizando que el conjunto sea confiable y se encuentre listo para análisis. Por último, el análisis de los datos trabajados tendrá un enfoque en tratar de identificar factores clave en la adopción de esta nueva tecnología, entenderemos el crecimiento constante de la industria dentro del estado de Washington, el cambio variado en los precios de los vehículos y las implicaciones ambientales que estos resultados predicen para el futuro próximo. 

### Problema a estudiar

Durante el análisis y procesamiento de la base de datos de vehículos eléctricos en el estado de Washington, surgen varios desafíos que requieren atención para garantizar la calidad y utilidad del conjunto de datos. En primer lugar, la estructura actual de los datos presenta redundancias significativas, como registros duplicados de fabricantes o modelos debido a inconsistencias en la entrada de datos. Esto complica la agrupación y el análisis, haciendo necesario implementar un proceso de normalización que elimine estas redundancias y reorganice las tablas para cumplir con las formas normales, asegurando que cada atributo dependa exclusivamente de su clave principal.
Otro problema crítico es la presencia de valores faltantes en atributos importantes como el tipo de carga o la ubicación. Estos vacíos en los datos pueden sesgar el análisis, dificultando la identificación de patrones en la adopción de vehículos eléctricos. Además, es necesario manejar datos erróneos, como ubicaciones mal georreferenciadas o valores inconsistentes en el tipo de carga. Por ejemplo, se han detectado registros donde el mismo modelo de vehículo aparece asociado a diferentes tipos de carga, lo que afecta la confiabilidad del análisis.
Finalmente, es esencial diseñar un esquema que facilite la exploración de factores clave en la adopción de vehículos eléctricos. Esto incluye analizar las tendencias de registro por fabricante y modelo, la distribución geográfica de los vehículos y la relación entre la infraestructura de carga y la densidad de registros. Estos problemas forman el núcleo del proyecto y su resolución será fundamental para extraer conclusiones útiles que puedan informar decisiones sobre la promoción de esta tecnología en el estado.
El estudio de una base de datos relacionada con vehículos eléctricos en el estado de Washington también plantea importantes implicaciones éticas que deben ser consideradas. Dado que los datos pueden incluir información sensible, como ubicaciones geográficas específicas o detalles sobre usuarios particulares, es fundamental garantizar la protección de la privacidad y la seguridad de los datos recopilados. Esto implica adherirse a normativas como el Reglamento General de Protección de Datos (GDPR) o leyes locales de privacidad, evitando cualquier uso indebido o exposición de datos personales. Además, el análisis debe ser transparente y responsable, evitando sesgos que puedan derivar en decisiones perjudiciales para ciertos grupos o regiones. Por ejemplo, al identificar factores clave en la adopción de vehículos eléctricos, es crucial no discriminar contra comunidades con menor acceso a recursos o infraestructura, garantizando que los hallazgos se utilicen para promover la equidad y el desarrollo inclusivo de esta tecnología.


### Descripción de los datos

#### Diseño Original
La base de datos original cuenta con un total de 17 atributos y 205,439 tuplas. Esta fue extraída de https://catalog.data.gov/dataset/electric-vehicle-population-data. Los datos se pueden descargar en [este link](https://drive.google.com/file/d/1x6AvLlwbXijpxsOf5u0_nZI2Tv-gz1vz/view?usp=share_link).

#### Atributos
- VIN (0-10): Identificador único del vehículo reducido a solo 10 dígitos. Este puede identificar a todas las tuplas individualmente de manera única.

- Country: Región geográfica de un estado (condado) en la que reside el propietario del vehículo. Los vehículos matriculados en el estado de Washington pueden estar ubicados en otro estado.

- City:  La ciudad en la que reside el propietario registrado.

- State: Región geográfica del estado asociado con el registro. Esta dirección puede estar ubicada en un estado diferente de Washington.

- Postal Code: Código postal de 5 dígitos en el que reside el propietario registrado. Puede haber un propietario con el mismo código postal y vehículos diferentes. 

- Model Year: Año del modelo del vehículo, determinado al decodificar el VIN.

- Make: Fabricante del vehículo determinado al decodificar el VIN.

- Model: Modelo del vehículo determinado al decodificar el VIN.

- Electric Vehicle Type: Distingue entre un vehículo de batería totalmente eléctrica (BEV) y un vehículo eléctrico híbrido enchufable (PHEV).

- Clean Alternative Fuel Vehicle (CAFV) Eligibility: Elegibilidad del vehículo para ser considerado de combustible alternativo limpio.

- Electric Range: La autonomía eléctrica medida en millas. En caso de que no se haya investigado aún la autonomía esta será 0.

- Base MSRP: Precio de venta sugerido, en caso de que este no tenga es 0.

- Legislative District: La sección específica del estado de Washington en la que reside el propietario del vehículo. Un mismo distrito puede estar asignado a diferentes condados y ciudades. Solo se registrará un distrito si el auto está registrado en Washington, en caso contrario se dejará vacía la tupla.

- DOL Vehicle ID: Número único asignado a cada vehículo por el Departamento de Licencias para fines de identificación. Este puede identificar a todas las tuplas individualmente de manera única.

- Vehicle Location: El centro del código postal del vehículo registrado (coordenadas).

- Electric Utility: Territorios de servicio de energía eléctrica que atienden la dirección del vehículo registrado. Los espacios en blanco aparecen para vehículos con direcciones fuera de Washington o para direcciones que se encuentran en áreas de Washington que no contienen un territorio de servicio mapeado en los datos de origen.

- 2020 Census Tract: El identificador de sección censal es una combinación de los códigos de estado, condado y sección censal asignados por la Oficina del Censo de Estados Unidos en el censo de 2020. Puede haber un propietario con el mismo código censal y vehículos diferentes. 


#### Dependencias Funcionales
{VIN} → {model_year, make, model}. 

{postal_code} → {state, vehicle location}.

{vehicle_location} → {postal_code}. 

{DOL} → E. 

{model} → {make}. 

{model, model_year, range} → {baseMSRP, CAFV}. Esta dependencia funcional solo se cumple después de la limpieza de los datos, si se busca comprobar en el raw la dependencia solo se cumple para el CAFV, no para el  baseMSRP.

{census_track} → {county, state}

{city, county} → {state}

#### Normalización
Para el proceso de normalización decidimos realizar un diagrama de enidad-relación para tener una referencia visual sobre como descomponer los atributos. Primero, decidimos basar la normalización en nuestra intuición con ayuda de las dependencias funcionales encontradas. El resultado fue el siguiente:


![Q1](img/Normalizacion.jpeg "Normalización Inicial") 


La entidad "electric_utility" va a identificar a cada compañía de electricidad de Washington, consideramos necesario separar esta información en una sola entidad ya que solo existen una muy pequeña cantidad de compañías en comparación con la enorme cantidad de vehículos registrados, lo que resulta en un desperdicio de memoria por repetición.

Para la información del vehículo creamos las entidades "vehicle_specs" y "vehicle_details", la primera contiene las especificaciones de la autonomía, precio de mercado sugerido y si es elegible como combustible limpio; la segunda contienene los detalles del modelo, fabricante, año del modelo y tipo del vehículo. Decidimos separar de esta manera la información para reducir la mayor cantidad de tuplas posibles, esto ya que en general no hay muchas variantes en "vehicles_details" mas que el año del modelo, y para el caso de las especificaciones una gran mayoría de tuplas tiene una autonomía no registrada (0), un precio de mercado sugerido no registrado (0) y un CAFV que solo varía entre 3 opciones, lo que elimina mucha información redundadnte reduciéndola a un solo ID.

Para la ubicación utilizamos las entidades "location", "postal_mapping" y "geographical_location". Decidimos agrupar de esta manera la información por dos dependencias importantes, la primera es {postal_code} <-> {vehicle_location} y la segunda es {city, county} → {state}, con estas dependencias las entidades "postal_mapping" y "geographical_location" están implicadas por sus llaves, lo cual acerca más a la base de datos a estar en cuarta forma normal. La entidad "location" no es mas que una agrupación de las otras dos entidades junto con el distrito legislativo, atributo para el cual no encontramos ninguna dependencia funcional, lo que complico aislarlo en otra tabla.

Por último se tiene la entidad "vehicle" que contiene todos los ID principales de las entidades para la ubicación, detalles del vehículo y compañía de electricidad.

##### _Simplificación del modelo:_
Tras haber hecho la normalización bajo nuestra intuición procedimos a verificar todas las dependencias funcionales, revisando si estas estaban implicadas por las llaves. Como se puede observar en la imagen existe una dependencia que no cumple con esta condición, la dependencia {model} → {make}. Como proceso de mejora decidimos aplicar el Teorema de Heath para descomponer la entidad en dos, con tal de que la relación quede implicada por las llaves, lo que llevó a la creación de la entidad "model_make" siguiente:


![Q1](img/4FN.jpeg "Normalización hasta 4FN") 


A pesar de que incluyendo esta nueva tabla toda la base de datos alcanzaría la cuarta forma normal, hemos tomado la decisión de mantener la entidad de los detalles del vehículo como la inicialmente planteada. Nuestro razonamiento detras de esta decisión surge por el ploblema de que la nueva entidad sería atómica, es decir que solo tendríamos una nueva entidad para un solo atributo conectado a traves de su llave "make", lo que complica enormemente el análisis de datos y no proporciona una ventaja significativa, incluso podría llegar a ser poco eficiente por el espacio de memoria utilzizado. La atomización de atributos solo puede ser útil en escenarios extremadamente específicos, como sistemas distribuidos que requieren minimizar redundancias en conjuntos de datos masivos. Sin embargo, en este caso, no hay evidencia de que esa atomización sea necesaria. 

##### _Alineación con los requerimientos del proyecto:_
En este contexto, el objetivo principal del proyecto es facilitar el análisis y la limpieza de datos sobre vehículos eléctricos. El modelo de los datos inicla permite realizar estas tareas de forma más eficiente al mantener una estructura cohesiva y lógica que refleja mejor las relaciones entre los datos del mundo real. En resumen, aunque con la entidad "model_make" se estaría en cuarta forma normal, su nivel de atomización no es necesario para los objetivos del proyecto pues introduciría complicaciones innecesarias. Por lo tanto, el conjunto de entidades inicial representa un compromiso óptimo entre normalización, claridad y eficiencia operativa.


#### Consideraciones
Únicamente se tomarán como válida la clave única del DOL, ya que este es el único atributo capaz de identidicar individualmente a todas las tuplas de la base de datos. Como parte de la tabla "postal_mapping" sí se tendrá como llave primaria el código postal, esto por el cumplimiento de su dependencia funcional con la localización del vehículo que permite tenerla como llave (incluso se podría tener como llave "coordinates" puesto que la dependencia se cumple en ambas direcciones). Para el VIN (identificador del vehículo) y census_track (identificador del censo 2020) estos atributos serán eliminados de la base de datos, esto por la razón de que ambos no importan ningún tipo de información útil al conjunto de datos ya normalizado.


## Configuración


### DataGrip y requerimientos
Para realizar el proyecto, se necesita tener instalado la versión 2024.3 de DataGrip. Se puede descargar en la [página oficial de jetbrains](https://www.jetbrains.com/datagrip/whatsnew/). Además, se tiene que tener instalada la versión 16 de Postgresql; se puede instalar siguiendo las instrucciones de la [página oficial de Postgresql](https://www.postgresql.org/download/). Una vez instalado Postgresql y creado un servidor local con usuario y contraseña, se debe entrar a la terminal de postgresql y ejecutar el comando `CREATE DATABASE vehicle_data;` para crear la base de datos. El resto del proceso se hace en DataGrip. Simplemente se tiene que añadir una fuente de datos del proyecto, se deben ingresar las credenciales pertinentes (usuario, contraseña y nombre de la base de datos a la que se quiere conectar) y crear un nuevo script de SQL.

### Base de datos

#### Carga inicial
##### Notas: 
Se requiere de la extensión PostGIS para poder guardar datos de tipo POINT como coordenadas
-- Pasos para la instalación:
   -- 1) Abrir Stack Builder
   -- 2) Seleccionar la versión de PostgreSQL que se esté utilizando
   -- 3) En la sección de Categorías -> Spatial Extensions -> PostGIS 3.5 descargar la extensión
   -- 4) Una vez terminada la instalación correr el siguiente comando: `CREATE EXTENSION postgis;`
Esta parte del proyecto está programado en el archivo `raw_data_schema_creation`. Ver la carpeta Project para más información.


Se optó por crear un esquema temporal para la subida inicial de los datos. Después de un primer análisis, se eligieron tipos de datos que correspondieren acorde a los extraídos de la base de datos.


`data`

```
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
    baseMSRP BIGINT,                        -- Ejemplo: 36,000
    legislative_district VARCHAR(2),        -- Ejemplo: 35
    dol_vehicle_id BIGINT PRIMARY KEY,      -- Ejemplo: 240684006
    vehicle_location GEOMETRY(Point, 4326), -- Ejemplo: POINT (-122.8728334 47.5798304)
    electric_utility TEXT,                  -- Ejemplo: PUGET SOUND ENERGY INC
    census_tract VARCHAR(12)                -- Ejemplo: 53035091301
);
```
##### Importante:
Se debe ejecutar el comando `\copy raw.vehicle_data (vin, county, city, state, postal_code, model_year, make, model, vehicle_type, CAFV, range, baseMSRP, legislative_district, dol_vehicle_id, vehicle_location, electric_utility, census_tract) FROM 'ubicación_de_los_datos' WITH (FORMAT CSV, HEADER true, DELIMITER ',');` después de crear el esquema `raw`y crear la tabla `vehicle_data`

#### Análisis preliminar
Se recomienda seguir el archivo sql llamado `raw_data_exploration.sql` para mayor comprensión. Consultar la carpeta `Project`donde está guardado este archivo.

En primera instancia, se analizó la unicidad de todas las llaves para así considerar candidatos para llaves primarias de las entidades. Por ejemplo:
```
-- ¿El código postal es único? R: NO
SELECT COUNT(DISTINCT postal_code) FROM raw.vehicle_data;


-- ¿El VIN es único? R: NO
SELECT COUNT(DISTINCT vin) FROM raw.vehicle_data;


-- ¿El census track es único? R: NO
SELECT COUNT(DISTINCT census_tract) FROM raw.vehicle_data;
```

Es importante notar que la normalización se fue adaptando a los resultados obtenidos de los querys ejecutados durante esta etapa inicial de análisis. A continuación, se elaboraron distintos querys que permiten conocer más a fondo la naturaleza y organización de los datos que se tomarán en cuenta durante la limpieza de datos. Se presentan los siguientes ejemplos:

```
-- ¿Para todos los registros fuera de Washington la compañía eléctrica es "NON WASHINGTON
-- STATE ELECTRIC UTILITY"? R: NO
SELECT DISTINCT electric_utility
FROM raw.vehicle_data
WHERE state <> 'WA';


-- ¿Qué años abarcan los modelos de los vehículos?
SELECT DISTINCT model_year FROM raw.vehicle_data ORDER BY model_year;
-- 1997, 1999, 2000, 2002, 2003, 2008, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017,
-- 2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025

-- ¿Qué tan común es que un vehículo no tenga MSRP?
-- R: La gran mayoría de los vehículos no tienen MSRP
SELECT basemsrp, COUNT(dol_vehicle_id)
FROM raw.vehicle_data
group by basemsrp;

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
```

Para verificar que las dependencias funcionales propuestas se cumplieran, fue necesario elaborar querys que permitieran saber si el ó los determinantes X regresaran o no más de una Y. En dado caso que el query regresara algún valor, se puede concluir que la dependencia no se cumple porque un determinante X no identifica únicamente a un determinado Y. Ejemplos:

```
-- Se cumple la dependencia {VIN} -> {model_year, make, model}
SELECT vin,
       COUNT(DISTINCT model_year),
       COUNT(DISTINCT make),
       COUNT(DISTINCT model)
FROM raw.vehicle_data
GROUP BY vin
HAVING COUNT(DISTINCT model_year) > 1
OR COUNT(DISTINCT make) > 1
OR COUNT(DISTINCT model) > 1
AND vin IS NOT NULL;

-- Se cumple la dependencia {postal_code} -> {vehicle_location} para la tabla postal_mapping
SELECT postal_code, COUNT(DISTINCT vehicle_location)
FROM raw.vehicle_data
GROUP BY postal_code
HAVING COUNT(DISTINCT vehicle_location) > 1
AND postal_code IS NOT NULL;

-- No se cumple la dependencia {census_tract} -> {postal_code}
SELECT census_tract,
       COUNT(DISTINCT postal_code)
FROM raw.vehicle_data
GROUP BY census_tract
HAVING COUNT(DISTINCT postal_code) > 1
AND  census_tract IS NOT NULL;

-- No se cumple la dependencia {city} -> {county} para la tabla geographical_location
SELECT city, COUNT(DISTINCT county)
FROM raw.vehicle_data
GROUP BY city
HAVING COUNT(DISTINCT county) > 1
AND city IS NOT NULL;
```

#### Limpieza de datos

Gracias al análisis llevado a cabo en el esquema raw se pudieron formas conclusiones importantes para generar la limpieza de datos. Por ejemplo, se detectaron datos anómalos que solo tenían un dato de información irrelevante, atributos con nombres largos, precios de venta contrarios, entre otros. Para iniciar con la limpieza, se creó un nuevo esquema y una tabla responsable de almacenar los datos a limpiar:

```
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
```

Después, siguió la limpieza de formato del texto:

```
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


```
Luego, la limpieza formal donde se definen `DEFAULT`, eliminación sustitución de datos. Se presentan algunos ejemplos. Se puede ver la limpieza completa en `raw_cleaning.sql`:

```
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
```

Con los datos limpios, se crearon las tablas pertinentes y se insertaron los datos (tomando precación en la inserción de llaves):

```
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
...

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

...

```


#### Análisis de datos

##### Nota: para ver los querys completos, consultar el archivo `data_analysis.sql`
Con los datos limpios, fue pertinente hacer un análisis profundo con consultas SQL que arrojaran datos ricos en contenido para derivar conclusiones relevantes. Se muestran las gráficas obtenidas y una breve descripción:

#### _1.- Cantidad de vehículos registrados por año del modelo (Top 10)_
![Q1](img/query1.png "Gráfica 1") 
Es claro que 2023 fue el año en el que más coches se registraron, casi doblando en cantidad al año actual 2024

#### _2.- Cantidad de vehículos registrados por condado en Washington (Top 10)_
![Q2](img/query2.png "Gráfica 2") 
Existe una diferencia abismal entre los coches registrados de SKAGIT y los registrados de KING dentro de Washington. Si bien es cierto que SKAGIT se mantuvo cercano a sus competidores más próximos, KING ha dominado el mercado hasta el último corte de estos datos.

#### _3.- Vehículo con mayor autonomía de cada fabricante (Top 10)_
![Q3](img/query3.png "Gráfica 3") 
Podemos observar un nivel de autonomía muy similar para las primeras marcas. Sin embargo, la cotizada marca BMW se encuentra resagada en comparacion a Tesla, el competidor más fuerte en la actualidad para coches eléctricos.

#### _4.- Top 10 compañías de electricidad con mayor cantidad de vehículos asignados_
![Q4](img/query4.png "Gráfica 4") 
Bonneville Power Administration ha logrado asignar un gran porcentaje de vehículos en distintos estados. Junto a Puget Sound Energy Inc, estas 2 son los líderes eléctricos de Washington.


#### _5.- Los 10 autos con precio de mercado sugerido más altos_
![Q5](img/query5.png "Gráfica 5") 
A pesar de no formar parte de los pioneros en vehículos eléctricos, Porsche sí forma parte de las marcas con precio de mercado por encima del promedio, superando a Tesla y a BMW.

#### _6.- Top 5 distritos legislativos con más autos registrados_
![Q6](img/query6.png "Gráfica 6") 
Estos son los distritos que más autos registrados. Aunque debe realizarse un estudio más profundo, los datos sugieren que un buen porcentaje de coches registrados en estos estados son modelos KING.

#### _7.- Cantidad de vehículos de batería eléctrica vs híbridos
![Q7](img/query7.png "Gráfica 7") 
Los coches eléctricos abundan y superan a la cantidad actual registrada de coches híbridos. Ante tales números, es posible que exista una disminución en precios del mercado para vehículos de marcas especializadas en baterías híbridas.

#### _8.- Proveedor eléctrico con más vehículos registrados por ciudad (Top 10)_
![Q8](img/query8.png "Gráfica 8") 
ABERDEEN y AIRWAY HEIGHTS han impedido a otros proveedores distribuir la alta demanda de vehiculos con baterías eléctricas o híbridas. 

#### _9.- Cantidad de vehículos elegibles para combustible alternativo limpio (Top 10)_
![Q9](img/query9.png "Gráfica 9") 
Sorprendentemente, la considerable cantidad de coches registrados como híbridos o eléctricos no es totalmente elegible para ser considerada como de uso alternativo limpio. No se tienen más datos para analizar, pero esta conclusión podría significar que una buena parte de las marcas no adopta buenos modelos renovables a sus diseños automotrices.

#### Conclusión:

Este proyecto de análisis y normalización de la base de datos de vehículos eléctricos en el estado de Washington nos permitió abordar de manera integral los retos asociados con la gestión eficiente de datos. Al aplicar procesos de limpieza y normalización, eliminamos redundancias y aseguramos la integridad de los datos, lo que no solo optimizó la estructura de la base sino que también garantizó un conjunto de datos confiable para análisis posteriores. La creación de relaciones significativas entre las entidades y la reestructuración de tablas innecesarias en busca de un balance entre normalización y eficiencia práctica demuestran el valor de una base de datos bien diseñada.

El análisis de los datos limpios reveló patrones importantes, como la abundante distribucion de vehículos eléctricos en los condados más urbanizados por parte de pocos proveedores y un incremento en el uso de vehículos eléctricos a lo largo de los últimos años. Estos hallazgos no solo destacan las áreas donde la transición a vehículos eléctricos es más acelerada, sino que también ofrecen insights valiosos para futuras políticas públicas, como incentivos fiscales o infraestructura de carga. Este trabajo subraya la importancia de mantener un enfoque ético al manejar información sensible, garantizando que el uso de datos respete la privacidad y beneficie a la sociedad en su transición hacia tecnologías más sostenibles.

## Estructura del proyecto
```
├── .idea                                        <- General default archives
├── Project                                      
│   ├── data_analysis.sql                           <- SQL querys for data analysis
│   ├── data_cleaning.sql                           <- Deep data processing, 4NF format
│   ├── raw_data_exploration.sql                    <- Initial analysis with raw data
│   └── raw_data_schema_creation.sql                <- First schema creation and data processiong
├── data                                         <- Link to data download
├── img                                          <- Images used for README.md
├── README.md                                    <- The README for developers using this project.
```
