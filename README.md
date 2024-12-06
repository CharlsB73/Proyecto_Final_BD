# Proyecto_Final_BD
Subida del proyecto final elaborado en DataGrip 

## Contenidos
1. [Proyecto](#proyecto)
   1. [Integrantes del equipo](#integrantes-del-equipo)
   1. [Introducción](#introducción)
   1. [Problema a estudiar](#problema-a-estudiar)
   1. [Descripción de los datos](#descripción-de-los-datos)
1. [Configuración](#configuración)
   1. [DataGrip y requerimientos](#datagrip-y-requerimientos)
   1. [Base de datos](#base-de-datos)
1. [Estructura del proyecto](#estructura-del-proyecto)

## Proyecto

### Integrantes del equipo:
* [Carlos Gerardo Castillo Campos](https://github.com/CharlsB73)
* [Pablo Ernesto Gómez](https://github.com/Pabo-0)



### Introducción
Durante el análisis y procesamiento de la base de datos de vehículos eléctricos en el estado de Washington, surgen varios desafíos que requieren atención para garantizar la calidad y utilidad del conjunto de datos. En primer lugar, la estructura actual de los datos presenta redundancias significativas, como registros duplicados de fabricantes o modelos debido a inconsistencias en la entrada de datos. Esto complica la agrupación y el análisis, haciendo necesario implementar un proceso de normalización que elimine estas redundancias y reorganice las tablas para cumplir con las formas normales, asegurando que cada atributo dependa exclusivamente de su clave principal.
Otro problema crítico es la presencia de valores faltantes en atributos importantes como el tipo de carga o la ubicación. Estos vacíos en los datos pueden sesgar el análisis, dificultando la identificación de patrones en la adopción de vehículos eléctricos. Además, es necesario manejar datos erróneos, como ubicaciones mal georreferenciadas o valores inconsistentes en el tipo de carga. Por ejemplo, se han detectado registros donde el mismo modelo de vehículo aparece asociado a diferentes tipos de carga, lo que afecta la confiabilidad del análisis.
Finalmente, es esencial diseñar un esquema que facilite la exploración de factores clave en la adopción de vehículos eléctricos. Esto incluye analizar las tendencias de registro por fabricante y modelo, la distribución geográfica de los vehículos y la relación entre la infraestructura de carga y la densidad de registros. Estos problemas forman el núcleo del proyecto y su resolución será fundamental para extraer conclusiones útiles que puedan informar decisiones sobre la promoción de esta tecnología en el estado.
El estudio de una base de datos relacionada con vehículos eléctricos en el estado de Washington también plantea importantes implicaciones éticas que deben ser consideradas. Dado que los datos pueden incluir información sensible, como ubicaciones geográficas específicas o detalles sobre usuarios particulares, es fundamental garantizar la protección de la privacidad y la seguridad de los datos recopilados. Esto implica adherirse a normativas como el Reglamento General de Protección de Datos (GDPR) o leyes locales de privacidad, evitando cualquier uso indebido o exposición de datos personales. Además, el análisis debe ser transparente y responsable, evitando sesgos que puedan derivar en decisiones perjudiciales para ciertos grupos o regiones. Por ejemplo, al identificar factores clave en la adopción de vehículos eléctricos, es crucial no discriminar contra comunidades con menor acceso a recursos o infraestructura, garantizando que los hallazgos se utilicen para promover la equidad y el desarrollo inclusivo de esta tecnología.


### Descripción de los datos

#### Diseño Original
La base de datos original cuenta con un total de 17 atributos y 205,440 tuplas. Esta fue extraída de https://catalog.data.gov/dataset/electric-vehicle-population-data. Los datos se pueden descargar en [este link](https://drive.google.com/file/d/1x6AvLlwbXijpxsOf5u0_nZI2Tv-gz1vz/view?usp=share_link).

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
La elección del conjunto de entidades de la izquierda en lugar de las de la derecha, aunque estas últimas estén en cuarta forma normal (4FN), se justifica por criterios de eficiencia práctica y diseño lógico de la base de datos, como se detalla a continuación:

##### _Simplificación del modelo de datos:_
Las tablas de la derecha, aunque cumplen con la 4FN, introducen una gran cantidad de tablas con un único atributo (por ejemplo, country_state o city_county). Estas entidades atomizadas complican innecesariamente el diseño de la base de datos y las consultas que operan sobre ellas, incrementando la cantidad de JOINs requeridos para recuperar datos completos. Esto resulta en operaciones más costosas y un mantenimiento más complejo del sistema.

##### _Optimización del rendimiento:_
El conjunto de entidades de la izquierda combina información relacionada (como location, que incluye postal_code, state, y city) en una única tabla estructurada de manera eficiente. Esto reduce la sobrecarga en el procesamiento de consultas, ya que no es necesario realizar múltiples uniones para obtener información que debería estar agrupada lógicamente. Este diseño balancea la normalización y la eficiencia operativa.

##### _Evitar complejidad innecesaria:_
La atomización de atributos (como en las entidades de la derecha) puede ser útil en escenarios extremadamente específicos, como sistemas distribuidos que requieren minimizar redundancias en conjuntos de datos masivos. Sin embargo, en este caso, no hay evidencia de que esa atomización sea necesaria. Al contrario, un diseño tan fragmentado añade complejidad sin un beneficio claro.

##### _Usabilidad y claridad:_
Las entidades de la izquierda son más fáciles de interpretar y manipular por los usuarios y desarrolladores. Por ejemplo, tener toda la información de ubicación en una sola tabla (location) permite una comprensión más directa del modelo de datos y hace que la escritura de consultas sea más intuitiva.

##### _Evitar restricciones innecesarias:_
Crear tablas con un solo atributo (como city_county) puede ser visto como una aplicación excesiva de la normalización, ya que no aporta un beneficio real en la integridad de los datos ni en la reducción de redundancias. Al contrario, introduce restricciones que podrían ser irrelevantes para los requerimientos reales del sistema.

##### _Alineación con los requerimientos del proyecto:_
En este contexto, el objetivo principal del proyecto es facilitar el análisis y la limpieza de datos sobre vehículos eléctricos. El modelo de la izquierda permite realizar estas tareas de forma más eficiente al mantener una estructura cohesiva y lógica que refleja mejor las relaciones entre los datos del mundo real.
En resumen, aunque las entidades de la derecha estén en una forma normal más avanzada, su nivel de atomización no era necesario para los objetivos del proyecto y habría introducido complicaciones innecesarias. Por lo tanto, el conjunto de entidades de la izquierda representa un compromiso óptimo entre normalización, claridad y eficiencia operativa.


#### Consideraciones
Se tomarán como claves únicas de las entidades el VIN y el Código Postal, esto porque el DOL no aporta ninguna información relevante para el análisis y por la complejidad de obtener información a través del código censal. Es importante aclarar que aunque no todas las tuplas contienen código postal este se tomará como llave para la entidad de ubicación, pues todas las tablas que contienen los datos de ubicación sí tienen código postal y este devuelve la misma información que se puede obtener del código censal.


## Configuración


### DataGrip y requerimientos


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
Se recomienda seguir el archivo sql llamado `raw_data_exploration` para mayor comprensión. Consultar la carpeta `Project`donde está guardado este archivo.

d

#### Limpieza de datos


#### Análisis de datos

#### Preguntas a contestar con el modelo


## Estructura del proyecto


