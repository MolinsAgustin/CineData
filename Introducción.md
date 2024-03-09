Nuestra idea es armar un modelo sobre una base de datos basado en la industria cinematográfica.
 
En el desarrollo de una base de datos enfocada en la industria cinematográfica, nos proponemos crear un sistema funcional y accesible que sirva como un recurso informativo sobre películas, directores, actores, géneros y premios. La visión detrás de este proyecto es sencilla: proporcionar una herramienta práctica que enriquezca el conocimiento y la apreciación del cine para aficionados, críticos y profesionales del sector. Este sistema estará diseñado para ser un punto de partida para aquellos que buscan explorar el vasto mundo del cine, ofreciendo información esencial y facilitando el descubrimiento de nuevas películas y talentos emergentes.
 
El propósito es crear una base de datos cinematográfica que destaque por su excelencia en el séptimo arte. Esta colección será un universo de películas icónicas, estrellas brillantes, géneros destacados y reconocimientos prestigiosos. Aunque no pretendemos abarcar toda la historia del cine ni incluir cada película producida, nuestro objetivo es presentar una muestra variada y representativa del fascinante mundo cinematográfico.
 
Entonces, para comenzar a hablar de las relaciones entre nuestras tablas sabemos que cada película tiene su empresa productora de las cuales sabemos su nombre acompañado del país en el cual trabaja cada productora.

Luego encontramos que cada película tendrá asignado un género correspondiente mediante la tabla PelículaGenero que incluye nombre de este, un id y una descripción de este.

Para realizar el rodaje de una película necesitamos gente que trabaje en la misma, por ende, tenemos una tabla vinculada llamada PuestoPelicula vinculada con una tabla intermedia PersonaPuestoPelicula. Aquí se incluye información sobre el oficio de la persona tales como actor/actriz, director, escritor.

Una película puede haber ganado uno o varios premios, y un premio puede ser otorgado a una o varias películas. La relación se establece mediante la tabla Premio, que tiene un campo ID_Pelicula que referencia el ID de la película ganadora.

Creemos que con estas  relaciones y las descripciones que brindamos, se puede gestionar eficazmente la información sobre las películas, las empresas productoras, los géneros, las personas que participan en las películas y los premios que estas reciben.
