# Proyecto_Final_BD
Subida del proyecto final elaborado en DataGrip 

## Contenidos
1. [Proyecto](#proyecto)
   1. [Integrantes del equipo](#integrantes-del-equipo)
   1. [Descripción de los datos](#descripción-de-los-datos)
   1. [Preguntas analíticas a contestar](#preguntas-analíticas-a-contestar-con-el-modelo)
1. [Configuración](#configuración)
   1. [DataGrip y requerimientos](#datagrip-y-requerimientos)
   1. [Base de datos](#base-de-datos)
1. [Estructura del proyecto](#estructura-del-proyecto)

## Proyecto

### Integrantes del equipo:
* [Carlos Gerardo Castillo Campos](https://github.com/CharlsB73)
* [Pablo Ernesto Gómez](https://github.com/Pabo-0)

### Descripción de los datos

#### Diseño Original
La base de datos original cuenta con un total de 17 atributos y 205,440 tuplas. Esta fue extraída de https://catalog.data.gov/dataset/electric-vehicle-population-data.

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
{VIN} → E. El VIN puede identificar el encabezado de todas las tuplas.

{postal_code} → {country, state, vehicle location}. Dado un código postal este puede identificar el condado, estado y la ubicación del vehículo; sin embargo, no todas las tuplas contienen un código postal.

{census_track} → {postal_code}. Dado un código censal este puede identificar el código postal; sin embargo, no todas las tuplas contienen un código censal.

{DOL} → E. El DOL puede identificar el encabezado de todas las tuplas.

{city} → {country}. Dada una ciudad se puede saber a qué condado pertenece; sin embargo, sólo las tuplas con código postal contienen una ciudad.

{country} → {state}. Dado un condado se puede saber a qué estado pertenece; sin embargo, sólo las tuplas con código postal contienen un condado.

{model} → {make}. Dado un modelo de auto se puede conocer su fabricante.

{model, model_year} →→ {vehicle_type, range, baseMSR, CAFV}.  Dado un modelo y año de auto se puede conocer su tipo de vehículo, rango, precio sugerido de venta y CAFV.

{vehicle_location} → {country, state}. Dada la ubicación en coordenadas de un vehículo se puede saber el condado, ciudad y país al que pertenece; sin embargo, sólo las tuplas con código postal contienen una ubicación del vehículo.


#### Consideraciones
Se tomarán como claves únicas de las entidades el VIN y el Código Postal, esto porque el DOL no aporta ninguna información relevante para el análisis y por la complejidad de obtener información a través del código censal. Es importante aclarar que aunque no todas las tuplas contienen código postal este se tomará como llave para la entidad de ubicación, pues todas las tablas que contienen los datos de ubicación sí tienen código postal y este devuelve la misma información que se puede obtener del código censal.


### Preguntas analíticas a contestar con el modelo.


## Configuración

### DataGrip y requerimientos

### Base de datos


## Estructura del proyecto


