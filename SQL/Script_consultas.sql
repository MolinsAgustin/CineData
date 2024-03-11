-- 1. Listar todas las películas lanzadas en USA:
SELECT 
	titulo, 
	sinopsis, 
	duracion 
FROM PELICULA
WHERE pais_lanzamiento='USA'

--	2. Mostrar la lista de personas, con el puesto ocupado y la película en cuestión:

SELECT 
persona.nombre as 'Persona', 
puesto.nombre_puesto as 'Puesto',
pelicula.titulo as 'Pelicula'
from pelicula join PERSONA_PUESTO_PELICULA
on pelicula.ID_pelicula=PERSONA_PUESTO_PELICULA.ID_Pelicula
join puesto on  PERSONA_PUESTO_PELICULA.ID_Puesto=puesto.ID_puesto
join persona on persona.ID_persona=PERSONA_PUESTO_PELICULA.ID_Persona

--	3. Obtener los personajes interpretados por una persona en particular (Uma Thurman)

SELECT nombre_personaje, 
	titulo,
	nombre
from personaje 
join pelicula on personaje.ID_Pelicula=pelicula.ID_pelicula
join persona on personaje.ID_Interprete=persona.ID_persona
where nombre='Uma Thurman'

--		4. Mostrar todas las películas dirigidas por Tarantino

SELECT 
	TITULO, 
	SINOPSIS,
	fecha_lanzamiento
FROM PELICULA
JOIN PERSONA_PUESTO_PELICULA
ON PERSONA_PUESTO_PELICULA.ID_Pelicula=PELICULA.ID_pelicula
JOIN PUESTO ON PERSONA_PUESTO_PELICULA.ID_Puesto=PUESTO.ID_puesto
JOIN PERSONA ON PERSONA_PUESTO_PELICULA.ID_PERSONA=PERSONA.ID_persona
WHERE PUESTO.nombre_puesto='Director' and PERSONA.nombre='Quentin Tarantino'


--		5. Mostrar todas las peliculas en las que el dinero recaudado supere al costo por al menos 15  millones.

select * from pelicula
SELECT 
	TITULO, 
	SINOPSIS,
	fecha_lanzamiento
FROM PELICULA
WHERE dinero_recaudado-presupuesto>150000000


--		6. Mostrar todas las películas con los géneros a los que pertenecen: 

SELECT 
	TITULO, 
	SINOPSIS,
	--fecha_lanzamiento, 
	NOMBRE
FROM PELICULA join PELICULA_GENERO
ON PELICULA.ID_pelicula=PELICULA_GENERO.ID_Pelicula
JOIN GENERO ON GENERO.ID_Genero=PELICULA_GENERO.ID_Genero


--		7. Obtener todos las premios que haya ganado una película:

Select nombre,
	categoria,
	edicion
from premio join pelicula
on premio.ID_Pelicula=pelicula.ID_pelicula
where titulo='Avatar'


--		8. Mostrar la información de todas las películas en las que una persona ha trabajado como director.

SELECT p.Titulo, p.fecha_Lanzamiento
FROM Pelicula p
JOIN Persona_Puesto_Pelicula pp ON p.ID_Pelicula = pp.ID_Pelicula
JOIN Puesto ps ON pp.ID_Puesto = ps.ID_Puesto
JOIN Persona pe ON pp.ID_Persona = pe.ID_Persona
WHERE pe.Nombre = 'NombreDeLaPersona' AND ps.nombre_puesto = 'director';

--		9. Mostrar la lista de todas las personas que han interpretado un personaje en una película específica y el nombre del personaje.


SELECT pe.Nombre, pc.Nombre_Personaje
FROM Persona pe
JOIN Personaje pc ON pe.ID_Persona = pc.ID_Interprete
WHERE pc.ID_Pelicula = 1;

--		10. Obtener la lista de todas las películas que han ganado premios en una categoría específica.

SELECT p.Titulo, pr.Nombre AS Premio, pr.Edicion
FROM Pelicula p
JOIN Premio pr ON p.ID_Pelicula = pr.ID_Pelicula
WHERE pr.Categoria = 'NombreDeLaCategoria';

--		11. Obtener la lista de todas las películas de un género específico lanzadas en un país determinado.

SELECT p.Titulo, p.fecha_Lanzamiento, g.Nombre AS Genero, p.Pais_Lanzamiento
FROM Pelicula p
JOIN Pelicula_Genero pg ON p.ID_Pelicula = pg.ID_Pelicula
JOIN Genero g ON pg.ID_Genero = g.ID_Genero
WHERE g.Nombre = 'NombreDelGenero' AND p.Pais_Lanzamiento = 'NombreDelPais';

--		12. Encontrar todas las películas en las que una persona ha ganado un premio.

SELECT p.Titulo, pr.Nombre AS Premio, pr.Categoria, pr.Edicion
FROM Pelicula p
JOIN Premio pr ON p.ID_Pelicula = pr.ID_Pelicula
JOIN Persona pe ON pr.ID_Persona = pe.ID_Persona
WHERE pe.Nombre = 'NombreDeLaPersona';


--		13. Obtener la lista de películas ordenadas por su score de crítica de manera descendente.
SELECT Titulo, Score_Critica
FROM Pelicula
ORDER BY Score_Critica DESC;

--		14. Encontrar todas las películas lanzadas después de cierta fecha.

SELECT Titulo, fecha_Lanzamiento
FROM Pelicula
WHERE fecha_Lanzamiento > '2023-01-01';


--		15.Mostrar la cantidad total de premios ganados por una película específica.

SELECT p.Titulo, COUNT(pr.ID_Premio) AS TotalPremios
FROM Pelicula p
LEFT JOIN Premio pr ON p.ID_Pelicula = pr.ID_Pelicula
WHERE p.ID_Pelicula = 1
GROUP BY p.Titulo;

--		16. Obtener la lista de personas que han interpretado un personaje en una película específica.

SELECT pe.Nombre, ps.nombre_puesto, pc.Nombre_Personaje
FROM Persona pe
JOIN Persona_Puesto_Pelicula pp ON pe.ID_Persona = pp.ID_Persona
JOIN Puesto ps ON pp.ID_Puesto = ps.ID_Puesto
JOIN Personaje pc ON pe.ID_Persona = pc.ID_Interprete
WHERE pc.ID_Pelicula = 1;


--		17. Obtener la lista de todas las personas que han ganado un premio en una categoría específica.

SELECT pe.Nombre, pr.Nombre AS Premio, pr.Categoria, pr.Edicion
FROM Persona pe
JOIN Premio pr ON pe.ID_Persona = pr.ID_Persona
WHERE pr.Categoria = 'Mejor Director';

--		18. Encontrar todas las películas en las que un actor específico haya trabajado.

SELECT p.Titulo, p.fecha_Lanzamiento, ps.nombre_puesto
FROM Pelicula p
JOIN Persona_Puesto_Pelicula pp ON p.ID_Pelicula = pp.ID_Pelicula
JOIN Puesto ps ON pp.ID_Puesto = ps.ID_Puesto
JOIN Persona pe ON pp.ID_Persona = pe.ID_Persona
WHERE pe.Nombre = 'NombreDelActor' AND ps.nombre_puesto = 'actor';


--		19. Mostrar la duración promedio de todas las películas.

SELECT AVG(Duracion) AS DuracionPromedio
FROM Pelicula;


--		20. Encontrar todas las películas lanzadas en un año específico.

SELECT Titulo, fecha_Lanzamiento
FROM Pelicula
WHERE YEAR(fecha_Lanzamiento) = 2009;
