USE football_manager;
SELECT * FROM lligues;

-- 1r Consulta
/*Donat el nom de la lliga i la temporada. Es vol realitzar una
 consulta que retorni el nom de l'equip, l'any de fundació , el
 nom del president, el nom de la ciutat de l'equip, el nom de
 l'estadi i el nombre d'espectadors que tinguin un estadi
 entre 3.000 i 5.000 espectadors. Ordenar pel nombre
 d'espectadors de major a menor. Utilitzar alies per
 identificar millor les dades retornades.*/
SELECT equips.nom AS 'Nom_Equips', equips.any_fundacio AS 'Equip_AnyFundacio', equips.nom_president AS 'President_Equip', ciutats.nom AS 'Ciutat_Nom', estadis.nom AS 'Estadi_Nom', estadis.num_espectadors AS 'Nº Espectadors_Estadi'
FROM equips
JOIN ciutats ON ciutats.id = equips.ciutats_id
JOIN estadis ON estadis.id = equips.estadis_id
JOIN participar_lligues ON participar_lligues.equips_id = equips.id
JOIN lligues ON lligues.id = participar_lligues.lligues_id
WHERE estadis.num_espectadors BETWEEN 3000 AND 5000
AND lligues.nom = 'Liga F Moeve'
AND lligues.temporada = 2024
ORDER BY estadis.num_espectadors DESC; 

-- 2n Consulta
/*Mostrar la ciutat, el nom de l'equip i el nom i cognom de l'entrenadors. Dels equips que siguin de 'Barcelona', 'Madrid' o 'Sevilla i que el nom del seu entrenador no comenci per 'F' i el seu cognom contingui la 'e'.*/
SELECT ciutats.nom, equips.nom, persones.nom, persones.cognoms
FROM entrenadors
JOIN persones ON persones.id = entrenadors.persones_id
JOIN entrenar_equips ON entrenar_equips.entrenadors_id = entrenadors.persones_id
JOIN equips ON equips.id = entrenar_equips.equips_id
JOIN ciutats ON ciutats.id = equips.ciutats_id
WHERE ciutats.nom IN  ('Barcelona', 'Madrid', 'Sevilla') 
AND persones.nom NOT LIKE 'F%'  AND persones.cognoms LIKE '%e%'; 

-- 3r Consulta       +Corregit
/*Donat el nom de la lliga i la temporada. Mostrar la classificació de la lliga amb el nom de l'equip i la puntuació total. Ordenar els equips pel nombre de punts de major a menor.*/
SELECT equips.nom, SUM(equipos.punts) AS 'Puntuacio_Total'
FROM (
-- Punts Local
	SELECT partits.equips_id_local AS 'equips_id', partits.punts_local AS 'punts'
    FROM partits
    JOIN participar_lligues ON participar_lligues.equips_id = partits.equips_id_local
	JOIN lligues ON  lligues.id = participar_lligues.lligues_id
	WHERE lligues.nom = 'La Liga EA Sports' AND lligues.temporada = 2024
    
    UNION ALL
    
    SELECT partits.equips_id_visitant AS 'equips_id', partits.punts_visitant AS 'punts'
    FROM partits
    JOIN participar_lligues ON participar_lligues.equips_id = partits.equips_id_visitant
	JOIN lligues ON  lligues.id = participar_lligues.lligues_id
	WHERE lligues.nom = 'La Liga EA Sports' AND lligues.temporada = 2024
    ) AS equipos
JOIN equips ON equips.id = equipos.equips_id
GROUP BY equips.nom
ORDER BY Puntuacio_Total DESC;




-- 4t Consulta
/*Mostrar l'entrenador i els jugadors d'un equip donat. S'ha de mostrar el nom de l'equip, el tipus de persona, el nom i el cognoms de l'entrenador o jugador concatenats i amb un espai al mig.*/
SELECT equips.nom, persones.tipus_persona, CONCAT(persones.nom, ' ' ,persones.cognoms) AS 'Nombre_Completo'
FROM persones
JOIN entrenadors ON entrenadors.persones_id = persones.id
JOIN entrenar_equips ON entrenar_equips.entrenadors_id = entrenadors.persones_id
JOIN equips ON equips.id = entrenar_equips.equips_id 
WHERE equips.id = 1

UNION

SELECT equips.nom, persones.tipus_persona, CONCAT(persones.nom, ' ' ,persones.cognoms) AS 'Nombre_Completo'
FROM persones
JOIN jugadors ON jugadors.persones_id = persones.id
JOIN jugadors_equips ON jugadors_equips.jugadors_id = jugadors.persones_id
JOIN equips ON equips.id = jugadors_equips.equips_id
WHERE equips.id = 1;


-- 5ta Consulta        + Corregit
/*Donat un nom de lliga i una temporada, comptar el nombre de jugadors per cada posició. Mostrar la posició i el nombre de jugadors. Ordenar  per la posició en ordre alfabètic. Només s'han de mostrar els jugadors que estiguin d'alta.*/
SELECT posicions.posicio, count(*) AS 'Nombre_Jugadors'
FROM jugadors
JOIN posicions ON posicions.id = jugadors.posicions_id
JOIN jugadors_equips ON jugadors_equips.jugadors_id = jugadors.persones_id
JOIN equips ON equips.id = jugadors_equips.equips_id
JOIN participar_lligues ON participar_lligues.equips_id = equips.id
JOIN lligues ON lligues.id = participar_lligues.lligues_id
WHERE lligues.nom = 'La Liga EA Sports' AND lligues.temporada = 2024 AND jugadors_equips.data_baixa IS NULL
GROUP BY posicions.posicio
ORDER BY posicions.posicio ASC;



-- 6a Consulta
/*Donat el nom de la lliga, la temporada i el nom d'un equip, seleccionar tots els partits jugats per aquest equip en la temporada. Mostrar la data de la joranda, la jornada, el nom de l'equip local, el gols de l'equip local. els gols de l'equip visitant, el nom de l'equip visitant. S'han d'ordenar per la data de la jornada de menor a major.*/
SELECT jornades.data, jornades.jornada, equips_local.nom AS 'Nom_Equip_Local', partits.gols_local, equips_visitant.nom AS 'Nom_Equip_Visitant', partits.gols_visitant
FROM partits
JOIN equips AS equips_local ON equips_local.id = partits.equips_id_local
JOIN equips AS equips_visitant ON equips_visitant.id = partits.equips_id_visitant
JOIN jornades ON jornades.id = partits.jornades_id 
JOIN lligues ON lligues.id = jornades.lligues_id
WHERE lligues.nom = 'La Liga EA Sports' AND lligues.temporada = 2024 AND (equips_local.nom = 'FC Barcelona' or equips_visitant.nom = 'FC Barcelona' )
ORDER BY jornades.data asc; 



-- 7a Consulta  +Corregit
/*Donada una lliga, una temporada, un equip local i un equip visitant, seleccionar els gols marcats en aquest partit.
 Mostrar la data i la jornada en la que van jugar,  el nom de l'equip local, el nom de l'equip visitant, els gols de l'equip local, 
 els gols de l'equip visitant, el minut del gol, el nom i cognoms del jugador que ha fet gol, l'equip al que pertany el jugador i si ha estat de penalti o no. Ordenar la informació pel minut del gol.*/
SELECT jornades.data AS 'Fecha_Jornada', jornades.jornada, equips_local.nom AS 'Nombre_Equip_Local', 
equips_visitant.nom AS 'Nom_Equip_Visitant', partits.gols_local, partits.gols_visitant
 ,partits_gols.minut, persones.nom AS 'Nom_Jugadors', persones.cognoms AS 'Cognoms_Jugador', equips.nom AS 'Equip_Jugador', partits_gols.es_penal 
FROM lligues
JOIN jornades ON jornades.lligues_id = lligues.id
JOIN partits ON partits.jornades_id = jornades.id
JOIN equips AS equips_local ON equips_local.id = partits.equips_id_local
JOIN equips AS equips_visitant ON equips_visitant.id = partits.equips_id_visitant
JOIN partits_gols ON partits_gols.partits_id = partits.id
JOIN jugadors ON jugadors.persones_id = partits_gols.jugadors_id
JOIN jugadors_equips ON jugadors_equips.jugadors_id = jugadors.persones_id 
JOIN persones ON persones.id = jugadors.persones_id
JOIN equips ON equips.id = jugadors_equips.equips_id
WHERE lligues.nom = 'La Liga EA Sports' AND lligues.temporada = 2024 AND equips_local.nom = 'FC Barcelona' AND equips_visitant.nom = 'Real Madrid CF' 
ORDER BY partits_gols.minut ASC;



-- 8va Consulta
/*Donada una lliga i una temporada, calcular els gols que ha marcat cada jugador. Mostrar els nom i cognoms del jugador i el nombre de gols. S'ha d'ordenar pel nombre de gols major a menor, i només s'han de mostrar el 10 màxims golejadors.*/
SELECT persones.nom, persones.cognoms, COUNT(partits_gols.jugadors_id) AS 'Gols'
FROM persones
JOIN jugadors ON jugadors.persones_id = persones.id
JOIN partits_gols ON partits_gols.jugadors_id = jugadors.persones_id
JOIN partits ON partits.id = partits_gols.partits_id
JOIN jornades ON jornades.id = partits.jornades_id
JOIN lligues ON lligues.id = jornades.lligues_id
WHERE lligues.nom = 'La Liga EA Sports' AND lligues.temporada = 2024
GROUP BY persones.nom, persones.cognoms
ORDER BY Gols desc
LIMIT 10;



-- 9na Consulta 
/*Buscar els jugadors que cobrin entre 7.000.000 i 12.000.000, tinguin un nivell de motivació igual o superior a 85 i l'any de la seva data de naixement sigui 1959 o 1985 o 1992. Ordenar pel sou de major a menor.*/
SELECT concat(persones.nom, ' ', persones.cognoms) AS 'Nom_Complet_Jugador', persones.sou AS 'Salari_Rango', persones.nivell_motivacio, YEAR(persones.data_naixement) AS 'Any_Naixement'
FROM persones
JOIN jugadors ON jugadors.persones_id = persones.id
WHERE persones.sou BETWEEN 7000000 AND 12000000
AND persones.nivell_motivacio >= 85 AND YEAR(persones.data_naixement) IN (1959, 1985, 1992)
ORDER BY persones.sou desc;

 
-- 10ma Consulta          +Corregit
/*Donat el nom d'una lliga i la temporada. Mostrar el noms dels equips i la mitja de qualitat del seus jugadors. Només mostrar els equips que tinguin una mitja superior a 80, amb dos decimals. Ordenar per la mitja de menor a major.*/
SELECT equips.nom AS 'Nom_Equip', ROUND(AVG(jugadors.qualitat), 2) AS 'Mitja_qualitat_Jugadors'
FROM jugadors
JOIN jugadors_equips ON jugadors_equips.jugadors_id = jugadors.persones_id
JOIN equips ON equips.id = jugadors_equips.equips_id
JOIN participar_lligues ON participar_lligues.equips_id = equips.id
JOIN lligues ON lligues.id = participar_lligues.lligues_id
WHERE lligues.nom = 'La Liga EA Sports' AND lligues.temporada = 2024 
GROUP BY equips.nom
HAVING AVG(jugadors.qualitat) > 80
ORDER BY Mitja_qualitat_Jugadors ASC;


-- 11va Consulta 
/*Mostar el nom de l'equip i el nom de l'equip filial, de tots els equips que tinguin filial.*/
SELECT equips.nom AS 'Nom_Equips', equips_filial.nom AS 'Nom_equips_Filial'
FROM equips
JOIN equips AS equips_filial ON equips_filial.id = equips.filial_equips_id;
		

-- 12va Consulta
/*Quins equips tenen més de 3 jugadors amb una qualitat superior a 85?*/
SELECT equips.nom, COUNT(jugadors_equips.jugadors_id) AS Nº_Jugadors
FROM equips
JOIN jugadors_equips ON jugadors_equips.equips_id = equips.id
JOIN jugadors ON jugadors.persones_id = jugadors_equips.jugadors_id 
WHERE jugadors.qualitat > 85
GROUP BY equips.nom
HAVING COUNT(jugadors_equips.jugadors_id) > 3;


-- 13va Consulta
/*Quina és la mitjana d'edat, amb dos decimals, dels jugadors
 de cada equip? Ordénala de major a menor*/
SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, persones.data_naixement, CURDATE())), 2) AS Media_EdadJugador, equips.nom
FROM equips
JOIN jugadors_equips ON jugadors_equips.equips_id = equips.id
JOIN jugadors ON jugadors.persones_id = jugadors_equips.jugadors_id
JOIN persones ON persones.id = jugadors.persones_id
GROUP BY equips.nom
ORDER BY Media_EdadJugador desc;



-- 14va Consulta
/*Donat el nom d'una lliga i la temporada. Mostrar el màxim golejador*/
/*1r opció de resolució(fàcil) */
SELECT persones.nom AS 'Nom_Jugador', persones.cognoms AS 'Cognoms_Jugador', COUNT(partits_gols.minut) AS 'Gols_Jugador'
FROM persones
JOIN jugadors ON jugadors.persones_id = persones.id
JOIN partits_gols ON partits_gols.jugadors_id = jugadors.persones_id
JOIN partits ON partits.id = partits_gols.partits_id
JOIN jornades ON jornades.id = partits.jornades_id
JOIN lligues ON lligues.id = jornades.lligues_id
WHERE lligues.nom = 'La Liga EA Sports'
AND lligues.temporada = 2024
GROUP BY persones.id
ORDER BY Gols_Jugador DESC
LIMIT 1;

/*2n opció de resolució(dificultad)*/
SELECT persones.nom AS 'Nom_Jugador', persones.cognoms AS 'Cognoms_Jugador', COUNT(partits_gols.minut) AS 'Gols_Jugador'
FROM persones
JOIN jugadors ON jugadors.persones_id = persones.id
JOIN partits_gols ON partits_gols.jugadors_id = jugadors.persones_id
JOIN partits ON partits.id = partits_gols.partits_id
JOIN jornades ON jornades.id = partits.jornades_id
JOIN lligues ON lligues.id = jornades.lligues_id
WHERE lligues.nom = 'La Liga EA Sports'
AND lligues.temporada = 2024
GROUP BY persones.id
HAVING COUNT(partits_gols.minut) = (
        SELECT MAX(Total_Gols)
        FROM (
            SELECT COUNT(*) AS Total_Gols
            FROM partits_gols
            JOIN partits ON partits.id = partits_gols.partits_id
            JOIN jornades ON jornades.id = partits.jornades_id
            JOIN lligues ON lligues.id = jornades.lligues_id
            WHERE lligues.nom = 'La Liga EA Sports'
            AND lligues.temporada = 2024
            GROUP BY partits_gols.jugadors_id
        ) AS Gols
);



-- 15a Consulta
/* Donada una lliga i una temporada. Mostrar el dorsal, el nom i cognoms
 del jugador, i el nom de l'equip on juga de tots els defenses que han
 marcat més de 5 gols */
SELECT jugadors.dorsal, CONCAT(persones.nom, ' ', persones.cognoms) AS Nom_Complet_Jugador, equips.nom AS Equip_Nom, COUNT(partits_gols.minut) AS Gols_Defensas
FROM persones
JOIN jugadors ON jugadors.persones_id = persones.id
JOIN posicions ON posicions.id = jugadors.posicions_id
JOIN jugadors_equips ON jugadors_equips.jugadors_id = jugadors.persones_id
JOIN equips ON equips.id = jugadors_equips.equips_id
JOIN partits_gols ON partits_gols.jugadors_id = jugadors_equips.jugadors_id
JOIN partits ON partits.id = partits_gols.partits_id
JOIN jornades ON jornades.id = partits.jornades_id
JOIN lligues ON lligues.id = jornades.lligues_id
WHERE lligues.nom = 'La Liga EA Sports' AND lligues.temporada = 2024 AND posicions.id = 2
GROUP BY jugadors.persones_id, equips.nom
HAVING COUNT(partits_gols.minut) > 5;



-- 16a Consulta
/*Donada una lliga i una temporada. Mostrar els gols marcats per l'equip
 amb nom 'Girona FC'. S'han de comptar tant de local com de visitant.*/
SELECT equips.nom AS 'Equip_Nom', COUNT(partits_gols.minut) AS 'Gols_Marcats'
FROM partits_gols
JOIN jugadors ON jugadors.persones_id = partits_gols.jugadors_id
JOIN jugadors_equips ON jugadors_equips.jugadors_id = jugadors.persones_id
JOIN equips ON equips.id = jugadors_equips.equips_id
JOIN partits ON partits.id = partits_gols.partits_id 
JOIN jornades ON jornades.id = partits.jornades_id
JOIN lligues ON lligues.id = jornades.lligues_id
WHERE lligues.nom = 'La Liga EA Sports' AND lligues.temporada = 2024 AND equips.nom = 'Girona FC';

-- 17ma Consulta
/*Donada una lliga i una temporada. Mostrar el nom de l'equip i els gols
 marcats, de tots els equips que han marcat els mateixos o més gols que els
 marcats per l'equip amb nom 'Girona FC'. Ordenar el resultat descendentment per nombre total de gols.*/
SELECT equips.nom AS 'Nom_Equip', COUNT(partits_gols.minut) AS Gols_Marcats
FROM equips
JOIN jugadors_equips ON jugadors_equips.equips_id = equips.id
JOIN jugadors ON jugadors.persones_id = jugadors_equips.jugadors_id
JOIN partits_gols ON partits_gols.jugadors_id = jugadors.persones_id
JOIN partits ON partits.id = partits_gols.partits_id
JOIN jornades ON jornades.id = partits.jornades_id
JOIN lligues ON lligues.id = jornades.lligues_id
WHERE lligues.nom = 'La Liga EA Sports' AND lligues.temporada = 2024 
GROUP BY equips.nom
HAVING COUNT(partits_gols.minut) >= (
	SELECT COUNT(partits_gols.minut) 
    FROM partits_gols
    JOIN jugadors ON jugadors.persones_id = partits_gols.jugadors_id
    JOIN jugadors_equips ON jugadors_equips.jugadors_id = jugadors.persones_id
    JOIN equips ON equips.id = jugadors_equips.equips_id
    JOIN partits ON partits.id = partits_gols.partits_id
	JOIN jornades ON jornades.id = partits.jornades_id
	JOIN lligues ON lligues.id = jornades.lligues_id
	WHERE lligues.nom = 'La Liga EA Sports' AND lligues.temporada = 2024
    AND equips.nom = 'Girona FC'
) 
ORDER BY Gols_Marcats DESC; 


USE football_manager; 
SELECT * FROM lligues;
