
USE football_manager;
SELECT * FROM lligues;

-- 1r Consulta
SELECT equips.nom, equips.any_fundacio, equips.nom_president, ciutats.nom, estadis.nom, estadis.num_espectadors
FROM equips
JOIN ciutats ON ciutats.id = equips.ciutats_id
JOIN estadis ON estadis.id = equips.estadis_id
WHERE estadis.num_espectadors BETWEEN 3000 AND 5000
ORDER BY estadis.num_espectadors asc; 

-- 2n Consulta
SELECT ciutats.nom, equips.nom, persones.nom, persones.cognoms
FROM entrenadors
JOIN persones ON persones.id = entrenadors.persones_id
JOIN entrenar_equips ON entrenar_equips.entrenadors_id = entrenadors.persones_id
JOIN equips ON equips.id = entrenar_equips.equips_id
JOIN ciutats ON ciutats.id = equips.ciutats_id
WHERE ciutats.nom IN  ('Barcelona', 'Madrid', 'Sevilla') 
AND persones.nom NOT LIKE 'F%'  AND persones.cognoms LIKE '%e%'; 

-- 3r Consulta
SELECT /*equips.id,*/ equips.nom, SUM(punts) AS 'Puntuacio_Total'
FROM (
	SELECT partits.equips_id_local AS 'equips_id', partits.punts_local AS 'punts'
    FROM partits
    JOIN equips ON equips.id = partits.equips_id_local AND partits.equips_id_visitant
    JOIN participar_lligues ON participar_lligues.equips_id = equips.id
	JOIN lligues ON  lligues.id = participar_lligues.lligues_id
	WHERE lligues.nom = 'La Liga EA Sports' AND lligues.temporada = 2024
    
    UNION ALL
    
    SELECT partits.equips_id_visitant AS 'equips_id', partits.punts_visitant AS 'punts'
    FROM partits
    JOIN equips ON equips.id = partits.equips_id_local AND partits.equips_id_visitant
    JOIN participar_lligues ON participar_lligues.equips_id = equips.id
	JOIN lligues ON  lligues.id = participar_lligues.lligues_id
	WHERE lligues.nom = 'La Liga EA Sports' AND lligues.temporada = 2024
    ) AS equipos
JOIN equips ON equips.id = equipos.equips_id
GROUP BY equips.nom/*, equips.id*/
ORDER BY Puntuacio_Total DESC;


-- 4t Consulta
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


-- 5ta Consulta
SELECT posicions.posicio, count(*) AS 'Nombre_Jugadors'
FROM jugadors
JOIN posicions ON posicions.id = jugadors.posicions_id
JOIN jugadors_equips ON jugadors_equips.jugadors_id = jugadors.persones_id
JOIN equips ON equips.id = jugadors_equips.equips_id
JOIN participar_lligues ON participar_lligues.equips_id = equips.id
JOIN lligues ON lligues.id = participar_lligues.lligues_id
WHERE lligues.nom = 'La Liga EA Sports' AND lligues.temporada = 2024 AND jugadors_equips.data_baixa IS NULL
GROUP BY posicions.posicio
ORDER BY posicions.posicio desc;



-- 6a Consulta
SELECT jornades.data, jornades.jornada, equips_local.nom AS 'Nom_Equip_Local', partits.gols_local, equips_visitant.nom AS 'Nom_Equip_Visitant', partits.gols_visitant
FROM partits
JOIN equips AS equips_local ON equips_local.id = partits.equips_id_local
JOIN equips AS equips_visitant ON equips_visitant.id = partits.equips_id_visitant
JOIN jornades ON jornades.id = partits.jornades_id 
JOIN lligues ON lligues.id = jornades.lligues_id
WHERE lligues.nom = 'La Liga EA Sports' AND lligues.temporada = 2024 AND (equips_local.nom = 'FC Barcelona' or equips_visitant.nom = 'FC Barcelona' )
ORDER BY jornades.data asc; 



-- 7a Consulta
SELECT jornades.data AS 'Fecha_Jornada', jornades.jornada, equips_local.nom AS 'Nombre_Equip_Local', 
equips_visitant.nom AS 'Nom_Equip_Visitant', partits.gols_local, partits.gols_visitant
 ,partits_gols.minut, persones.nom AS 'Nom_Jugadors', persones.cognoms AS 'Cognoms_Jugador', partits_gols.es_penal
FROM lligues
JOIN jornades ON jornades.lligues_id = lligues.id
JOIN partits ON partits.jornades_id = jornades.id
JOIN equips AS equips_local ON equips_local.id = partits.equips_id_local
JOIN equips AS equips_visitant ON equips_visitant.id = partits.equips_id_visitant
JOIN partits_gols ON partits_gols.partits_id = partits.id
JOIN jugadors ON jugadors.persones_id = partits_gols.jugadors_id
JOIN jugadors_equips ON jugadors_equips.jugadors_id = jugadors.persones_id 
JOIN persones ON persones.id = jugadors.persones_id
WHERE lligues.nom = 'La Liga EA Sports' AND lligues.temporada = 2024 AND ( equips_local.nom = 'FC Barcelona' OR equips_visitant.nom = 'FC Barcelona' )
ORDER BY partits_gols.minut asc;



-- 8va Consulta
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
/*Buscar els jugadors que cobrin entre 7.000.000 i 12.000.000, tinguin un nivell
 de motivació igual o superior a 85 i l'any de la seva data de naixement sigui
 1959 o 1985 o 1992. Ordenar pel sou de major a menor.*/












USE football_manager;
SELECT * FROM lligues;

