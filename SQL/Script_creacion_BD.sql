-------------------------- [ CREACIÓN DE LA BD ] --------------------------

DROP DATABASE IF EXISTS CineData
CREATE DATABASE CineData
USE CineData
GO

-------------------------- [ CREACIÓN DE LAS TABLAS ] --------------------------

CREATE TABLE PELICULA(
	ID_pelicula int identity(1,1) PRIMARY KEY NOT NULL,
	titulo VARCHAR(255) NOT NULL,
	fecha_lanzamiento date NOT NULL,
	duracion int NOT NULL,
	sinopsis TEXT,
	idioma VARCHAR(100) NOT NULL,
	presupuesto DECIMAL(15,2) NOT NULL,
	pais_lanzamiento VARCHAR(100) NOT NULL,
	score_critica DECIMAL(5,2) NOT NULL,
	dinero_recaudado DECIMAL(15,2) NOT NULL,
	id_empresa_productora int NOT NULL
)

CREATE TABLE PERSONA(
	ID_persona int identity(1,1) PRIMARY KEY,
	nombre varchar(255) NOT NULL,
	fecha_nacimiento date NOT NULL,
	nacionalidad varchar(100) NOT NULL
)

CREATE TABLE PUESTO(
	ID_puesto INT IDENTITY(1,1) PRIMARY KEY,
	nombre_puesto VARCHAR(255) NOT NULL
)

CREATE TABLE PERSONA_PUESTO_PELICULA(
	ID_Pelicula INT NOT NULL,
	ID_Persona INT NOT NULL,
	ID_Puesto INT NOT NULL,
	CONSTRAINT PK_PERSONA_PUESTO_PELICULA PRIMARY KEY(ID_PELICULA,ID_PERSONA,ID_PUESTO)  -- Se define el conjunto de claves primarias
)

CREATE TABLE PERSONAJE(
	ID_Personaje int identity(1,1) PRIMARY KEY NOT NULL,
	ID_Pelicula INT NOT NULL,
	Nombre_Personaje VARCHAR(255) NOT NULL,
	ID_Interprete INT NOT NULL,
)

CREATE TABLE GENERO(
	ID_Genero INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Nombre VARCHAR(100) NOT NULL,
	Descripcion TEXT
)

CREATE TABLE PELICULA_GENERO(
	ID_Pelicula int NOT NULL,
	ID_Genero INT NOT NULL,
	CONSTRAINT PK_PELICULA_GENERO PRIMARY KEY (ID_PELICULA,ID_GENERO)		-- Se define el conjunto de claves primarias
)

CREATE TABLE PREMIO(
	ID_Premio INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Nombre VARCHAR(255) NOT NULL,
	Categoria VARCHAR(255) NOT NULL,
	Edicion INT NOT NULL,
	ID_Pelicula INT,
	ID_Persona INT
)

CREATE TABLE EMPRESA_PRODUCTORA(
	ID_Empresa_Productora INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Nombre VARCHAR(255) NOT NULL,
	Pais VARCHAR(100) NOT NULL
)

-------------------------- [ RELACION ENTRE TABLAS MEDIANTE FOREIGN KEYS ] --------------------------

ALTER TABLE PERSONA_PUESTO_PELICULA
ADD CONSTRAINT FK_PUESTO_PERSONA FOREIGN KEY
(ID_PERSONA) REFERENCES PERSONA(ID_PERSONA)

ALTER TABLE PERSONA_PUESTO_PELICULA
ADD CONSTRAINT FK_PUESTO_PELICULA FOREIGN KEY
(ID_PELICULA) REFERENCES PELICULA(ID_PELICULA)

ALTER TABLE PERSONA_PUESTO_PELICULA
ADD CONSTRAINT FK_PUESTO FOREIGN KEY
(ID_PUESTO) REFERENCES PUESTO(ID_PUESTO)

ALTER TABLE PERSONAJE
ADD CONSTRAINT FK_PERSONAJE_PELICULA FOREIGN KEY
(ID_PELICULA) REFERENCES PELICULA(ID_PELICULA)

ALTER TABLE PREMIO
ADD CONSTRAINT FK_PREMIO_PELICULA FOREIGN KEY
(ID_PELICULA) REFERENCES PELICULA(ID_PELICULA)

ALTER TABLE PREMIO
ADD CONSTRAINT FK_PREMIO_PERSONA FOREIGN KEY
(ID_PERSONA) REFERENCES PERSONA(ID_PERSONA)

ALTER TABLE PERSONAJE
ADD CONSTRAINT FK_PERSONAJE_INTERPRETE FOREIGN KEY
(ID_INTERPRETE) REFERENCES PERSONA(ID_PERSONA)

ALTER TABLE PELICULA
ADD CONSTRAINT FK_EMPRESA FOREIGN KEY
(ID_empresa_productora) references empresa_productora(ID_empresa_productora)

ALTER TABLE PELICULA_GENERO
ADD CONSTRAINT FK_GENERO FOREIGN KEY
(ID_GENERO) REFERENCES GENERO(ID_GENERO)

ALTER TABLE PELICULA_GENERO
ADD CONSTRAINT FK_PELICULA_GENERO FOREIGN KEY
(ID_PELICULA) REFERENCES PELICULA(ID_PELICULA)

-------------------------- [ CREACIÓN DE PROCEDIMIENTOS ALMACENADOS CRUD ] --------------------------

-- Pelicula

CREATE PROCEDURE sp_CreatePelicula
    @titulo VARCHAR(255),
    @fecha_lanzamiento DATE,
    @duracion INT,
    @sinopsis TEXT,
    @idioma VARCHAR(100),
    @presupuesto DECIMAL(15,2),
    @pais_lanzamiento VARCHAR(100),
    @score_critica DECIMAL(5,2),
    @dinero_recaudado DECIMAL(15,2),
    @id_empresa_productora INT
AS
BEGIN
    BEGIN TRY
        INSERT INTO PELICULA(titulo, fecha_lanzamiento, duracion, sinopsis, idioma, presupuesto, pais_lanzamiento, score_critica, dinero_recaudado, id_empresa_productora)
        VALUES (@titulo, @fecha_lanzamiento, @duracion, @sinopsis, @idioma, @presupuesto, @pais_lanzamiento, @score_critica, @dinero_recaudado, @id_empresa_productora)
    END TRY
    BEGIN CATCH
        PRINT 'Error al crear una pelicula'
    END CATCH
END
GO

CREATE PROCEDURE sp_ReadPelicula
    @ID_pelicula INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM PELICULA WHERE ID_pelicula = @ID_pelicula
END
GO

CREATE PROCEDURE sp_UpdatePelicula
    @ID_pelicula INT,
    @titulo VARCHAR(255),
    @fecha_lanzamiento DATE,
    @duracion INT,
    @sinopsis TEXT,
    @idioma VARCHAR(100),
    @presupuesto DECIMAL(15,2),
    @pais_lanzamiento VARCHAR(100),
    @score_critica DECIMAL(5,2),
    @dinero_recaudado DECIMAL(15,2),
    @id_empresa_productora INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        UPDATE PELICULA
        SET titulo = @titulo,
            fecha_lanzamiento = @fecha_lanzamiento,
            duracion = @duracion,
            sinopsis = @sinopsis,
            idioma = @idioma,
            presupuesto = @presupuesto,
            pais_lanzamiento = @pais_lanzamiento,
            score_critica = @score_critica,
            dinero_recaudado = @dinero_recaudado,
            id_empresa_productora = @id_empresa_productora
        WHERE ID_pelicula = @ID_pelicula
    END TRY
    BEGIN CATCH
        PRINT 'Error al actualizar una pelicula'
    END CATCH
END
GO


CREATE PROCEDURE sp_DeletePelicula
    @ID_pelicula INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DELETE FROM PELICULA WHERE ID_pelicula = @ID_pelicula
    END TRY
    BEGIN CATCH
        PRINT 'Error al eliminar una pelicula'
    END CATCH
END
GO

-- Peliculas_genero

CREATE PROCEDURE sp_CreatePeliculaGenero
    @ID_Pelicula INT,
    @ID_Genero INT
AS
BEGIN
    SET NOCOUNT ON;

        INSERT INTO PELICULA_GENERO(ID_Pelicula, ID_Genero)
        VALUES (@ID_Pelicula, @ID_Genero)
END
GO

CREATE PROCEDURE sp_ReadPeliculaGenero
    @ID_Pelicula INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM PELICULA_GENERO WHERE ID_Pelicula = @ID_Pelicula
END
GO

-- Para la tabla PELICULA_GENERO, el update no es común ya que la relación es directa,
-- pero si se quisiera cambiar el género de una película se haría algo como esto:

CREATE PROCEDURE sp_UpdatePeliculaGenero
    @ID_Pelicula INT,
    @ID_Genero_Old INT,
    @ID_Genero_New INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        UPDATE PELICULA_GENERO
        SET ID_Genero = @ID_Genero_New
        WHERE ID_Pelicula = @ID_Pelicula AND ID_Genero = @ID_Genero_Old
    END TRY
    BEGIN CATCH
        PRINT 'Error al actualizar una pelicula con su/s genero/s'
    END CATCH
END
GO

CREATE PROCEDURE sp_DeletePeliculaGenero
    @ID_Pelicula INT,
    @ID_Genero INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DELETE FROM PELICULA_GENERO WHERE ID_Pelicula = @ID_Pelicula AND ID_Genero = @ID_Genero
    END TRY
    BEGIN CATCH
        PRINT 'Error al eliminar el/los genero/s de una pelicula'
    END CATCH
END
GO

-- Genero

CREATE PROCEDURE sp_CreateGenero
    @Nombre VARCHAR(100),
    @Descripcion TEXT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO GENERO(Nombre, Descripcion)
        VALUES (@Nombre, @Descripcion)
    END TRY
    BEGIN CATCH
        PRINT 'Error al crear un nuevo genero'
    END CATCH
END
GO

CREATE PROCEDURE sp_ReadGenero
    @ID_Genero INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM GENERO WHERE ID_Genero = @ID_Genero
END
GO

CREATE PROCEDURE sp_UpdateGenero
    @ID_Genero INT,
    @Nombre VARCHAR(100),
    @Descripcion TEXT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        UPDATE GENERO
        SET Nombre = @Nombre,
            Descripcion = @Descripcion
        WHERE ID_Genero = @ID_Genero
    END TRY
    BEGIN CATCH
        PRINT 'Error al actualizar un genero'
    END CATCH
END
GO

CREATE PROCEDURE sp_DeleteGenero
    @ID_Genero INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DELETE FROM GENERO WHERE ID_Genero = @ID_Genero
    END TRY
    BEGIN CATCH
        PRINT 'Error al eliminar un genero'
    END CATCH
END
GO

--Empresa_productora

CREATE PROCEDURE sp_CreateEmpresaProductora
    @Nombre VARCHAR(255),
    @Pais VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO EMPRESA_PRODUCTORA(Nombre, Pais)
        VALUES (@Nombre, @Pais)
    END TRY
    BEGIN CATCH
        PRINT 'Error al crear una empresa productora'
    END CATCH
END
GO

CREATE PROCEDURE sp_ReadEmpresaProductora
    @ID_Empresa_Productora INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT * FROM EMPRESA_PRODUCTORA WHERE ID_Empresa_Productora = @ID_Empresa_Productora
    END TRY
    BEGIN CATCH
        PRINT 'Error al leer la información de la empresa productora.'
    END CATCH
END
GO

CREATE PROCEDURE sp_UpdateEmpresaProductora
    @ID_Empresa_Productora INT,
    @Nombre VARCHAR(255),
    @Pais VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        UPDATE EMPRESA_PRODUCTORA
        SET Nombre = @Nombre, Pais = @Pais
        WHERE ID_Empresa_Productora = @ID_Empresa_Productora
    END TRY
    BEGIN CATCH
        PRINT 'Error al actualizar la información de la empresa productora.'
    END CATCH
END
GO

CREATE PROCEDURE sp_DeleteEmpresaProductora
    @ID_Empresa_Productora INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DELETE FROM EMPRESA_PRODUCTORA WHERE ID_Empresa_Productora = @ID_Empresa_Productora
    END TRY
    BEGIN CATCH
        PRINT 'Error al eliminar la empresa productora.'
    END CATCH
END
GO


-- Personaje

CREATE PROCEDURE sp_CreatePersonaje
    @ID_Pelicula INT,
    @Nombre_Personaje VARCHAR(255),
    @ID_Interprete INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO PERSONAJE(ID_Pelicula, Nombre_Personaje, ID_Interprete)
        VALUES (@ID_Pelicula, @Nombre_Personaje, @ID_Interprete)
    END TRY
    BEGIN CATCH
        PRINT 'Error al intentar crear un nuevo personaje.'
    END CATCH
END;
GO

CREATE PROCEDURE sp_ReadPersonaje
    @ID_Personaje INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT * FROM PERSONAJE WHERE ID_Personaje = @ID_Personaje
    END TRY
    BEGIN CATCH
        PRINT 'Error al intentar leer información del personaje.'
    END CATCH
END;
GO

CREATE PROCEDURE sp_UpdatePersonaje
    @ID_Personaje INT,
    @ID_Pelicula INT,
    @Nombre_Personaje VARCHAR(255),
    @ID_Interprete INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        UPDATE PERSONAJE
        SET ID_Pelicula = @ID_Pelicula,
            Nombre_Personaje = @Nombre_Personaje,
            ID_Interprete = @ID_Interprete
        WHERE ID_Personaje = @ID_Personaje
    END TRY
    BEGIN CATCH
        PRINT 'Error al intentar actualizar información del personaje.'
    END CATCH
END;
GO

CREATE PROCEDURE sp_DeletePersonaje
    @ID_Personaje INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DELETE FROM PERSONAJE WHERE ID_Personaje = @ID_Personaje
    END TRY
    BEGIN CATCH
        PRINT 'Error al intentar eliminar el personaje.'
    END CATCH
END;
GO

-- Persona


CREATE PROCEDURE sp_CreatePersona
    @nombre VARCHAR(255),
    @fecha_nacimiento DATE,
    @nacionalidad VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO PERSONA(nombre, fecha_nacimiento, nacionalidad)
        VALUES (@nombre, @fecha_nacimiento, @nacionalidad)
    END TRY
    BEGIN CATCH
        PRINT 'Error al intentar crear una nueva persona.'
    END CATCH
END;
GO

CREATE PROCEDURE sp_ReadPersona
    @ID_persona INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT * FROM PERSONA WHERE ID_persona = @ID_persona
    END TRY
    BEGIN CATCH
        PRINT 'Error al intentar leer información de la persona.'
    END CATCH
END;
GO


CREATE PROCEDURE sp_UpdatePersona
    @ID_persona INT,
    @nombre VARCHAR(255),
    @fecha_nacimiento DATE,
    @nacionalidad VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        UPDATE PERSONA
        SET nombre = @nombre,
            fecha_nacimiento = @fecha_nacimiento,
            nacionalidad = @nacionalidad
        WHERE ID_persona = @ID_persona
    END TRY
    BEGIN CATCH
        PRINT 'Error al intentar actualizar información de la persona.'
    END CATCH
END;
GO

CREATE PROCEDURE sp_DeletePersona
    @ID_persona INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DELETE FROM PERSONA WHERE ID_persona = @ID_persona
    END TRY
    BEGIN CATCH
        PRINT 'Error al intentar eliminar la persona.'
    END CATCH
END;
GO

-- Puesto

CREATE PROCEDURE sp_CreatePuesto
    @nombre_puesto VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO PUESTO(nombre_puesto)
        VALUES (@nombre_puesto)
    END TRY
    BEGIN CATCH
        PRINT 'Error al intentar crear un nuevo puesto.'
    END CATCH
END;
GO

CREATE PROCEDURE sp_ReadPuesto
    @ID_puesto INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT * FROM PUESTO WHERE ID_puesto = @ID_puesto
    END TRY
    BEGIN CATCH
        PRINT 'Error al intentar leer información del puesto.'
    END CATCH
END;
GO


CREATE PROCEDURE sp_UpdatePuesto
    @ID_puesto INT,
    @nombre_puesto VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        UPDATE PUESTO
        SET nombre_puesto = @nombre_puesto
        WHERE ID_puesto = @ID_puesto
    END TRY
    BEGIN CATCH
        PRINT 'Error al intentar actualizar información del puesto.'
    END CATCH
END;
GO


CREATE PROCEDURE sp_DeletePuesto
    @ID_puesto INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DELETE FROM PUESTO WHERE ID_puesto = @ID_puesto
    END TRY
    BEGIN CATCH
        PRINT 'Error al intentar eliminar el puesto.'
    END CATCH
END;
GO


-- Premio

CREATE PROCEDURE sp_CreatePremio
    @Nombre VARCHAR(255),
    @Categoria VARCHAR(255),
    @Edicion INT,
    @ID_Pelicula INT,
    @ID_Persona INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO PREMIO(Nombre, Categoria, Edicion, ID_Pelicula, ID_Persona)
        VALUES (@Nombre, @Categoria, @Edicion, @ID_Pelicula, @ID_Persona)
    END TRY
    BEGIN CATCH
        PRINT 'Error al intentar crear un nuevo premio.'
    END CATCH
END;
GO


CREATE PROCEDURE sp_ReadPremio
    @ID_Premio INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT * FROM PREMIO WHERE ID_Premio = @ID_Premio
    END TRY
    BEGIN CATCH
        PRINT 'Error al intentar leer información del premio.'
    END CATCH
END;
GO


CREATE PROCEDURE sp_UpdatePremio
    @ID_Premio INT,
    @Nombre VARCHAR(255),
    @Categoria VARCHAR(255),
    @Edicion INT,
    @ID_Pelicula INT,
    @ID_Persona INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        UPDATE PREMIO
        SET Nombre = @Nombre,
            Categoria = @Categoria,
            Edicion = @Edicion,
            ID_Pelicula = @ID_Pelicula,
            ID_Persona = @ID_Persona
        WHERE ID_Premio = @ID_Premio
    END TRY
    BEGIN CATCH
        PRINT 'Error al intentar actualizar información del premio.'
    END CATCH
END;
GO


CREATE PROCEDURE sp_DeletePremio
    @ID_Premio INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DELETE FROM PREMIO WHERE ID_Premio = @ID_Premio
    END TRY
    BEGIN CATCH
        PRINT 'Error al intentar eliminar el premio.'
    END CATCH
END;
GO


-- Pelicula_puesto_persona

CREATE PROCEDURE sp_CreatePersonaPuestoPelicula
    @ID_Pelicula INT,
    @ID_Persona INT,
    @ID_Puesto INT
AS
BEGIN
    SET NOCOUNT ON;
        INSERT INTO PERSONA_PUESTO_PELICULA(ID_Pelicula, ID_Persona, ID_Puesto)
        VALUES (@ID_Pelicula, @ID_Persona, @ID_Puesto)
END;
GO

CREATE PROCEDURE sp_ReadPersonaPuestoPelicula
    @ID_Pelicula INT,
    @ID_Persona INT,
    @ID_Puesto INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT * FROM PERSONA_PUESTO_PELICULA
        WHERE ID_Pelicula = @ID_Pelicula AND ID_Persona = @ID_Persona AND ID_Puesto = @ID_Puesto
    END TRY
    BEGIN CATCH
        PRINT 'Error al intentar leer información de PERSONA_PUESTO_PELICULA.'
    END CATCH
END;
GO

CREATE PROCEDURE sp_UpdatePersonaPuestoPelicula
    @ID_Pelicula INT,
    @ID_Persona INT,
    @ID_Puesto_New INT,
    @ID_Puesto_Old INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        UPDATE PERSONA_PUESTO_PELICULA
        SET ID_Puesto = @ID_Puesto_New
        WHERE ID_Pelicula = @ID_Pelicula AND ID_Persona = @ID_Persona AND ID_Puesto = @ID_Puesto_Old
    END TRY
    BEGIN CATCH
        PRINT 'Error al intentar actualizar la asociación en PERSONA_PUESTO_PELICULA.'
    END CATCH
END;
GO

CREATE PROCEDURE sp_DeletePersonaPuestoPelicula
    @ID_Pelicula INT,
    @ID_Persona INT,
    @ID_Puesto INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DELETE FROM PERSONA_PUESTO_PELICULA
        WHERE ID_Pelicula = @ID_Pelicula AND ID_Persona = @ID_Persona AND ID_Puesto = @ID_Puesto
    END TRY
    BEGIN CATCH
        PRINT 'Error al intentar eliminar la asociación en PERSONA_PUESTO_PELICULA.'
    END CATCH
END;
GO

-------------------------- [ INSERCIÓN DE DATOS ] --------------------------

-------------------------- ( Puestos ) --------------------------

EXEC sp_CreatePuesto @nombre_puesto = 'Director';
EXEC sp_CreatePuesto @nombre_puesto = 'Productor';
EXEC sp_CreatePuesto @nombre_puesto = 'Actor Principal';
EXEC sp_CreatePuesto @nombre_puesto = 'Actriz Principal';
EXEC sp_CreatePuesto @nombre_puesto = 'Actor Secundario';
EXEC sp_CreatePuesto @nombre_puesto = 'Actriz Secundaria';
EXEC sp_CreatePuesto @nombre_puesto = 'Guionista';
EXEC sp_CreatePuesto @nombre_puesto = 'Director de Fotografía';
EXEC sp_CreatePuesto @nombre_puesto = 'Editor';
EXEC sp_CreatePuesto @nombre_puesto = 'Compositor Musical';
EXEC sp_CreatePuesto @nombre_puesto = 'Diseñador de Producción';
EXEC sp_CreatePuesto @nombre_puesto = 'Diseñador de Vestuario';
EXEC sp_CreatePuesto @nombre_puesto = 'Supervisor de Efectos Visuales';
EXEC sp_CreatePuesto @nombre_puesto = 'Coordinador de Dobles';
EXEC sp_CreatePuesto @nombre_puesto = 'Director de Arte';
EXEC sp_CreatePuesto @nombre_puesto = 'Sonidista';
EXEC sp_CreatePuesto @nombre_puesto = 'Maquillador';
EXEC sp_CreatePuesto @nombre_puesto = 'Casting';
EXEC sp_CreatePuesto @nombre_puesto = 'Asistente de Dirección';
EXEC sp_CreatePuesto @nombre_puesto = 'Gerente de Locación';

-------------------------- ( Premios ) --------------------------

EXEC sp_CreatePremio @Nombre = 'Oscar', @Categoria = 'Mejor Película', @Edicion = 92, @ID_Pelicula = NULL, @ID_Persona = NULL;
EXEC sp_CreatePremio @Nombre = 'Oscar', @Categoria = 'Mejor Director', @Edicion = 92, @ID_Pelicula = NULL, @ID_Persona = NULL;
EXEC sp_CreatePremio @Nombre = 'Oscar', @Categoria = 'Mejor Actor', @Edicion = 92, @ID_Pelicula = NULL, @ID_Persona = NULL;
EXEC sp_CreatePremio @Nombre = 'Oscar', @Categoria = 'Mejor Actriz', @Edicion = 92, @ID_Pelicula = NULL, @ID_Persona = NULL;
EXEC sp_CreatePremio @Nombre = 'Oscar', @Categoria = 'Mejor Guion Original', @Edicion = 92, @ID_Pelicula = NULL, @ID_Persona = NULL;
EXEC sp_CreatePremio @Nombre = 'Oscar', @Categoria = 'Mejor Fotografía', @Edicion = 92, @ID_Pelicula = NULL, @ID_Persona = NULL;
EXEC sp_CreatePremio @Nombre = 'Oscar', @Categoria = 'Mejores Efectos Visuales', @Edicion = 92, @ID_Pelicula = NULL, @ID_Persona = NULL;
EXEC sp_CreatePremio @Nombre = 'Oscar', @Categoria = 'Mejor Banda Sonora', @Edicion = 92, @ID_Pelicula = NULL, @ID_Persona = NULL;
EXEC sp_CreatePremio @Nombre = 'Oscar', @Categoria = 'Mejor Diseño de Vestuario', @Edicion = 92, @ID_Pelicula = NULL, @ID_Persona = NULL;
EXEC sp_CreatePremio @Nombre = 'Oscar', @Categoria = 'Mejor Montaje', @Edicion = 92, @ID_Pelicula = NULL, @ID_Persona = NULL;
EXEC sp_CreatePremio @Nombre = 'Globo de Oro', @Categoria = 'Mejor Película - Drama', @Edicion = 77, @ID_Pelicula = NULL, @ID_Persona = NULL;
EXEC sp_CreatePremio @Nombre = 'Globo de Oro', @Categoria = 'Mejor Director', @Edicion = 77, @ID_Pelicula = NULL, @ID_Persona = NULL;
EXEC sp_CreatePremio @Nombre = 'BAFTA', @Categoria = 'Mejor Película Británica', @Edicion = 73, @ID_Pelicula = NULL, @ID_Persona = NULL;
EXEC sp_CreatePremio @Nombre = 'BAFTA', @Categoria = 'Mejor Actor de Reparto', @Edicion = 73, @ID_Pelicula = NULL, @ID_Persona = NULL;
EXEC sp_CreatePremio @Nombre = 'Cannes', @Categoria = 'Palma de Oro', @Edicion = 72, @ID_Pelicula = NULL, @ID_Persona = NULL;
EXEC sp_CreatePremio @Nombre = 'Cannes', @Categoria = 'Gran Premio del Jurado', @Edicion = 72, @ID_Pelicula = NULL, @ID_Persona = NULL

-------------------------- ( Peliculas ) --------------------------

--------------------------  AVATAR  --------------------------

-- Insertar empresa productora
EXEC sp_CreateEmpresaProductora @Nombre = '20th Century Fox', @Pais = 'Estados Unidos';

-- Insertar géneros
EXEC sp_CreateGenero @Nombre = 'Acción', @Descripcion = 'Películas de acción';
EXEC sp_CreateGenero @Nombre = 'Aventura', @Descripcion = 'Películas de aventura';
EXEC sp_CreateGenero @Nombre = 'Fantasía', @Descripcion = 'Películas de fantasía';

-- Insertar película 'Avatar'
EXEC sp_CreatePelicula 
    @titulo = 'Avatar', 
    @fecha_lanzamiento = '2009-12-18', 
    @duracion = 162, 
    @sinopsis = 'Un ex-Marine se encuentra atrapado en hostilidades en un planeta lleno de exóticas formas de vida...', 
    @idioma = 'Inglés', 
    @presupuesto = 237000000.00, 
    @pais_lanzamiento = 'Estados Unidos', 
    @score_critica = 7.8, 
    @dinero_recaudado = 2787965087.00, 
    @id_empresa_productora = 1;

-- Asociar géneros con 'Avatar'
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 1, @ID_Genero = 1;
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 1, @ID_Genero = 2;
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 1, @ID_Genero = 3;

-- Insertar personas relacionadas con 'Avatar'
EXEC sp_CreatePersona @nombre = 'James Cameron', @fecha_nacimiento = '1954-08-16', @nacionalidad = 'Canadiense';

-- Insertar puesto 'Director'
EXEC sp_CreatePuesto @nombre_puesto = 'Director';

-- Asociar a James Cameron con 'Avatar' como director
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 1, @ID_Persona = 1, @ID_Puesto = 1;


--------------------------  WONKA  --------------------------

-- Insertar empresa productora
EXEC sp_CreateEmpresaProductora @Nombre = 'Warner Bros.', @Pais = 'USA';

-- Insertar géneros de la película
EXEC sp_CreateGenero @Nombre = 'Familia', @Descripcion = 'Películas familiares.';
EXEC sp_CreateGenero @Nombre = 'Fantasía', @Descripcion = 'Películas de fantasía.';

-- Insertar la película "Wonka"
EXEC sp_CreatePelicula 
    @titulo = 'Wonka', 
    @fecha_lanzamiento = '2023-03-17', 
    @duracion = 120, 
    @sinopsis = 'Una historia sobre los inicios del joven Willy Wonka y sus aventuras antes de abrir la fábrica de chocolate más famosa del mundo.', 
    @idioma = 'Inglés', 
    @presupuesto = 150000000, 
    @pais_lanzamiento = 'USA', 
    @score_critica = 8.5, 
    @dinero_recaudado = 0,	-- Suponiendo que aún no se ha estrenado o no hay datos de taquilla
    @id_empresa_productora = 2;

-- Asociar géneros con "Wonka"
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 2, @ID_Genero = 3;
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 2, @ID_Genero = 4;

-- Insertar personas relacionadas con "Wonka" (Director y Actor principal, por ejemplo)
EXEC sp_CreatePersona @nombre = 'Paul King', @fecha_nacimiento = '1978-02-20', @nacionalidad = 'Británico';
EXEC sp_CreatePersona @nombre = 'Timothée Chalamet', @fecha_nacimiento = '1995-12-27', @nacionalidad = 'Americano';

-- Insertar puestos (Director y Actor)
EXEC sp_CreatePuesto @nombre_puesto = 'Director';
EXEC sp_CreatePuesto @nombre_puesto = 'Actor';

-- Asociar personas a "Wonka" con sus puestos
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 2, @ID_Persona = 2, @ID_Puesto = 1; -- Paul King como Director
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 2, @ID_Persona = 3, @ID_Puesto = 3; -- Timothée Chalamet como Actor

-- Insertar premio asociado a "Wonka" (Hipotético)
EXEC sp_CreatePremio @Nombre = 'Premios de la Academia', @Categoria = 'Mejor Diseño de Producción', @Edicion = 2023, @ID_Pelicula = 2, @ID_Persona = NULL;

-------------------------------  MISION IMPOSIBLE 1 -------------------------------------------------

-- Insertar empresa productora
EXEC sp_CreateEmpresaProductora @Nombre = 'Paramount Pictures', @Pais = 'USA';

-- Insertar géneros de la película
EXEC sp_CreateGenero @Nombre = 'Acción', @Descripcion = 'Películas de acción';
EXEC sp_CreateGenero @Nombre = 'Espionaje', @Descripcion = 'Películas de espionaje';

-- Insertar la película "Misión Imposible 1"
EXEC sp_CreatePelicula 
    @titulo = 'Misión Imposible', 
    @fecha_lanzamiento = '1996-05-22', 
    @duracion = 110, 
    @sinopsis = 'Un agente secreto es acusado falsamente y debe usar sus habilidades para desenmascarar al verdadero traidor.', 
    @idioma = 'Inglés', 
    @presupuesto = 80000000, 
    @pais_lanzamiento = 'USA', 
    @score_critica = 7.1, 
    @dinero_recaudado = 457696359, 
    @id_empresa_productora = 3	;


-- Asociar géneros con "Misión Imposible 1"
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 3, @ID_Genero = 6;
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 3, @ID_Genero = 7;

-- Insertar personas (Director: Brian De Palma, Actor principal: Tom Cruise)
EXEC sp_CreatePersona @nombre = 'Brian De Palma', @fecha_nacimiento = '1940-09-11', @nacionalidad = 'Americano';
EXEC sp_CreatePersona @nombre = 'Tom Cruise', @fecha_nacimiento = '1962-07-03', @nacionalidad = 'Americano';


-- Asociar personas a "Misión Imposible 1" con sus puestos
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 3, @ID_Persona = 4, @ID_Puesto = 1; -- Brian De Palma como Director
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 3, @ID_Persona = 5, @ID_Puesto = 3; -- Tom Cruise como Actor

-- Insertar premio asociado a "Misión Imposible 1" (Hipotético)
EXEC sp_CreatePremio @Nombre = 'MTV Movie Awards', @Categoria = 'Mejor Película de Acción', @Edicion = 1996, @ID_Pelicula = 3, @ID_Persona = NULL;

-------------------------------  MISION IMPOSIBLE 2 -------------------------------------------------


-- Insertar la película "Misión Imposible 2"
EXEC sp_CreatePelicula 
    @titulo = 'Misión Imposible 2', 
    @fecha_lanzamiento = '2000-05-24', 
    @duracion = 123, 
    @sinopsis = 'Ethan Hunt debe recuperar un virus mortal antes de que caiga en manos equivocadas.', 
    @idioma = 'Inglés', 
    @presupuesto = 125000000, 
    @pais_lanzamiento = 'USA', 
    @score_critica = 6.1, 
    @dinero_recaudado = 546388105, 
    @id_empresa_productora = 3;

	EXEC sp_CreatePersona @nombre = 'John Woo', @fecha_nacimiento = '1946-05-01', @nacionalidad = 'Chino';

	EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 4, @ID_Persona = 6, @ID_Puesto = 1; -- John Woo como Director
	EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 4, @ID_Persona = 5, @ID_Puesto = 3; -- Tom Cruise como Actor

-- Insertar premio asociado a "Misión Imposible 2" (Ejemplo)
EXEC sp_CreatePremio @Nombre = 'Teen Choice Awards', @Categoria = 'Mejor Película de Acción/Aventura', @Edicion = 2000, @ID_Pelicula = 4, @ID_Persona = NULL;

-------------------------------  MISION IMPOSIBLE 3 -------------------------------------------------

EXEC sp_CreatePelicula 
    @titulo = 'Misión Imposible 3', 
    @fecha_lanzamiento = '2006-05-05', 
    @duracion = 126, 
    @sinopsis = 'El agente Ethan Hunt se enfrenta a un traficante de armas peligroso mientras trata de llevar una vida normal con su prometida.', 
    @idioma = 'Inglés', 
    @presupuesto = 150000000, 
    @pais_lanzamiento = 'USA', 
    @score_critica = 6.9, 
    @dinero_recaudado = 397850012, 
    @id_empresa_productora = 3;


-- Asociar géneros con "Misión Imposible 3"
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 5, @ID_Genero = 6; -- Acción
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 5, @ID_Genero = 7; -- Espionaje


-- Insertar personas (Director: J.J. Abrams, Actor principal: Tom Cruise)
EXEC sp_CreatePersona @nombre = 'J.J. Abrams', @fecha_nacimiento = '1966-06-27', @nacionalidad = 'Americano';

-- Asociar personas a "Misión Imposible 3" con sus puestos
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 5, @ID_Persona = 7, @ID_Puesto = 1; -- J.J. Abrams como Director
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 5, @ID_Persona = 5, @ID_Puesto = 3; -- Tom Cruise como Actor

-- Insertar premio asociado a "Misión Imposible 3"
EXEC sp_CreatePremio @Nombre = 'Saturn Awards', @Categoria = 'Mejor Actor', @Edicion = 2006, @ID_Pelicula = 5, @ID_Persona = 5;


-------------------------------  HUNGER GAMES -------------------------------------------------

-- Insertar empresa productora
EXEC sp_CreateEmpresaProductora @Nombre = 'Lionsgate', @Pais = 'USA';

-- Insertar géneros de la película
EXEC sp_CreateGenero @Nombre = 'Ciencia ficción', @Descripcion = 'Películas de ciencia ficción.';

-- Insertar la película "Los Juegos del Hambre"
EXEC sp_CreatePelicula 
    @titulo = 'Los Juegos del Hambre', 
    @fecha_lanzamiento = '2012-03-23', 
    @duracion = 142, 
    @sinopsis = 'Katniss Everdeen se ofrece voluntaria para participar en un concurso mortal en lugar de su hermana menor.', 
    @idioma = 'Inglés', 
    @presupuesto = 78000000, 
    @pais_lanzamiento = 'USA', 
    @score_critica = 7.2, 
    @dinero_recaudado = 694394724, 
    @id_empresa_productora = 4;

-- Asociar géneros con "Los Juegos del Hambre"
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 6, @ID_Genero = 2;
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 6, @ID_Genero = 8;



-- Insertar personas (Director: Gary Ross, Actores principales: Jennifer Lawrence, Josh Hutcherson)
EXEC sp_CreatePersona @nombre = 'Gary Ross', @fecha_nacimiento = '1956-11-03', @nacionalidad = 'Americano';
EXEC sp_CreatePersona @nombre = 'Jennifer Lawrence', @fecha_nacimiento = '1990-08-15', @nacionalidad = 'Americano';
EXEC sp_CreatePersona @nombre = 'Josh Hutcherson', @fecha_nacimiento = '1992-10-12', @nacionalidad = 'Americano';

-- Asociar personas a "Los Juegos del Hambre" con sus puestos
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 6, @ID_Persona = 8, @ID_Puesto = 1; -- Gary Ross como Director
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 6, @ID_Persona = 9, @ID_Puesto = 4; -- Jennifer Lawrence como Actriz
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 6, @ID_Persona = 10, @ID_Puesto = 3; -- Josh Hutcherson como Actor

-- Insertar premio asociado a "Los Juegos del Hambre" (Ejemplo)
EXEC sp_CreatePremio @Nombre = 'MTV Movie Awards', @Categoria = 'Mejor Película', @Edicion = 2012, @ID_Pelicula = 6, @ID_Persona = NULL;

-------------------------------  El padrino -------------------------------------------------

-- Insertar géneros de la película
EXEC sp_CreateGenero @Nombre = 'Crimen', @Descripcion = 'Películas de crimen.';
EXEC sp_CreateGenero @Nombre = 'Drama', @Descripcion = 'Películas de drama.';

-- Insertar la película "El Padrino"
EXEC sp_CreatePelicula 
    @titulo = 'El Padrino', 
    @fecha_lanzamiento = '1972-03-24', 
    @duracion = 175, 
    @sinopsis = 'El envejecido patriarca de una dinastía del crimen organizado decide transferir su puesto a su reticente hijo.', 
    @idioma = 'Inglés', 
    @presupuesto = 6000000, 
    @pais_lanzamiento = 'USA', 
    @score_critica = 9.2, 
    @dinero_recaudado = 245066411, 
    @id_empresa_productora = 3;

-- Asociar géneros con "El Padrino"
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 7, @ID_Genero = 9;
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 7, @ID_Genero = 10;


-- Insertar personas (Director: Francis Ford Coppola, Actores principales: Marlon Brando, Al Pacino)
EXEC sp_CreatePersona @nombre = 'Francis Ford Coppola', @fecha_nacimiento = '1939-04-07', @nacionalidad = 'Americano';
EXEC sp_CreatePersona @nombre = 'Marlon Brando', @fecha_nacimiento = '1924-04-03', @nacionalidad = 'Americano';
EXEC sp_CreatePersona @nombre = 'Al Pacino', @fecha_nacimiento = '1940-04-25', @nacionalidad = 'Americano';


-- Asociar personas a "El Padrino" con sus puestos
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 7, @ID_Persona = 11, @ID_Puesto = 1; -- Coppola como Director
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 7, @ID_Persona = 12, @ID_Puesto = 3; -- Brando como Actor
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 7, @ID_Persona = 13, @ID_Puesto = 3; -- Pacino como Actor

-- Insertar premio asociado a "El Padrino" (Ejemplo)
EXEC sp_CreatePremio @Nombre = 'Oscar', @Categoria = 'Mejor Película', @Edicion = 1972, @ID_Pelicula = 7, @ID_Persona = NULL;

-------------------------------  El padrino 2 -------------------------------------------------

-- Insertar la película "El Padrino Parte II"
EXEC sp_CreatePelicula 
    @titulo = 'El Padrino Parte II', 
    @fecha_lanzamiento = '1974-12-20', 
    @duracion = 202, 
    @sinopsis = 'La saga de la familia Corleone continúa, explorando la historia de un joven Vito Corleone y la expansión de Michael Corleone en el crimen organizado.', 
    @idioma = 'Inglés', 
    @presupuesto = 13000000, 
    @pais_lanzamiento = 'USA', 
    @score_critica = 9.0, 
    @dinero_recaudado = 102600000, 
    @id_empresa_productora = 3;

-- Asociar géneros con "El Padrino Parte II"
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 8, @ID_Genero = 9; -- Crimen
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 8, @ID_Genero = 10; -- Drama

-- Insertar personas (Director: Francis Ford Coppola, Actores principales: Al Pacino, Robert De Niro)
-- Coppola y Pacino ya fueron insertados, por lo tanto, solo insertaremos a Robert De Niro
EXEC sp_CreatePersona @nombre = 'Robert De Niro', @fecha_nacimiento = '1943-08-17', @nacionalidad = 'Americano';


-- Asociar personas a "El Padrino Parte II" con sus puestos
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 8, @ID_Persona = 11, @ID_Puesto = 1; -- Coppola como Director
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 8, @ID_Persona = 13, @ID_Puesto = 3; -- Pacino como Actor
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 8, @ID_Persona = 14, @ID_Puesto = 3; -- De Niro como Actor

-- Insertar premio asociado a "El Padrino Parte II" (Ejemplo)
EXEC sp_CreatePremio @Nombre = 'Oscar', @Categoria = 'Mejor Película', @Edicion = 1974, @ID_Pelicula = 8, @ID_Persona = NULL;

-------------------------------  El padrino 3 -------------------------------------------------

-- Insertar la película "El Padrino Parte III"
EXEC sp_CreatePelicula 
    @titulo = 'El Padrino Parte III', 
    @fecha_lanzamiento = '1990-12-25', 
    @duracion = 162, 
    @sinopsis = 'En medio de intentos de legitimar sus negocios, Michael Corleone busca redención. Sin embargo, se ve arrastrado nuevamente a la vorágine de la violencia.', 
    @idioma = 'Inglés', 
    @presupuesto = 54000000, 
    @pais_lanzamiento = 'USA', 
    @score_critica = 7.6, 
    @dinero_recaudado = 136766062, 
    @id_empresa_productora = 3;

-- Asociar géneros con "El Padrino Parte III"
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 9, @ID_Genero = 9; -- Crimen
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 9, @ID_Genero = 10; -- Drama

-- Insertar personas (Director: Francis Ford Coppola, Actores principales: Al Pacino, Andy Garcia)
-- Coppola y Pacino ya fueron insertados para las películas anteriores
EXEC sp_CreatePersona @nombre = 'Andy Garcia', @fecha_nacimiento = '1956-04-12', @nacionalidad = 'Cubano-Americano';

-- Asociar personas a "El Padrino Parte III" con sus puestos
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 9, @ID_Persona = 11, @ID_Puesto = 1; -- Coppola como Director
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 9, @ID_Persona = 13, @ID_Puesto = 3; -- Pacino como Actor
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 9, @ID_Persona = 15, @ID_Puesto = 3; -- Andy Garcia como Actor

-- Insertar premio asociado a "El Padrino Parte III" (Ejemplo)
EXEC sp_CreatePremio @Nombre = 'Oscar', @Categoria = 'Mejor Director', @Edicion = 1990, @ID_Pelicula = 9, @ID_Persona = 11;

-------------------------------  Rey Leon -------------------------------------------------

-- Insertar empresa productora: Disney
EXEC sp_CreateEmpresaProductora @Nombre = 'Walt Disney Pictures', @Pais = 'USA';

-- Insertar géneros de la película: Animación, Aventura, Drama
EXEC sp_CreateGenero @Nombre = 'Animación', @Descripcion = 'Películas de animación.';

-- Insertar la película "El Rey León"
EXEC sp_CreatePelicula 
    @titulo = 'El Rey León', 
    @fecha_lanzamiento = '1994-06-24', 
    @duracion = 88, 
    @sinopsis = 'Un joven príncipe león es desplazado de su orgullo por su tío, quien afirma el trono y lidera el orgullo a la ruina.', 
    @idioma = 'Inglés', 
    @presupuesto = 45000000, 
    @pais_lanzamiento = 'USA', 
    @score_critica = 8.5, 
    @dinero_recaudado = 968511805, 
    @id_empresa_productora = 5;


-- Asociar géneros con "El Rey León"
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 10, @ID_Genero = 11;
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 10, @ID_Genero = 2;
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 10, @ID_Genero = 10;

-- Insertar directores: Roger Allers y Rob Minkoff
EXEC sp_CreatePersona @nombre = 'Roger Allers', @fecha_nacimiento = '1949-06-29', @nacionalidad = 'Americano';
EXEC sp_CreatePersona @nombre = 'Rob Minkoff', @fecha_nacimiento = '1962-08-11', @nacionalidad = 'Americano';

-- Insertar voz principal: Matthew Broderick como Simba (Adulto)
EXEC sp_CreatePersona @nombre = 'Matthew Broderick', @fecha_nacimiento = '1962-03-21', @nacionalidad = 'Americano';

-- Asociar personas a "El Rey León" con sus puestos
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 10, @ID_Persona = 16, @ID_Puesto = 1; -- Allers como Director
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 10, @ID_Persona = 17, @ID_Puesto = 1; -- Minkoff como Director
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 10, @ID_Persona = 18, @ID_Puesto = 3; -- Broderick como Actor (Voz)

-- Insertar premio asociado a "El Rey León": Oscar a la Mejor Canción Original por "Can You Feel the Love Tonight"
EXEC sp_CreatePremio @Nombre = 'Oscar', @Categoria = 'Mejor Canción Original', @Edicion = 1994, @ID_Pelicula = 10, @ID_Persona = NULL;

-------------------------------  Frozen  -------------------------------------------------

-- Asumiendo que la empresa productora Walt Disney Animation Studios ya ha sido insertada, se usa su ID correspondiente.

-- Insertar la película "Frozen"
EXEC sp_CreatePelicula 
    @titulo = 'Frozen', 
    @fecha_lanzamiento = '2013-11-27', 
    @duracion = 102, 
    @sinopsis = 'Anna se embarca en un viaje con un hombre de montaña, su reno, y un muñeco de nieve para encontrar a su hermana Elsa, cuyos poderes han atrapado al reino en un invierno eterno.', 
    @idioma = 'Inglés', 
    @presupuesto = 150000000, 
    @pais_lanzamiento = 'USA', 
    @score_critica = 7.5, 
    @dinero_recaudado = 1274219009, 
    @id_empresa_productora = 5;

-- Asociar géneros con "Frozen"
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 11, @ID_Genero = 11; -- Animación
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 11, @ID_Genero = 2; -- Aventura
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 11, @ID_Genero = 4; -- Familiar

-- Insertar personas: Directores y actores principales de voz
EXEC sp_CreatePersona @nombre = 'Chris Buck', @fecha_nacimiento = '1958-02-24', @nacionalidad = 'Americano';
EXEC sp_CreatePersona @nombre = 'Jennifer Lee', @fecha_nacimiento = '1971-10-22', @nacionalidad = 'Americano';
EXEC sp_CreatePersona @nombre = 'Idina Menzel', @fecha_nacimiento = '1971-05-30', @nacionalidad = 'Americano';
EXEC sp_CreatePersona @nombre = 'Kristen Bell', @fecha_nacimiento = '1980-07-18', @nacionalidad = 'Americano';

-- Asociar personas a "Frozen" con sus puestos
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 11, @ID_Persona = 19, @ID_Puesto = 1; -- Chris Buck como Director
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 11, @ID_Persona = 20, @ID_Puesto = 1; -- Jennifer Lee como Director
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 11, @ID_Persona = 21, @ID_Puesto = 4; -- Idina Menzel como Elsa
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 11, @ID_Persona = 22, @ID_Puesto = 4; -- Kristen Bell como Anna

-- Insertar premios asociados a "Frozen"
EXEC sp_CreatePremio @Nombre = 'Oscar', @Categoria = 'Mejor Película Animada', @Edicion = 2014, @ID_Pelicula = 11, @ID_Persona = NULL;

-------------------------------  Pulp Fiction -------------------------------------------------

-- Insertar empresa productora: Miramax
EXEC sp_CreateEmpresaProductora @Nombre = 'Miramax Films', @Pais = 'USA';

-- Insertar la película "Pulp Fiction"
EXEC sp_CreatePelicula 
    @titulo = 'Pulp Fiction', 
    @fecha_lanzamiento = '1994-10-14', 
    @duracion = 154, 
    @sinopsis = 'Las vidas de dos mafiosos, un boxeador, la esposa de un gángster y un par de bandidos se entrelazan en cuatro historias de violencia y redención.', 
    @idioma = 'Inglés', 
    @presupuesto = 8000000, 
    @pais_lanzamiento = 'USA', 
    @score_critica = 8.9, 
    @dinero_recaudado = 214179889, 
    @id_empresa_productora = 6;

-- Asociar géneros con "Pulp Fiction"
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 12, @ID_Genero = 10;
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 12, @ID_Genero = 9;

-- Insertar personas: Director Quentin Tarantino, Actores principales John Travolta, Uma Thurman
EXEC sp_CreatePersona @nombre = 'Quentin Tarantino', @fecha_nacimiento = '1963-03-27', @nacionalidad = 'Americano';
EXEC sp_CreatePersona @nombre = 'John Travolta', @fecha_nacimiento = '1954-02-18', @nacionalidad = 'Americano';
EXEC sp_CreatePersona @nombre = 'Uma Thurman', @fecha_nacimiento = '1970-04-29', @nacionalidad = 'Americano';


-- Asociar personas a "Pulp Fiction" con sus puestos
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 12, @ID_Persona = 23, @ID_Puesto = 1; -- Tarantino como Director
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 12, @ID_Persona = 24, @ID_Puesto = 3; -- Travolta como Actor
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 12, @ID_Persona = 25, @ID_Puesto = 3; -- Thurman como Actriz

-- Insertar premio asociado a "Pulp Fiction": Palma de Oro en Cannes
EXEC sp_CreatePremio @Nombre = 'Festival de Cannes', @Categoria = 'Palma de Oro', @Edicion = 1994, @ID_Pelicula = 12, @ID_Persona = NULL;

-------------------------------  Shakespeare in Love -------------------------------------------------

-- Insertar géneros de la película: Comedia, Drama, Romance
EXEC sp_CreateGenero @Nombre = 'Comedia', @Descripcion = 'Películas cómicas.';
EXEC sp_CreateGenero @Nombre = 'Romance', @Descripcion = 'Películas románticas.';

-- Insertar la película "Shakespeare in Love"
EXEC sp_CreatePelicula 
    @titulo = 'Shakespeare in Love', 
    @fecha_lanzamiento = '1998-12-11', 
    @duracion = 123, 
    @sinopsis = 'Un joven Shakespeare, con falta de ideas y dinero corto, conoce a su musa ideal y se ve inspirado para escribir una de sus obras más famosas.', 
    @idioma = 'Inglés', 
    @presupuesto = 25000000, 
    @pais_lanzamiento = 'USA', 
    @score_critica = 7.1, 
    @dinero_recaudado = 289317794, 
    @id_empresa_productora = 6;


-- Asociar géneros con "Shakespeare in Love"
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 13, @ID_Genero = 12;
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 13, @ID_Genero = 10;
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 13, @ID_Genero = 13;

-- Insertar personas: Director (John Madden) y actores principales (Gwyneth Paltrow, Joseph Fiennes)
EXEC sp_CreatePersona @nombre = 'John Madden', @fecha_nacimiento = '1949-04-08', @nacionalidad = 'Británico';
EXEC sp_CreatePersona @nombre = 'Gwyneth Paltrow', @fecha_nacimiento = '1972-09-27', @nacionalidad = 'Americano';
EXEC sp_CreatePersona @nombre = 'Joseph Fiennes', @fecha_nacimiento = '1970-05-27', @nacionalidad = 'Británico';

-- Asociar personas a "Shakespeare in Love" con sus puestos
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 13, @ID_Persona = 26, @ID_Puesto = 1; -- Madden como Director
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 13, @ID_Persona = 27, @ID_Puesto = 4; -- Paltrow como Actriz
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 13, @ID_Persona = 28, @ID_Puesto = 3; -- Fiennes como Actor

-- Insertar premio asociado a "Shakespeare in Love": Oscar a la Mejor Película
EXEC sp_CreatePremio @Nombre = 'Oscar', @Categoria = 'Mejor Película', @Edicion = 1999, @ID_Pelicula = 13, @ID_Persona = NULL;

-------------------------------  Oceans love -------------------------------------------------

-- Insertar la película "Ocean's Eleven"
EXEC sp_CreatePelicula 
    @titulo = 'Ocean''s Eleven', 
    @fecha_lanzamiento = '2001-12-07', 
    @duracion = 116, 
    @sinopsis = 'Danny Ocean y su equipo de once personas planean robar un casino.', 
    @idioma = 'Inglés', 
    @presupuesto = 85000000, 
    @pais_lanzamiento = 'USA', 
    @score_critica = 7.8, 
    @dinero_recaudado = 450717150, 
    @id_empresa_productora = 2;

-- Asociar géneros con "Ocean's Eleven"
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 14, @ID_Genero = 9; -- Crimen
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 14, @ID_Genero = 12; -- Comedia


EXEC sp_CreatePersona @nombre = 'George Clooney', @fecha_nacimiento = '1961-05-06', @nacionalidad = 'Americano';

-- Asociar actores a "Ocean's Eleven" con sus puestos
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 14, @ID_Persona = 25, @ID_Puesto = 4; -- Uma Thurman como Actriz (ejemplo hipotético)
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 14, @ID_Persona = 29, @ID_Puesto = 3; -- George Clooney como Actor

-- Insertar premio asociado a "Ocean's Eleven" (ejemplo hipotético)
EXEC sp_CreatePremio @Nombre = 'MTV Movie Awards', @Categoria = 'Mejor Equipo en Pantalla', @Edicion = 2002, @ID_Pelicula = 14, @ID_Persona = NULL;

-------------------------------  Django unchained -------------------------------------------------

-- Insertar géneros de la película: Western, Drama
EXEC sp_CreateGenero @Nombre = 'Western', @Descripcion = 'Películas del oeste.';

-- Insertar la película "Django Unchained"
EXEC sp_CreatePelicula 
    @titulo = 'Django Unchained', 
    @fecha_lanzamiento = '2012-12-25', 
    @duracion = 165, 
    @sinopsis = 'Con la ayuda de un cazarrecompensas alemán, un esclavo liberado se propone rescatar a su esposa de un brutal dueño de una plantación de Mississippi.', 
    @idioma = 'Inglés', 
    @presupuesto = 100000000, 
    @pais_lanzamiento = 'USA', 
    @score_critica = 8.4, 
    @dinero_recaudado = 425368238, 
    @id_empresa_productora = 6;

-- Asociar géneros con "Django Unchained"
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 15, @ID_Genero = 14; -- Western
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 15, @ID_Genero = 10; -- Drama

-- Insertar actores principales: Jamie Foxx como Django, Christoph Waltz como Dr. King Schultz
EXEC sp_CreatePersona @nombre = 'Jamie Foxx', @fecha_nacimiento = '1967-12-13', @nacionalidad = 'Americano';
EXEC sp_CreatePersona @nombre = 'Christoph Waltz', @fecha_nacimiento = '1956-10-04', @nacionalidad = 'Austriaco';

-- Asociar director y actores a "Django Unchained" con sus puestos
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 15, @ID_Persona = 23, @ID_Puesto = 1; -- Tarantino como Director
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 15, @ID_Persona = 30, @ID_Puesto = 3; -- Foxx como Actor
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 15, @ID_Persona = 31, @ID_Puesto = 3; -- Waltz como Actor

-- Insertar premio asociado a "Django Unchained": Oscar al Mejor Guión Original
EXEC sp_CreatePremio @Nombre = 'Oscar', @Categoria = 'Mejor Guión Original', @Edicion = 2013, @ID_Pelicula = 15, @ID_Persona =  NULL;

-------------------------------  Kill bill v1 -------------------------------------------------

-- Insertar la película "Kill Bill: Vol. 1"
EXEC sp_CreatePelicula 
    @titulo = 'Kill Bill: Vol. 1', 
    @fecha_lanzamiento = '2003-10-10', 
    @duracion = 111, 
    @sinopsis = 'Despertando de un coma de cuatro años, una ex-asesina busca venganza contra el equipo de asesinos que la traicionó.', 
    @idioma = 'Inglés', 
    @presupuesto = 30000000, 
    @pais_lanzamiento = 'USA', 
    @score_critica = 8.1, 
    @dinero_recaudado = 180000000, 
    @id_empresa_productora = 6;

-- Asociar géneros con "Kill Bill: Vol. 1"
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 16, @ID_Genero = 1; -- Acción
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 16, @ID_Genero = 9; -- Crimen

-- Insertar actores principales: Uma Thurman como La Novia, Lucy Liu como O-Ren Ishii
EXEC sp_CreatePersona @nombre = 'Lucy Liu', @fecha_nacimiento = '1968-12-02', @nacionalidad = 'Americana';

-- Asociar director y actores a "Kill Bill: Vol. 1" con sus puestos
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 16, @ID_Persona = 23, @ID_Puesto = 1; -- Tarantino como Director
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 16, @ID_Persona = 25, @ID_Puesto = 4; -- Thurman como Actriz
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 16, @ID_Persona = 32, @ID_Puesto = 4; -- Liu como Actriz

-- Insertar premio asociado a "Kill Bill: Vol. 1" (Ejemplo hipotético)
EXEC sp_CreatePremio @Nombre = 'MTV Movie Award', @Categoria = 'Mejor Pelea', @Edicion = 2004, @ID_Pelicula = 16, @ID_Persona = NULL;


-------------------------------  Kill bill v2 -------------------------------------------------

-- Insertar la película "Kill Bill: Vol. 2"
EXEC sp_CreatePelicula 
    @titulo = 'Kill Bill: Vol. 2', 
    @fecha_lanzamiento = '2004-04-16', 
    @duracion = 137, 
    @sinopsis = 'La Novia continúa su venganza contra su ex-jefe, Bill, y sus dos restantes asociados; su hermano Budd, y la única amante de Bill, Elle Driver.', 
    @idioma = 'Inglés', 
    @presupuesto = 30000000, 
    @pais_lanzamiento = 'USA', 
    @score_critica = 8.0, 
    @dinero_recaudado = 152159461, 
    @id_empresa_productora = 6;


-- Asociar géneros con "Kill Bill: Vol. 2"
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 17, @ID_Genero = 1; -- Acción
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 17, @ID_Genero = 9; -- Crimen

-- Reutilizar actores principales: Uma Thurman como La Novia, reutilizando a David Carradine como Bill
EXEC sp_CreatePersona @nombre = 'David Carradine', @fecha_nacimiento = '1936-12-08', @nacionalidad = 'Americano';

-- Asociar director y actores a "Kill Bill: Vol. 2" con sus puestos
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 17, @ID_Persona = 23, @ID_Puesto = 1; -- Tarantino como Director
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 17, @ID_Persona = 25, @ID_Puesto = 4; -- Thurman como Actriz
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 17, @ID_Persona = 33, @ID_Puesto = 3; -- Carradine como Actor

-- Insertar premio asociado a "Kill Bill: Vol. 2" (Ejemplo hipotético)
EXEC sp_CreatePremio @Nombre = 'Golden Globe', @Categoria = 'Mejor Actriz', @Edicion = 2005, @ID_Pelicula = 17, @ID_Persona = 25;

-------------------------------  Unforgiven -------------------------------------------------

-- Insertar empresa productora: Malpaso Productions
EXEC sp_CreateEmpresaProductora @Nombre = 'Malpaso Productions', @Pais = 'USA';

-- Insertar la película "Unforgiven"
EXEC sp_CreatePelicula 
    @titulo = 'Unforgiven', 
    @fecha_lanzamiento = '1992-08-07', 
    @duracion = 131, 
    @sinopsis = 'William Munny, un pistolero retirado, toma un último trabajo con la ayuda de su viejo socio y un joven pistolero.', 
    @idioma = 'Inglés', 
    @presupuesto = 14400000, 
    @pais_lanzamiento = 'USA', 
    @score_critica = 8.2, 
    @dinero_recaudado = 159157447, 
    @id_empresa_productora = 7;


-- Asociar géneros con "Unforgiven"
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 18, @ID_Genero = 14; -- Western
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 18, @ID_Genero = 10; -- Drama

-- Insertar Clint Eastwood como director y actor principal
EXEC sp_CreatePersona @nombre = 'Clint Eastwood', @fecha_nacimiento = '1930-05-31', @nacionalidad = 'Americano';

-- Insertar otros actores principales: Morgan Freeman como Ned Logan
EXEC sp_CreatePersona @nombre = 'Morgan Freeman', @fecha_nacimiento = '1937-06-01', @nacionalidad = 'Americano';

-- Asociar Clint Eastwood y Morgan Freeman a "Unforgiven" con sus puestos
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 18, @ID_Persona = 34, @ID_Puesto = 1; -- Eastwood como Director y Actor
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 18, @ID_Persona = 34, @ID_Puesto = 3; -- Eastwood como Director y Actor
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 18, @ID_Persona = 35, @ID_Puesto = 3; -- Freeman como Actor

-- Insertar premio asociado a "Unforgiven": Oscar a la Mejor Película
EXEC sp_CreatePremio @Nombre = 'Oscar', @Categoria = 'Mejor Película', @Edicion = 1993, @ID_Pelicula = 18, @ID_Persona = NULL;

-------------------------------  Gran Torino -------------------------------------------------


-- Insertar la película "Gran Torino"
EXEC sp_CreatePelicula 
    @titulo = 'Gran Torino', 
    @fecha_lanzamiento = '2008-12-12', 
    @duracion = 116, 
    @sinopsis = 'Descontento con la evolución de su vecindario y el mundo, el veterano de la Guerra de Corea, Walt Kowalski, se propone reformar a su vecino, un adolescente Hmong que intentó robarle.', 
    @idioma = 'Inglés', 
    @presupuesto = 33000000, 
    @pais_lanzamiento = 'USA', 
    @score_critica = 8.1, 
    @dinero_recaudado = 270000000, 
    @id_empresa_productora = 2;

-- Asociar géneros con "Gran Torino"
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 19, @ID_Genero = 10;

-- Insertar otro actor principal: Bee Vang como Thao Vang Lor
EXEC sp_CreatePersona @nombre = 'Bee Vang', @fecha_nacimiento = '1991-11-04', @nacionalidad = 'Americano';

-- Asociar Clint Eastwood y Bee Vang a "Gran Torino" con sus puestos
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 19, @ID_Persona = 34, @ID_Puesto = 1; -- Eastwood como Director y Actor
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 19, @ID_Persona = 34, @ID_Puesto = 3; -- Eastwood como Director y Actor
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 19, @ID_Persona = 36, @ID_Puesto = 3; -- Bee Vang como Actor

-- Insertar premio asociado a "Gran Torino" (ejemplo hipotético)
EXEC sp_CreatePremio @Nombre = 'National Board of Review', @Categoria = 'Mejor Actor', @Edicion = 2008, @ID_Pelicula = 19, @ID_Persona = 36;

-------------------------------  HARRY POTTER 1 -------------------------------------------------

-- Insertar la película "Harry Potter y la Piedra Filosofal"
EXEC sp_CreatePelicula 
    @titulo = 'Harry Potter y la Piedra Filosofal', 
    @fecha_lanzamiento = '2001-11-16', 
    @duracion = 152, 
    @sinopsis = 'Harry Potter, un huérfano, descubre que es un mago y es enviado a la Escuela Hogwarts de Magia y Hechicería. Allí, encuentra amigos, enemigos y enfrenta a Lord Voldemort.', 
    @idioma = 'Inglés', 
    @presupuesto = 125000000, 
    @pais_lanzamiento = 'Reino Unido', 
    @score_critica = 7.6, 
    @dinero_recaudado = 974755371, 
    @id_empresa_productora = 2;


-- Asociar géneros con "Harry Potter y la Piedra Filosofal"
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 20, @ID_Genero = 2; -- Aventura
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 20, @ID_Genero = 3; -- Fantasía
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 20, @ID_Genero = 4; -- Familia

-- Insertar director: Chris Columbus
EXEC sp_CreatePersona @nombre = 'Chris Columbus', @fecha_nacimiento = '1958-09-10', @nacionalidad = 'Americano';

-- Insertar actores principales: Daniel Radcliffe como Harry Potter, Emma Watson como Hermione Granger, Rupert Grint como Ron Weasley
EXEC sp_CreatePersona @nombre = 'Daniel Radcliffe', @fecha_nacimiento = '1989-07-23', @nacionalidad = 'Británico';
EXEC sp_CreatePersona @nombre = 'Emma Watson', @fecha_nacimiento = '1990-04-15', @nacionalidad = 'Británica';
EXEC sp_CreatePersona @nombre = 'Rupert Grint', @fecha_nacimiento = '1988-08-24', @nacionalidad = 'Británico';

-- Asociar director y actores a "Harry Potter y la Piedra Filosofal" con sus puestos
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 20, @ID_Persona = 37, @ID_Puesto = 1; -- Columbus como Director
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 20, @ID_Persona = 38, @ID_Puesto = 3; -- Radcliffe como Actor
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 20, @ID_Persona = 39, @ID_Puesto = 4; -- Watson como Actriz
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 20, @ID_Persona = 40, @ID_Puesto = 3; -- Grint como Actor

-------------------------------  HARRY POTTER 2 -------------------------------------------------

-- Insertar la película "Harry Potter y la Cámara Secreta"
EXEC sp_CreatePelicula 
    @titulo = 'Harry Potter y la Cámara Secreta', 
    @fecha_lanzamiento = '2002-11-15', 
    @duracion = 161, 
    @sinopsis = 'Harry Potter regresa para su segundo año en Hogwarts, donde descubre una oscura fuerza que aterroriza a la escuela con mensajes enigmáticos y ataques contra los estudiantes.', 
    @idioma = 'Inglés', 
    @presupuesto = 100000000, 
    @pais_lanzamiento = 'Reino Unido', 
    @score_critica = 7.4, 
    @dinero_recaudado = 879465482, 
    @id_empresa_productora = 2;

-- Asociar géneros con "Harry Potter y la Cámara Secreta"
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 21, @ID_Genero = 2; -- Aventura
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 21, @ID_Genero = 3; -- Fantasía
EXEC sp_CreatePeliculaGenero @ID_Pelicula = 21, @ID_Genero = 4; -- Familia

-- Asociar director y actores a "Harry Potter y la Cámara Secreta" con sus puestos
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 21, @ID_Persona = 37, @ID_Puesto = 1; -- Columbus como Director
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 21, @ID_Persona = 38, @ID_Puesto = 3; -- Radcliffe como Actor
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 21, @ID_Persona = 39, @ID_Puesto = 4; -- Watson como Actriz
EXEC sp_CreatePersonaPuestoPelicula @ID_Pelicula = 21, @ID_Persona = 40, @ID_Puesto = 3; -- Grint como Actor

-- Insertar premio asociado a "Harry Potter y la Cámara Secreta" (Ejemplo)
EXEC sp_CreatePremio @Nombre = 'BAFTA', @Categoria = 'Mejores Efectos Visuales', @Edicion = 2003, @ID_Pelicula = 21, @ID_Persona = NULL;
