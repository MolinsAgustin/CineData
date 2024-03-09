Para diseñar una base de datos detallada que abarque el amplio espectro de la industria cinematográfica, incluyendo películas, directores, actores, géneros y premios, abordaremos un modelo que facilitará el manejo de información compleja y variada inherente a este sector. Este modelo permitirá no solo almacenar datos fundamentales, sino también realizar análisis profundos y consultas específicas para entender mejor las dinámicas y tendencias del cine.

## Tabla: Película
ID_Pelicula (INT, clave primaria, autoincrementable): Identificador único para cada película.

Titulo (VARCHAR(255)): El nombre de la película.

fecha_Lanzamiento (DATE): Año de lanzamiento de la película.

Duracion (INT): Duración de la película en minutos.

Sinopsis (TEXT): Descripción breve de la trama de la película.

Idioma (VARCHAR(100)): Idiomas disponibles.

Presupuesto (DECIMAL(15,2)): Costo de producción de la película.

Pais_Lanzamiento (VARCHAR(100)): País donde la película fue lanzada inicialmente.

Score_Critica (DECIMAL(5,2)): Promedio de calificaciones de críticos.

Dinero_Recaudado (DECIMAL(15,2)): Total de ingresos en taquilla.

id_empresa_productora(INT, clave foránea): Identificador de la empresa productora.


## Tabla: Persona
ID_Persona (INT, clave primaria, autoincrementable): Identificador único para cada persona.

Nombre (VARCHAR(255)): Nombre completo de la persona.

Fecha_Nacimiento (DATE): Fecha de nacimiento.

Nacionalidad (VARCHAR(100)): País de origen.

Tabla: Puesto

ID_Puesto (INT, clave primaria, autoincrementable): Identificador único para cada persona.

nombre_puesto (VARCHAR(255)): director, productor, actor, etc.


## Tabla: Persona_Puesto_Pelicula
ID_Pelicula

ID_Persona

ID_Puesto


## Tabla: Personaje
ID_Personaje (INT, clave primaria, autoincrementable): Identificador único para cada personaje interpretado.

ID_Pelicula (INT, clave foránea): Identificador de la película donde se interpreta el rol.

ID_Persona (INT, clave foránea): Identificador de la persona

Nombre_Personaje (VARCHAR(255)): Nombre del personaje.

ID_Interprete (int, clave foránea): identificador del actor.


## Tabla: Género
ID_Genero (INT, clave primaria, autoincrementable): Identificador único para cada género.

Nombre (VARCHAR(100)): Nombre del género.

Descripcion (TEXT): Descripción del género.


## Tabla: Premio
ID_Premio (INT, clave primaria, autoincrementable): Identificador único para cada premio.

Nombre (VARCHAR(255)): Nombre del premio (Óscar, Globo de Oro, etc.).

Categoria (VARCHAR(255)): Categoría del premio (Mejor Película, Mejor Director, etc.).

Edicion (INT): Año en que se otorgó el premio.

ID_Pelicula (INT, clave foránea): Película ganadora del premio.

ID_Persona (INT, clave foránea): Persona ganadora del premio (opcional).


## Tabla: Empresa_Productora
ID_Empresa_Productora(INT, clave primaria, autoincrementable): Identificador único de la empresa productora.

Nombre (VARCHAR(255)): Nombre de la empresa.

Pais (VARCHAR(100)): País de origen de la empresa.


## Tabla: Película_Género
ID_Pelicula (INT, clave foránea): Identificador de la película.

ID_Genero (INT, clave foránea): Identificador del género.

